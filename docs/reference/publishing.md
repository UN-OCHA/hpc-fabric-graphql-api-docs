# Publishing this site

The Markdown is readable directly in a private GitHub repository. A Material for
MkDocs site adds full-text search, structured navigation, responsive layout, and
a copy button on every code block.

## Security decision first

!!! danger "Do not publish until visibility is confirmed"
    GitHub Pages can be public even when its source repository is private or
    internal. Private Pages visibility requires GitHub Enterprise Cloud and
    appropriate organization policy. Confirm the resulting site is restricted
    to the intended internal audience before deployment.

If private Pages is unavailable, keep the repository private and read the
Markdown on GitHub, or publish the generated `site/` directory to an approved
internal web service.

GitHub documents the visibility requirement in
[Creating a GitHub Pages site](https://docs.github.com/en/enterprise-cloud@latest/pages/getting-started-with-github-pages/creating-a-github-pages-site#viewing-your-published-site).

## Preview locally

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
python -m pip install -r requirements-docs.txt
mkdocs serve
```

Open <http://127.0.0.1:8000>.

## Configure GitHub Pages

After confirming private Pages support:

1. Open the repository on GitHub.
2. Select **Settings**.
3. Under **Code and automation**, select **Pages**.
4. Set site visibility to **Private**.
5. Under **Build and deployment**, set **Source** to **GitHub Actions**.
6. Open **Actions** and select **Deploy documentation to GitHub Pages**.
7. Select **Run workflow** and choose the default branch.
8. Return to **Settings > Pages** and use **Visit site**.
9. Test the site in a private/incognito browser where no GitHub user is signed
   in. The site must not display documentation anonymously.

The provided workflow runs only when a maintainer starts it manually. This
prevents a documentation commit from automatically publishing a site whose
visibility has not been reviewed.

GitHub's upstream instructions are in
[Configuring a publishing source](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site).

## Update process

1. Edit Markdown in a branch.
2. Test queries and build the site with `mkdocs build --strict`.
3. Open and review a pull request.
4. Merge the approved change.
5. Run the manual Pages workflow from the default branch.

