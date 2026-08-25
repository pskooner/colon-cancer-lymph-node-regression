# Predictors of Lymph Node Burden in Stage II/III Colon Cancer

## Overview

This project presents a **multiple linear regression analysis of clinical and tumor characteristics associated with lymph node burden in Stage II/III colon cancer**. The analysis was completed as the final project for **PH 1820 – Applied Linear Regression (Spring 2026)**.

Using clinical trial data from patients with Stage II/III colon cancer, the project evaluates whether markers of advanced local disease **bowel obstruction, perforation, adherence to surrounding tissue, and extent of tumor invasion** are associated with the number of positive lymph nodes at diagnosis after adjustment for demographic, treatment, and pathological characteristics.

The complete analysis was conducted in **SAS** and includes exploratory data analysis, multiple linear regression, regression diagnostics, influence analysis, Box–Cox transformation, partial F testing, interaction assessment, model selection, and model validation.

---

## Research Question

> **Do markers of advanced local disease independently predict the number of positive lymph nodes at diagnosis after adjustment for relevant clinical covariates?**

### Outcome

- `nodes` — number of positive lymph nodes

### Primary Predictors

- `obstruct` — bowel obstruction
- `perfor` — bowel perforation
- `adhere` — adherence to nearby tissue
- `extent` — extent of local tumor invasion

### Adjustment Covariates

- `age` — patient age
- `sex` — patient sex
- `rx` — treatment group
- `differ` — tumor differentiation
- `surg` — time from surgery to registration

---

## Data

The analysis uses the `colon` dataset derived from a randomized clinical trial of adjuvant chemotherapy in patients with Stage II/III colon cancer.

The original data structure contained repeated records associated with survival outcomes. After retaining one record per patient and performing complete-case analysis, the final analytic sample included:

**N = 888 patients**

Variables related to survival follow-up and identifiers were excluded because the objective of this analysis was to model lymph node burden at diagnosis rather than time-to-event outcomes.

> **Data availability:** The raw analysis dataset is not included in this repository. Information about the publicly available `colon` dataset can be found through the R `survival` package.

---

## Statistical Analysis

The analysis followed a structured regression-modeling workflow:

1. **Data preparation and quality assessment**
   - Data import and type conversion
   - Selection of one record per patient
   - Missing-data assessment
   - Complete-case analysis

2. **Exploratory data analysis**
   - Continuous-variable summaries and distributions
   - Categorical frequency distributions
   - Scatterplots and boxplots
   - Pearson and Spearman correlations
   - Cross-tabulations among disease markers

3. **Initial multiple linear regression**
   - Full main-effects model using the untransformed lymph node count
   - Indicator coding for categorical predictors
   - Confidence intervals and variance inflation factors

4. **Regression diagnostics**
   - Residual-versus-fitted assessment
   - Residual normality
   - Breusch–Pagan and White tests
   - Multicollinearity assessment

5. **Influence analysis**
   - Cook's distance
   - DFFITS
   - Leverage
   - Studentized residuals
   - Sensitivity analysis

6. **Outcome transformation**
   - Box–Cox transformation assessment
   - Evaluation of `log(nodes + 1)`
   - Reassessment of regression assumptions

7. **Model specification and selection**
   - Partial F testing
   - Interaction assessment
   - Best-subsets regression
   - Stepwise selection

8. **Final model evaluation**
   - Lack-of-fit testing
   - Residual diagnostics
   - PRESS validation
   - Confidence and prediction intervals
   - Bonferroni simultaneous confidence intervals

---

## Transformation and Model Diagnostics

The original lymph node count was strongly right-skewed, and the initial regression model demonstrated substantial residual non-normality and evidence of variance heterogeneity.

A **Box–Cox analysis** was used to evaluate potential transformations. The subsequent analysis used:

```text
log(nodes + 1)
```

The transformation substantially improved the residual distribution:

| Diagnostic | Untransformed | log(nodes + 1) |
|---|---:|---:|
| Residual skewness | 2.55 | 0.63 |
| Residual kurtosis | 10.3 | -0.14 |
| Shapiro-Wilk W | 0.79 | 0.96 |

Although formal normality testing remained statistically significant, the transformed model produced substantially more symmetric residuals and reduced the influence of extreme observations.

---

## Disease-Marker Block Test

A partial F test compared a reduced model containing the adjustment covariates with a full model that additionally included obstruction, perforation, adherence, and extent of invasion.

The disease-marker block provided statistically significant additional explanatory information:

**F(6, 874) = 2.22, p = 0.040**

However, subsequent variable-selection procedures indicated that most of this information was attributable to **extent of invasion**, rather than obstruction, perforation, or adherence.

---

## Model Selection

Best-subsets regression and stepwise selection were used to identify a more parsimonious model.

The final selected predictors were:

