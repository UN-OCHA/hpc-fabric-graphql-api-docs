# Drupal (PHP) example

OCHA users sign in at <https://developer-api.humanitarianaction.info> with
their `@un.org` account using Microsoft Entra ID. External users sign up with
email and password. Subscribe for a key (approval may be required).

Endpoint: `https://api.humanitarianaction.info/graphql/v1`.

This is a small custom module for an **existing Drupal 10.3+/11 site**. Use the
PHP version supported by your installed Drupal version. There is no separate
Drupal installation or additional Composer dependency in this package.

1. Copy the entire `ha_apim_examples/` folder into your site's
   `web/modules/custom/` directory (or `modules/custom/` if that is your Drupal root).
2. Configure `APIM_SUBSCRIPTION_KEY` in the **web/PHP process environment**.
   Optionally set `APIM_ENDPOINT=https://api.humanitarianaction.info/graphql/v1`.
   Use your hosting platform's environment/application settings and restart the
   PHP workers if required. Exporting a variable in a terminal alone does not
   configure an existing PHP-FPM/Apache process. PHP-FPM must allow the configured
   variable into the worker environment. Do not add the key to the module files.
3. Enable **Humanitarian Action APIM examples** under **Extend**, then clear Drupal
   caches. With Drush, you can instead run:

   ```bash
   drush en ha_apim_examples -y
   drush cr
   ```

4. Under **People → Permissions**, grant **Use the APIM example form** only to the
   roles that should use the server's subscription. This module does not grant
   anonymous access by default.
5. Open `/ha-apim-examples` on your Drupal site. Choose a query and click **Call API**.

The PHP form uses Drupal's built-in HTTP client to POST a query and variables
with `Ocp-Apim-Subscription-Key`. Calls happen on the server, so browser CORS
configuration is not required and the key is not sent to the page. Each result
is shown as a table; expand **Complete JSON result** for nested plan fields.
The page does not cache API results.

Defaults are USD, plan 1202, 100 currencies per page and a 1000-record limit.
Only fields for the selected query are used. Query files are included inside
the module in `queries/`. Read `src/Form/HaApimExampleForm.php` for the request,
response and rendering code. API text is escaped when rendered.
