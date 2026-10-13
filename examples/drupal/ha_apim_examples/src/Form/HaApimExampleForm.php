<?php

namespace Drupal\ha_apim_examples\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Sign in at https://developer-api.humanitarianaction.info and ask the API team for a key.
 * Set APIM_SUBSCRIPTION_KEY in the web/PHP process environment; never commit it.
 * All HTTP requests happen on the Drupal server. The browser never receives the key.
 */
class HaApimExampleForm extends FormBase {

  public function getFormId(): string {
    return 'ha_apim_example_form';
  }

  public function buildForm(array $form, FormStateInterface $form_state): array {
    $form['instructions'] = [
      '#type' => 'container',
      'text' => ['#plain_text' => 'OCHA users sign in with Microsoft Entra ID; external users sign up with email and password. Ask the API team to add you to the product and give you a key. Configure the key on the Drupal server.'],
      'portal' => ['#type' => 'link', '#title' => 'Open developer portal', '#url' => \Drupal\Core\Url::fromUri('https://developer-api.humanitarianaction.info')],
    ];
    $form['endpoint'] = ['#plain_text' => 'API endpoint: https://api.humanitarianaction.info/graphql/v1'];
    $form['example'] = [
      '#type' => 'select', '#title' => $this->t('Query'),
      '#options' => ['currency' => 'Currency by code', 'plan' => 'Plan by ID', 'currencies' => 'Paginated currencies'],
      '#default_value' => 'currency',
    ];
    $form['code'] = ['#type' => 'textfield', '#title' => $this->t('Currency code'), '#default_value' => 'USD'];
    $form['plan_id'] = ['#type' => 'number', '#title' => $this->t('Plan ID'), '#default_value' => 1202, '#min' => 1, '#max' => 2147483647];
    $form['page_size'] = ['#type' => 'number', '#title' => $this->t('Currencies per page'), '#default_value' => 100, '#min' => 1, '#max' => 1000];
    $form['max_records'] = ['#type' => 'number', '#title' => $this->t('Maximum currencies to retrieve'), '#default_value' => 1000, '#min' => 1, '#max' => 1000];
    $form['submit'] = ['#type' => 'submit', '#value' => $this->t('Call API')];
    $result = $form_state->get('result');
    if ($result !== NULL) {
      $form['summary'] = ['#plain_text' => count($result['items']) . ' row(s) returned. ' . ($result['hasNextPage'] ? 'More records are available.' : '')];
      $columns = $result['example'] === 'plan' ? ['Id', 'Name', 'PlanCode', 'StartDate', 'EndDate'] : ['Id', 'Code'];
      $rows = [];
      foreach ($result['items'] as $item) {
        $row = [];
        foreach ($columns as $column) {
          // Render arrays escape text; do not insert API values into raw HTML.
          $row[] = ['data' => ['#plain_text' => (string) ($item[$column] ?? '')]];
        }
        $rows[] = $row;
      }
      $form['results'] = ['#type' => 'table', '#header' => $columns, '#rows' => $rows, '#empty' => $this->t('No matching records.')];
      $form['json'] = ['#type' => 'details', '#title' => $this->t('Complete JSON result'), 'content' => ['#type' => 'html_tag', '#tag' => 'pre', 'text' => ['#plain_text' => json_encode($result['data'], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE)]]];
    }
    // This page contains live results for the current user; do not cache them.
    $form['#cache']['max-age'] = 0;
    return $form;
  }

  public function validateForm(array &$form, FormStateInterface $form_state): void {
    if ($form_state->getValue('example') === 'currency' && trim((string) $form_state->getValue('code')) === '') {
      $form_state->setErrorByName('code', $this->t('Enter a currency code.'));
    }
    // Only validate parameters used by the selected query.
    $fields = $form_state->getValue('example') === 'plan' ? ['plan_id' => 2147483647] : ($form_state->getValue('example') === 'currencies' ? ['page_size' => 1000, 'max_records' => 1000] : []);
    foreach ($fields as $field => $maximum) {
      $value = filter_var($form_state->getValue($field), FILTER_VALIDATE_INT);
      if ($value === FALSE || $value < 1 || $value > $maximum) {
        $form_state->setErrorByName($field, $this->t('Enter a whole number between 1 and @maximum.', ['@maximum' => $maximum]));
      }
    }
  }

