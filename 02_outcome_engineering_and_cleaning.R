# ============================================================
# Hospital Readmission – Outcome Engineering and Cleaning
# ============================================================

# Project: Missing Data Bias in Clinical Prediction Models
# Dataset: Diabetes 130-US Hospitals (1999–2008)
#
# This script performs outcome engineering and initial
# data cleaning to produce an analysis-ready dataset.
#
# The purpose of this script is to:
#   - Define the 30-day hospital readmission outcome
#   - Recode implicit misReload Windowsing values (sentinel codes)
#   - Remove non-informative identifier variables
#   - Produce a clean, analysis-ready dataset for modelling
#
# This script builds directly on the data audit performed
# in 01_data_audit_and_baseline_pipeline.R.
#
# ============================================================


# ------------------------------------------------------------
# 1. Setup and data loading
# ------------------------------------------------------------
library(tidyverse)

diabetes_raw <- read_csv("diabetic_data.csv")


# ------------------------------------------------------------
# 2. Outcome engineering
# ------------------------------------------------------------

# The readmitted variable has three levels:
#   "NO"   = no readmission
#   ">30"  = readmission after 30 days
#   "<30"  = readmission within 30 days
#
# We define a binary 30-day readmission outcome:
#   1 = readmitted within 30 days
#   0 = not readmitted within 30 days

diabetes_clean <- diabetes_raw %>%
  mutate(
    readmit_30d = case_when(
      readmitted == "<30" ~ 1,
      readmitted %in% c("NO", ">30") ~ 0,
      TRUE ~ NA_real_
    )
  )


# ------------------------------------------------------------
# 3. Recode implicit missingness
# ------------------------------------------------------------

# Several character variables use "?" as a sentinel for missing.
# These are explicitly recoded to NA.

diabetes_clean <- diabetes_clean %>%
  mutate(across(
    where(is.character),
    ~ na_if(.x, "?")
  ))


# ------------------------------------------------------------
# 4. Remove identifier and leakage variables
# ------------------------------------------------------------

# encounter_id and patient_nbr are administrative identifiers
# and are removed prior to modelling.

diabetes_clean <- diabetes_clean %>%
  select(-encounter_id, -patient_nbr)


# ------------------------------------------------------------
# 5. Final dataset checks
# ------------------------------------------------------------

# Dimensions of cleaned dataset
dim(diabetes_clean)

# Check outcome distribution
table(diabetes_clean$readmit_30d, useNA = "ifany")

# Missingness after recoding
colSums(is.na(diabetes_clean))


# ------------------------------------------------------------
# 6. Save analysis-ready dataset
# ------------------------------------------------------------

write_csv(
  diabetes_clean,
  "diabetes_analysis_ready.csv"
)