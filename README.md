# Psychometric evaluation of the Penn State Worry Questionnaire: a scoping review

Protocol, search code, and coding materials for a scoping review of the
psychometric literature on the Penn State Worry Questionnaire (PSWQ) published
since 2010. The review charts how studies evaluated the instrument, organized
around four measurement properties (unidimensionality, local independence,
invariance, and ordered response-category thresholds), and examines whether
fit-interpretation criteria, estimator choice, and the handling of local
dependence track the structural conclusions reached.

- Preregistration: OSF, <https://doi.org/10.17605/OSF.IO/BZVGW>
- Archived release: <https://doi.org/10.6084/m9.figshare.33981118>

## Authors

- Magnus Johansson, Karolinska Institutet ([ORCID](https://orcid.org/0000-0003-1669-592X))
- Tove Wahlund, Karolinska Institutet and Region Stockholm ([ORCID](https://orcid.org/0000-0002-5123-2392))
- Maria Hedman-Lagerlöf, Karolinska Institutet and Region Stockholm ([ORCID](https://orcid.org/0000-0002-3581-099X))

## Contents

| File | Purpose |
|------|---------|
| `index.qmd` | The protocol. Appendix A holds the search strategy, per-database strings, and record-management code |
| `index.pdf` | Rendered protocol |
| `searches.qmd` | Executable search notebook, the authoritative record of the search. Pulls, caches, harmonizes, and deduplicates the records, and holds the known-item validation |
| `make_coding_sheet.R` | Builds the data-charting workbook from the Table 1 fields, so the workbook and the protocol cannot drift apart. Requires `openxlsx` |
| `PSWQ_coding.xlsx` | Data-charting workbook: a coding sheet with Yes/No dropdowns on the three evaluated columns, and a guidance sheet |
| `refs.bib`, `apa.csl` | References and citation style |
| `_quarto.yml`, `_extensions/`, `notes.lua` | Rendering configuration |

## Reproducing the search

Searches use four open databases: OpenAlex, Semantic Scholar, Europe PMC, and
PubMed. No account or subscription is needed.

R packages: `openalexR`, `europepmc`, `rentrez`, `httr2`, `dplyr`, `stringr`,
`tibble`, and `ggplot2`.

1. Set the cache folder near the top of `searches.qmd` to a new, dated folder:

   ```r
   cache_dir <- "data/run_YYYY-MM-DD"
   ```

   An empty folder forces a live pull from every source. Each run keeps its raw
   pulls and deduplicated set in its own folder.

2. Restart R and run all chunks from the top.

3. Check the console for `skipped` messages. The PubMed and Semantic Scholar
   pulls are wrapped in `tryCatch`, so a failed source is reported as a message
   and the notebook completes without it.

4. Save `sessionInfo()` to the run folder.

The Semantic Scholar bulk endpoint allows about one request per second without
an API key. If that pull fails, rerun its chunk on its own.

Database contents change over time, so a rerun returns the records indexed on
the day it is run rather than the set screened for the review. The screened set
is kept in the repository (see Data).

## Data

Under `data/`, only the `records_deduped.csv` files are included, one per search
run, each holding the deduplicated record set with source, year, title, and DOI. This is the set that
went to screening, and it is the only way to recover that set, since a rerun
returns the records indexed on the day it is run. The raw pulls (`*.rds`) are
not included, because they contain abstracts retrieved from the APIs, many of
which are under publisher copyright. Running `searches.qmd` regenerates them.

## Rendering the protocol

```bash
quarto render index.qmd --to preprint-typst
```

`quarto render index.qmd` builds both the PDF and the Word version. The code in
Appendix A is display-only, so no R packages are needed to render. The bundled
`mvuorre/preprint` extension carries one local change: list leading in
`typst-template.typ` is set to `linestretch * 0.65em` so bullet lists match body
text. Updating the extension overwrites it.

## Reporting

The review follows PRISMA-ScR, and the search is reported following PRISMA-S.
