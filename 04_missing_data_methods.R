# ============================================================
# Hospital Readmission – Missing Data Methods
# ============================================================

# Project: Missing Data Bias in Clinical Prediction Models
# Dataset: Diabetes 130-US Hospitals (1999–2008)
#
# This script evaluates the impact of missing data handling
# strategies on hospital readmission prediction.
#
# The purpose of this script is to:
#   - Compare complete-case analysis to multiple imputation
#   - Fit equivalent logistic regression models
#   - Quantify differences in estimates attributable to
#     missing data handling
#
# This script builds directly on:
#   - 01_data_audit_and_baseline_pipeline.R
#   - 02_outcome_engineering_and_cleaning.R
#   - 03_baseline_modelling.R
#
# ============================================================


# ------------------------------------------------------------
# 1. Setup and data loading
# ------------------------------------------------------------

library(tidyverse)
library(mice)
library(broom)

diabetes_analysis <- read_csv("diabetes_analysis_ready.csv")


# ------------------------------------------------------------
# 2. Variable selection for modelling
# ------------------------------------------------------------

model_vars <- diabetes_analysis %>%
  select(
    readmit_30d,
    age,
    gender,
    race,
    time_in_hospital,
    num_lab_procedures,
    num_procedures,
    num_medications,
    number_outpatient,
    number_emergency,
    number_inpatient,
    diabetesMed
  )


# ------------------------------------------------------------
# 3. Complete-case model (reference)
# ------------------------------------------------------------

complete_case_data <- model_vars %>%
  drop_na()

cc_model <- glm(
  readmit_30d ~ .,
  data = complete_case_data,
  family = binomial()
)


# ------------------------------------------------------------
# 4. Multiple imputation
# ------------------------------------------------------------

# Perform multiple imputation using chained equations
imputed_data <- mice(
  model_vars,
  m = 5,
  method = "pmm",
  seed = 123
)


# ------------------------------------------------------------
# 5. Fit model across imputed datasets
# ------------------------------------------------------------

mi_model <- with(
  imputed_data,
  glm(
    readmit_30d ~ age + gender + race +
      time_in_hospital + num_lab_procedures +
      num_procedures + num_medications +
      number_outpatient + number_emergency +
      number_inpatient + diabetesMed,
    family = binomial()
  )
)

pooled_results <- pool(mi_model)


# ------------------------------------------------------------
# 6. Model comparison outputs
# ------------------------------------------------------------

cc_summary <- summary(cc_model)

mi_summary <- summary(pooled_results)


# ------------------------------------------------------------
# 7. Save results for reporting
# ------------------------------------------------------------

write_csv(
  tidy(cc_model),
  "complete_case_model_coefficients.csv"
)

write_csv(
  tidy(pooled_results),
  "multiple_imputation_model_coefficients.csv"
)