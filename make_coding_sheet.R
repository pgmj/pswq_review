# Build the PSWQ scoping-review coding spreadsheet.
#
#   Sheet 1 "Coding"   : the column headers ready for data entry (one paper per
#                        row, or one row per study when a paper reports several).
#   Sheet 2 "Guidance" : the Table 1 field definitions plus the abbreviation note.
#
# The column headers on sheet 1 and the guidance rows on sheet 2 are generated
# from one object (`guidance`), so they cannot drift apart. Edit `guidance` to
# add, remove, or reword a field and both sheets update.
#
# Run in RStudio from the PSWQreview folder. Requires the openxlsx package
# (install.packages("openxlsx")). Writes PSWQ_coding.xlsx to the working
# directory.

library(openxlsx)

# One row per coding column: the header text and the guidance for coding it.
guidance <- data.frame(
  Field = c(
    "Author",
    "Year",
    "Title",
    "Study label",
    "Study population",
    "N",
    "PSWQ version",
    "Psychometric method(s)/model(s)",
    "Estimator",
    "Software",
    "Dimensionality cutoffs",
    "Dimensionality result",
    "Local dependence",
    "LD cutoffs",
    "LD result",
    "Invariance",
    "Invariance variable(s)",
    "Invariance cutoffs",
    "Invariance result",
    "Ordered response category thresholds",
    "Response category result",
    "Notes"
  ),
  `What is recorded` = c(
    "First author",
    "Publication year",
    "Article title",
    "Label distinguishing multiple studies in one paper. Use one row per study",
    "Sample description, setting, and country",
    "Sample size",
    "Full 16-item form or a short form (for example PSWQ-A, PSWQ-8, PSWQ-3)",
    "CFA, Rasch (PCM, RSM), IRT (GRM, GPCM, or other), ESEM (record the rotation), or a combination",
    paste("ML, MLR, WLSMV, or ULSMV for factor models, MML for IRT, and",
          "CML, JML, or MML for Rasch"),
    "For example lavaan, Mplus, Winsteps, eRm, mirt, TAM",
    "Rule-of-thumb or simulation-based, and which metrics or indices",
    "The structural or dimensional conclusion reached",
    "Evaluated? Yes or No. Examples: residual/error/Q3 correlations",
    "Rule-of-thumb or simulation-based, if evaluated",
    paste("Method used and which item pairs were locally dependent,",
          "if any"),
    paste("Evaluated? Yes or No. Examples: multi-group CFA (MG-CFA),",
          "or differential item functioning (DIF)"),
    paste("Which grouping variables were evaluated, such as sex, age group,",
          "language version, or clinical status"),
    "Rule-of-thumb or simulation-based, if evaluated",
    paste("Groups tested, the finding, and which items showed DIF or",
          "non-invariance, if any"),
    paste("Evaluated? Yes or No. Only evaluable with adjacent-category models",
          "(PCM, RSM, GPCM). Not evaluable with CFA, nor with the GRM, where",
          "thresholds are ordered by construction"),
    "The finding, such as disordered thresholds",
    "Free-text notes, uncertainties, or reasons for exclusion"
  ),
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# Abbreviation note, shown beneath the guidance on sheet 2.
abbrev <- paste(
  "ESEM = exploratory structural equation modeling;",
  "IRT = item response theory; PCM = partial credit model;",
  "RSM = rating scale model; GRM = graded response model;",
  "GPCM = generalized partial credit model; ML = maximum likelihood;",
  "MLR = robust maximum likelihood;",
  "WLSMV = mean- and variance-adjusted weighted least squares;",
  "ULSMV = mean- and variance-adjusted unweighted least squares;",
  "MML = marginal maximum likelihood; JML = joint maximum likelihood;",
  "CML = conditional maximum likelihood."
)

bold <- createStyle(textDecoration = "bold")
wrap <- createStyle(wrapText = TRUE, valign = "top")

wb <- createWorkbook()

## Sheet 1: empty coding grid, headers only.
addWorksheet(wb, "Coding")
coding <- as.data.frame(
  setNames(rep(list(character()), nrow(guidance)), guidance$Field),
  check.names = FALSE, stringsAsFactors = FALSE
)
writeData(wb, "Coding", coding, headerStyle = bold)
freezePane(wb, "Coding", firstRow = TRUE)

# Column widths: wider for the free-text fields, default otherwise.
widths <- rep(22, nrow(guidance))
widths[guidance$Field %in% c("Title", "Study population", "Notes")] <- 40
setColWidths(wb, "Coding", cols = seq_len(nrow(guidance)), widths = widths)

# Soft Yes/No dropdowns on the three "evaluated?" columns. The list suggests
# Yes and No, but showErrorMsg = FALSE means a coder can still type free text
# without being blocked.
yn_cols <- which(guidance$Field %in%
                 c("Local dependence", "Invariance",
                   "Ordered response category thresholds"))
for (cc in yn_cols) {
  dataValidation(wb, "Coding", cols = cc, rows = 2:1000, type = "list",
                 value = '"Yes,No"', allowBlank = TRUE, showErrorMsg = FALSE)
}

## Sheet 2: the field guidance.
addWorksheet(wb, "Guidance")
writeData(wb, "Guidance", guidance, headerStyle = bold)
addStyle(wb, "Guidance", wrap,
         rows = 2:(nrow(guidance) + 1), cols = 1:2, gridExpand = TRUE)
setColWidths(wb, "Guidance", cols = 1:2, widths = c(34, 80))
freezePane(wb, "Guidance", firstRow = TRUE)

note_row <- nrow(guidance) + 3
writeData(wb, "Guidance", "Note.", startRow = note_row, startCol = 1,
          colNames = FALSE)
writeData(wb, "Guidance", abbrev, startRow = note_row, startCol = 2,
          colNames = FALSE)
addStyle(wb, "Guidance", wrap, rows = note_row, cols = 2)

saveWorkbook(wb, "PSWQ_coding.xlsx", overwrite = TRUE)
message("Wrote ", normalizePath("PSWQ_coding.xlsx"))
