# Diabetes Readmission – Health Data Science Pipeline

This repository contains an end-to-end health data science pipeline
examining the impact of missing data handling on predictive modelling
of 30-day hospital readmission using the Diabetes 130-US Hospitals
dataset (1999–2008).

The project demonstrates a reproducible and methodologically rigorous
workflow that emphasises data governance, transparency, statistical
interpretability, and responsible analysis of large observational
healthcare data.

## Project Overview

The analysis follows a structured, multi-stage health data science
workflow consistent with best practices in applied health research and
NHS-style analytics.

Rather than focusing solely on predictive performance, this project
prioritises:

transparent data provenance and auditability  
clearly documented data cleaning and outcome engineering decisions  
interpretable statistical modelling  
explicit comparison of missing data strategies  
responsible interpretation of observational findings  

## Dataset

Source: Diabetes 130-US Hospitals for Years 1999–2008  
Domain: Hospital readmission and inpatient care  
Observations: 101,766 hospital encounters  
Data type: Structured administrative and clinical variables  

Raw source files are preserved to maintain provenance. All downstream
analyses are performed on explicitly cleaned and documented
analysis-ready datasets.

Repository Structure

diabetes-readmission-health-data-science-pipeline/  
├── README.md  
├── 01_data_audit_and_baseline_pipeline.R  
├── 02_outcome_engineering_and_cleaning.R  
├── 03_baseline_modelling.R  
├── 04_missing_data_methods.R  
├── diabetic_data.csv  
├── diabetes_analysis_ready.csv  
├── baseline_model_complete_case.csv  
├── complete_case_model_coefficients.csv  
└── multiple_imputation_model_coefficients.csv  

## Scripts

01_data_audit_and_baseline_pipeline.R

This script performs the initial data audit and provenance assessment:

Loading and inspection of the raw dataset  
Review of variable structure, types, and encodings  
Quantification of explicit and implicit missingness  
Documentation of data quality issues prior to modification  

No data cleaning or transformation is performed at this stage. This
script establishes transparency and auditability before analysis.

02_outcome_engineering_and_cleaning.R

This script documents outcome engineering and data cleaning decisions:

Definition of a binary 30-day readmission outcome  
Explicit recoding of sentinel values representing missing data  
Removal of non-analytic identifier variables  
Creation of an analysis-ready dataset  

All decisions are explicitly recorded and reproducible.

03_baseline_modelling.R

This script performs baseline statistical modelling:

Complete-case analysis  
Multivariable logistic regression modelling  
Establishment of a baseline reference model  

The purpose of this stage is to provide a benchmark prior to applying
missing data methods.

04_missing_data_methods.R

This script evaluates the impact of missing data handling strategies:

Implementation of multiple imputation via chained equations (MICE)  
Fitting of equivalent logistic regression models across imputed datasets  
Pooling of parameter estimates  
Direct comparison with complete-case results  

This script forms the core methodological contribution of the project.

## Key Outputs

complete_case_model_coefficients.csv  
Regression coefficients derived under complete-case analysis.

multiple_imputation_model_coefficients.csv  
Pooled regression coefficients derived following multiple imputation.

These outputs are used for formal comparison and interpretation in
the thesis results section.

## Key Principles Demonstrated 

Transparent and reproducible health data workflows  
Clear separation of audit, cleaning, modelling, and methodology  
Interpretable statistical modelling  
Explicit handling and evaluation of missing data  
Responsible analysis of observational healthcare data  

## Disclaimer
This project is intended for educational and methodological
demonstration purposes only.

All analyses are observational and are not intended for clinical
decision-making.

## Author

Hira Sahi