- `age`
- `differ_2` — moderately vs. well-differentiated tumor
- `differ_3` — poorly vs. well-differentiated tumor
- `extent_3` — serosa-level invasion

The selected model was:

```text
log(nodes + 1) =
β₀ + β₁(age) + β₂(differ_2) + β₃(differ_3) + β₄(extent_3)
```

---

## Key Results

| Predictor | β | 95% CI | p-value | Approximate Interpretation |
|---|---:|---:|---:|---|
| Age | -0.0054 | (-0.0086, -0.0021) | 0.001 | ~0.5% lower node burden per year |
| Moderate differentiation | +0.142 | (0.012, 0.272) | 0.033 | ~15% higher node burden |
| Poor differentiation | +0.329 | (0.173, 0.484) | <0.0001 | ~39% higher node burden |
| Serosa-level invasion | +0.115 | (0.013, 0.216) | 0.027 | ~12% higher node burden |

### Final Model Performance

- **N:** 888
- **R²:** 0.039
- **Adjusted R²:** 0.035
- **Overall model p-value:** <0.0001
- **Lack-of-fit p-value:** 0.722
- **PRESS:** 310.53
- **In-sample SSE:** 307.12

PRESS was approximately **1.1% greater than the in-sample SSE**, suggesting little deterioration in predictive performance under leave-one-out validation.

---

## Key Findings

The analysis produced three primary findings:

1. **Tumor differentiation was the strongest predictor of lymph node burden.** Poorly differentiated tumors were associated with substantially greater lymph node involvement than well-differentiated tumors.

2. **Extent of local invasion contributed additional information.** Serosa-level invasion remained associated with greater lymph node burden after adjustment.

3. **Gross local-disease markers provided limited independent information.** Obstruction, perforation, and adherence were not retained in the final selected model.

Despite statistically significant associations, the final model explained only approximately **4% of the variability in lymph node burden**. This suggests that standard demographic and clinicopathological characteristics capture only a small portion of the heterogeneity in nodal involvement.

---

## Repository Structure

```text
colon-cancer-lymph-node-regression/
│
├── README.md
├── .gitignore
│
├── code/
│   └── final_project.txt
│
├── data/
│   └── README.md
│
├── presentation/
│   └── final_project.pptx
│
└── results/
    ├── README.md
    └── final_project.sas
```

---

## Code

The complete original SAS analysis code is available here:

[`code/final_project.txt`](code/final_project.txt)

The code has intentionally been preserved **without modification** to maintain the original analytical workflow.

---

## Presentation

The final course presentation is available here:

[`presentation/final_project.pptx`](presentation/final_project.pptx)

The presentation summarizes the research question, methods, diagnostics, transformation decision, model-selection process, final model, validation results, and scientific interpretation.

---

## Methods and Skills Demonstrated

- **SAS 9.4**
- Data preprocessing and quality assessment
- Exploratory data analysis
- Multiple linear regression
- Categorical predictor coding
- Regression assumption assessment
- Residual diagnostics
- Breusch–Pagan and White tests
- Variance inflation factors
- Cook's distance, DFFITS, and leverage
- Influence and sensitivity analysis
- Box–Cox transformation
- Partial F testing
- Interaction assessment
- Best-subsets regression
- Stepwise model selection
- PRESS validation
- Lack-of-fit testing
- Confidence and prediction intervals
- Bonferroni simultaneous inference
- Interpretation of log-transformed regression models

---

## Reproducibility

The original SAS source code is preserved as completed for the course project.

Because the raw dataset is not distributed in this repository, reproducing the analysis requires obtaining the appropriate `colon` dataset separately and preparing it in the format expected by the SAS program.

The original code contains a local file path used during development. Users reproducing the analysis should update this path in a **personal working copy** rather than modifying the archived original source code.

---

## Limitations

Several limitations should be considered when interpreting the analysis:

- The final model explains only a small proportion of the variability in lymph node burden.
- The lymph node outcome is a count variable; although transformation improved the performance of the linear regression model, a count-based generalized linear model could provide an alternative modeling framework.
- Some categorical predictor levels contained relatively few observations.
- The analysis focuses on clinical and pathological characteristics available in the dataset and does not incorporate molecular tumor characteristics that may explain additional variation.

---

## References

- **Kutner, M. H., Nachtsheim, C. J., Neter, J., & Li, W. (2005).** *Applied Linear Statistical Models* (5th ed.). McGraw-Hill.
- **Laurie, J. A., et al. (1989).** Surgical adjuvant therapy of large-bowel carcinoma: an evaluation of levamisole and the combination of levamisole and fluorouracil. *Journal of Clinical Oncology*.
- **Therneau, T.** `colon` dataset, R `survival` package.

---

## Authors

**Parminder Kooner**

PH 1820 – Applied Linear Regression  
Spring 2026
