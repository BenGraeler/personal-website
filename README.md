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
| `bib/software.bib` | Software development |
| `bib/reverse-chronological.csl` | Citation style (newest first) |
| `bib/grouped-bib.lua`, `bib/highlight-author.lua` | Filters: one list per BibTeX file; own name in bold |
| `files/` | Older slides, posters, course material and dissertation |
| `images/portrait.jpg` | Portrait |

## Local preview

```sh
quarto preview
```

## Publishing

Every push to `master` renders the site and deploys it via GitHub Actions (`.github/workflows/publish.yml`).
