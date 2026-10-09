# ben.graeler.org

Personal website of Benedikt Gräler, built with [Quarto](https://quarto.org) and published to GitHub Pages at <https://ben.graeler.org>.

## Structure

| Path | Content |
|---|---|
| `index.qmd`, `teaching.qmd`, `spatial-copulas.qmd`, `shiny-apps.qmd` | Pages (Markdown) |
| `publications.qmd` | Publication list, generated from the BibTeX files |
| `bib/articles.bib` | Journal articles, book chapters, conference papers |
| `bib/reports.bib` | Reports, theses, project deliverables |
| `bib/talks.bib` | Talks, posters, workshops |
| `bib/reverse-chronological.csl` | Citation style (newest first) |
| `bib/grouped-bib.lua`, `bib/highlight-author.lua` | Filters: one list per BibTeX file; own name in bold |
| `files/` | Slides, posters, course material and dissertation (formerly on www.graeler.org) |
| `images/portrait.jpg` | Portrait |

## Adding a publication

Add an entry to the matching `.bib` file and push. Include a `doi` field whenever there is one; otherwise a `url`. Further links (slides, poster, …) go into `note` as `\href{url}{label}`. The list is sorted by year automatically.

Tip: BibTeX for any DOI can be fetched with

```sh
curl -LH "Accept: application/x-bibtex" https://doi.org/<DOI>
```

## Local preview

```sh
quarto preview
```

## Publishing

Every push to `master` renders the site and deploys it via GitHub Actions (`.github/workflows/publish.yml`).
