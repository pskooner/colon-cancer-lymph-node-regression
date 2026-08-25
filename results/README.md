# Results

This directory contains the SAS output generated from the final analysis.

The output includes results from:

- Exploratory data analysis
- Multiple linear regression models
- Model diagnostics and assumption checks
- Influence diagnostics
- Box–Cox transformation assessment
- Log-transformed regression analysis
- Partial F testing
- Interaction assessment
- Best-subsets and stepwise model selection
- Final model diagnostics
- PRESS validation
- Prediction and confidence intervals
- Bonferroni simultaneous confidence intervals

The final selected model used `log(nodes + 1)` as the response and retained age, tumor differentiation, and extent of tumor invasion as predictors.

For a summary and interpretation of the main findings, see the main [`README.md`](../README.md).
