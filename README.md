# Predictors of Lymph Node Burden in Stage II/III Colon Cancer

## Overview

This repository contains the final project for **PH 1820 – Applied Linear Regression (Spring 2026)** by **Elena Huseni and Parminder Kooner**.

The project evaluates whether markers of advanced local disease—**obstruction, perforation, adherence, and extent of local spread**—are associated with the number of positive lymph nodes at diagnosis among patients with Stage II/III colon cancer, after adjustment for age, sex, treatment, tumor differentiation, and time from surgery to registration.

The analysis was conducted in **SAS** using multiple linear regression, model diagnostics, response transformation, influence assessment, partial F testing, interaction assessment, model selection, validation, and simultaneous confidence intervals.

> **Important:** The original analysis code is preserved exactly as written for the course project. No analytical code has been rewritten or altered for this GitHub repository.

---

## Research Question

**Do markers of advanced local disease (obstruction, perforation, adherence, and extent of invasion) independently predict the number of positive lymph nodes at diagnosis after adjusting for relevant clinical covariates?**

### Outcome

- `nodes` — number of positive lymph nodes

### Primary Predictors

- `obstruct` — bowel obstruction
- `perfor` — perforation
- `adhere` — adherence to nearby tissue
- `extent` — extent of local tumor spread

### Adjustment Covariates

- `age`
- `sex`
- `rx` — treatment group
- `differ` — tumor differentiation
- `surg` — time from surgery to registration

---

## Dataset

The project uses the `colon` dataset derived from a randomized adjuvant chemotherapy trial in Stage II/III colon cancer.

The source dataset contained repeated records associated with survival outcomes. The analysis retained one record per patient and used complete-case analysis, resulting in a final analytic sample of **888 patients**.

The raw dataset is **not included** in this repository.

For information about the public version of the dataset, see the `survival::colon` dataset documentation in R and the original clinical trial citation listed below.

---

## Analysis Workflow

The original SAS program follows this workflow:

1. **Data import and preparation**
2. **Exploratory data analysis**
3. **Preliminary full main-effects linear regression model**
4. **Model diagnostics**
5. **Influential observation assessment**
6. **Box–Cox transformation assessment**
7. **Log-transformed response model**
8. **Partial F test for the disease-marker block**
9. **Interaction assessment**
10. **Best-subsets and stepwise model selection**
11. **Final model estimation**
12. **Lack-of-fit assessment and final diagnostics**
13. **Prediction and confidence intervals**
14. **Bonferroni simultaneous confidence intervals**

---

## Key Findings

The untransformed outcome was strongly right-skewed and showed non-normal residuals. A Box–Cox analysis was therefore used to evaluate transformations, and the final analysis used:

```text
log(nodes + 1)
```

The selected final model was:

```text
log(nodes + 1) = β0 + β1(age) + β2(differ_2) + β3(differ_3) + β4(extent_3)
```

Key results reported in the final presentation included:

- **Age:** small negative association with lymph node burden.
- **Moderately differentiated tumors:** approximately 15% greater node burden than well-differentiated tumors.
- **Poorly differentiated tumors:** approximately 39% greater node burden than well-differentiated tumors.
- **Serosa-level invasion:** approximately 12% greater node burden relative to the reference extent category.
- The final model was statistically significant but explained only a small proportion of outcome variability (**R² ≈ 0.039; adjusted R² ≈ 0.035**).
- PRESS was close to the in-sample SSE, suggesting little evidence of overfitting.

Overall, **tumor differentiation and extent of invasion provided more consistent information about lymph node burden than obstruction, perforation, or adherence**.

---

## Repository Structure

```text
colon-cancer-lymph-node-regression/
│
├── README.md
├── .gitignore
│
├── code/
│   └── Huseni_Kooner_PH1820_Final_Project.txt
│
├── data/
│   └── README.md
│
├── presentation/
│   └── Huseni_Kooner_PH1820_Final_Project_with_recordings.pptx
│
└── results/
    ├── README.md
    └── Huseni_Kooner_PH1820_Final_Project.sas
```

---

## Code

The complete original SAS code is available here:

[`code/Huseni_Kooner_PH1820_Final_Project.txt`](code/Huseni_Kooner_PH1820_Final_Project.txt)

The code is intentionally retained **without modification** to preserve the original course-project analysis.

Because the original SAS code contains a local Windows path for `colon_full.csv`, users wishing to rerun the analysis will need to change that file path locally or recreate the expected directory structure. That path has not been edited here in order to preserve the original code exactly.

---

## Presentation

The final course presentation is included in:

[`presentation/Huseni_Kooner_PH1820_Final_Project_with_recordings.pptx`](presentation/Huseni_Kooner_PH1820_Final_Project_with_recordings.pptx)

It summarizes the research question, methods, diagnostics, transformation decision, model-selection process, final model, validation results, and scientific interpretation.

---

## Software and Methods

- **SAS 9.4**
- Multiple linear regression
- Exploratory data analysis
- Residual diagnostics
- Breusch–Pagan and White tests
- Variance inflation factors
- Cook's distance, DFFITS, leverage, and studentized residuals
- Box–Cox transformation
- Partial F testing
- Interaction assessment
- Best-subsets regression
- Stepwise selection
- PRESS validation
- Lack-of-fit testing
- Bonferroni simultaneous confidence intervals

---

## Reproducibility Note

The original source code is preserved exactly as submitted. The raw analysis dataset is not distributed in this repository. To reproduce the analysis, obtain the appropriate `colon` dataset, prepare it in the format expected by the SAS program, and update the local data path in a personal working copy of the program.

Do not commit patient-level or otherwise restricted data to a public repository.

---

## References

- Kutner, M. H., Nachtsheim, C. J., Neter, J., & Li, W. (2005). *Applied Linear Statistical Models* (5th ed.). McGraw-Hill.
- Laurie, J. A., et al. (1989). Surgical adjuvant therapy of large-bowel carcinoma: an evaluation of levamisole and the combination of levamisole and fluorouracil. *Journal of Clinical Oncology*.
- Therneau, T. `colon` dataset, R `survival` package.

---

## Authors

**Elena Huseni**  
**Parminder Kooner**

PH 1820 – Applied Linear Regression  
Spring 2026
