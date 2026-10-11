# Preview and publish

You can read the Markdown directly on GitHub. The optional MkDocs website adds
navigation, search and a copy button for code blocks.

## Preview locally

PowerShell, from the repository root:

```powershell
python -m venv .venv
./.venv/Scripts/python.exe -m pip install -r requirements-docs.txt
./.venv/Scripts/python.exe scripts/check_graphql.py
./.venv/Scripts/python.exe -m mkdocs serve
```

Linux/macOS:

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements-docs.txt
.venv/bin/python scripts/check_graphql.py
.venv/bin/python -m mkdocs serve
```

Open <http://127.0.0.1:8000>. Stop the preview with Ctrl+C.
The documentation environment is separate from the client samples, which need
no documentation packages.

## GitHub Pages

1. In repository **Settings → Pages**, choose **GitHub Actions** as the source.
2. Confirm the site's intended visibility; repository visibility alone does not
   guarantee a private Pages site.
3. In **Actions**, select **Deploy documentation to GitHub Pages**.
4. Select **Run workflow** on `main`.
5. Open the URL shown by the deployment.

Publishing is manual. Pushing a commit runs documentation checks but does not
automatically deploy the website.

The configured repository and Pages URLs remain the existing
`UN-OCHA/hpc-fabric-graphql-api-docs` URLs. If the repository is renamed, update
`repo_url`, `repo_name` and `site_url` in `mkdocs.yml`.

## Update this checkout

Keep the existing `.git/` and `api-schema/` folders. Replace the supplied docs,
examples, scripts, workflow folders and root files with this package's versions.
Remove the old versions of those folders so obsolete pages are not left behind.
Review `git status` and the diff before committing.

The ZIP contains repository files without Git history or generated `site/` output.

References: [MkDocs](https://www.mkdocs.org/),
[GitHub Pages publishing](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site),
[GitHub Pages access control](https://docs.github.com/en/enterprise-cloud@latest/pages/getting-started-with-github-pages/changing-the-visibility-of-your-github-pages-site).
