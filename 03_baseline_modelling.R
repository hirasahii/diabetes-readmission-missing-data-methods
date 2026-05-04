# ============================================================
# Hospital Readmission – Baseline Modelling
# ============================================================

# Project: Missing Data Bias in Clinical Prediction Models
# Dataset: Diabetes 130-US Hospitals (1999–2008)
#
# This script fits baseline predictive models to the
# analysis-ready hospital readmission dataset.
#
# The purpose of this script is to:
#   - Load the cleaned, analysis-ready dataset
#   - Perform complete-case analysis
#   - Fit a baseline logistic regression model
#   - Establish a reference-performance benchmark
#
# No missing data imputation is performed in this script.
# Handling of missing data is deferred to subsequent analyses.
#
# This script builds directly on:
#   - 01_data_audit_and_baseline_pipeline.R
#   - 02_outcome_engineering_and_cleaning.R
#
# ============================================================


# ------------------------------------------------------------
# 1. Setup and data loading
# ------------------------------------------------------------

library(tidyverse)

diabetes_analysis <- read_csv("diabetes_analysis_ready.csv")


# ------------------------------------------------------------
# 2. Complete-case dataset
# ------------------------------------------------------------

# For baseline modelling, we restrict to complete cases
# on all variables used in the model.

diabetes_cc <- diabetes_analysis %>%
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
  ) %>%
  drop_na()


# ------------------------------------------------------------
# 3. Outcome check
# ------------------------------------------------------------

# Confirm outcome distribution in complete-case data
table(diabetes_cc$readmit_30d)


# ------------------------------------------------------------
# 4. Baseline logistic regression model
# ------------------------------------------------------------

baseline_model <- glm(
  readmit_30d ~
    age +
    gender +
    race +
    time_in_hospital +
    num_lab_procedures +
    num_procedures +
    num_medications +
    number_outpatient +
    number_emergency +
    number_inpatient +
    diabetesMed,
  data = diabetes_cc,
  family = binomial()
)


# ------------------------------------------------------------
# 5. Model summary
# ------------------------------------------------------------

summary(baseline_model)


# ------------------------------------------------------------
# 6. Baseline predicted probabilities
# ------------------------------------------------------------

diabetes_cc <- diabetes_cc %>%
  mutate(
    pred_readmit_30d = predict(
      baseline_model,
      type = "response"
    )
  )


# ------------------------------------------------------------
# 7. Save model inputs for downstream analysis
# ------------------------------------------------------------

write_csv(
  diabetes_cc,
  "baseline_model_complete_case.csv"
)