  /** Send one GraphQL request with Drupal's existing HTTP client. */
  private function execute(string $file, array $variables, string $key): array {
    $query = file_get_contents(__DIR__ . '/../../queries/' . $file);
    if ($query === FALSE) {
      throw new \RuntimeException('Could not read the query file.');
    }
    $endpoint = getenv('APIM_ENDPOINT') ?: 'https://api.humanitarianaction.info/graphql/v1';
    $response = \Drupal::httpClient()->post($endpoint, [
      'headers' => ['Accept' => 'application/json', 'Content-Type' => 'application/json', 'Ocp-Apim-Subscription-Key' => $key],
      'json' => ['query' => $query, 'variables' => $variables],
      'timeout' => 110,
      'http_errors' => FALSE,
    ]);
    $text = (string) $response->getBody();
    if ($response->getStatusCode() < 200 || $response->getStatusCode() >= 300) {
      throw new \RuntimeException('HTTP ' . $response->getStatusCode() . ': ' . $text);
    }
    $body = json_decode($text, TRUE, 512, JSON_THROW_ON_ERROR);
    if (!empty($body['errors'])) {
      throw new \RuntimeException('GraphQL errors: ' . json_encode($body['errors']));
    }
    if (!isset($body['data']) || !is_array($body['data'])) {
      throw new \RuntimeException('The response did not contain a GraphQL data object.');
    }
    return $body['data'];
  }

  public function submitForm(array &$form, FormStateInterface $form_state): void {
    $form_state->set('result', NULL);
    try {
      $key = trim(getenv('APIM_SUBSCRIPTION_KEY') ?: '');
      if ($key === '' || $key === 'replace-with-your-subscription-key') {
        throw new \RuntimeException('Configure APIM_SUBSCRIPTION_KEY on the server. Ask the API team to add you to the product and give you a key.');
      }
      $example = $form_state->getValue('example');
      $has_next_page = FALSE;
      if ($example === 'currency') {
        $data = $this->execute('currency-by-code.graphql', ['code' => strtoupper(trim((string) $form_state->getValue('code')))], $key);
        $items = $data['currencies']['items'] ?? NULL;
        $has_next_page = (bool) ($data['currencies']['hasNextPage'] ?? FALSE);
      }
      elseif ($example === 'plan') {
        $data = $this->execute('plan-by-id.graphql', ['planId' => (int) $form_state->getValue('plan_id')], $key);
        $items = $data['plans']['items'] ?? NULL;
      }
      else {
        $page_size = (int) $form_state->getValue('page_size');
        $max_records = (int) $form_state->getValue('max_records');
        $items = $seen_cursors = [];
        $after = NULL;
        do {
          $first = min($page_size, $max_records - count($items));
          $page_data = $this->execute('currencies-page.graphql', ['first' => $first, 'after' => $after], $key);
          $page = $page_data['currencies'] ?? [];
          if (!isset($page['items']) || !is_array($page['items'])) {
            throw new \RuntimeException('Missing currencies items array.');
          }
          $items = array_merge($items, array_slice($page['items'], 0, $first));
          $has_next_page = (bool) $page['hasNextPage'];
          if (!$has_next_page || count($items) >= $max_records) {
            break;
          }
          $after = $page['endCursor'];
          if (!$after || isset($seen_cursors[$after])) {
            throw new \RuntimeException('Pagination stopped: missing or repeated cursor.');
          }
          $seen_cursors[$after] = TRUE;
        } while (TRUE);
        $data = ['items' => $items, 'returnedCount' => count($items), 'hasNextPage' => $has_next_page, 'stoppedAtConfiguredLimit' => $has_next_page && count($items) >= $max_records];
      }
      if (!is_array($items)) {
        throw new \RuntimeException('Missing query result items array.');
      }
      $form_state->set('result', ['example' => $example, 'items' => $items, 'hasNextPage' => $has_next_page, 'data' => $data]);
    }
    catch (\Throwable $error) {
      $this->messenger()->addError($this->t('Query failed: @message', ['@message' => $error->getMessage()]));
    }
    $form_state->setRebuild(TRUE);
  }

}

