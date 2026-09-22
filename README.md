# SAS Medical / Clinical Data Analysis Pipeline

A comprehensive SAS-based data processing, statistical modeling, and analytical reporting pipeline developed for medical and clinical trial dataset evaluation.

---

## 📋 Table of Contents

* [Project Overview](https://www.google.com/search?q=%2523-project-overview&utm_source=gemini)
* [Repository Structure](https://www.google.com/search?q=%2523-repository-structure&utm_source=gemini)
* [Key Features & Analysis Modules](https://www.google.com/search?q=%2523-key-features--analysis-modules&utm_source=gemini)
* [Prerequisites & Requirements](https://www.google.com/search?q=%2523-prerequisites--requirements&utm_source=gemini)
* [Usage & Execution](https://www.google.com/search?q=%2523-usage--execution&utm_source=gemini)
* [Output Deliverables](https://www.google.com/search?q=%2523-output-deliverables&utm_source=gemini)

---

## 📌 Project Overview

This project processes, cleans, and analyzes clinical dataset structures across six distinct analytical modules (Parts 1–6). It includes complete SAS source scripts alongside pre-compiled execution logs and analytical summaries in PDF format for auditability and validation.

---

## 📁 Repository Structure

```files
.
├── Project/
│   ├── COMPLETE CODE_ Group2_Project.sas.pdf      # Complete combined SAS codebase (PDF document)[cite: 1]
│   ├── Group2_Project_Complete_Code.sas          # Full consolidated SAS script[cite: 1]
│   ├── Group2_Project_Parts1-6_UPDATED.sas        # Modular SAS script (Parts 1–6)[cite: 1]
│   ├── Log_ Parts1-6_Group2_Project.sas.pdf      # SAS execution log & diagnostic output[cite: 1]
│   └── Program Summary_Parts1-6_Group2_Project.sas.pdf # Analytical summary report & generated figures[cite: 1]
└── README.md                                      # Project documentation

```

---

## 🔬 Key Features & Analysis Modules

* **Part 1: Data Import & Cleaning** — Imports raw clinical/medical data, standardizes variable formats, handles missing values, and checks data types.


* **Part 2: Exploratory Data Analysis (EDA)** — Computes summary statistics (`PROC MEANS`, `PROC UNIVARIATE`) and categorical frequency distributions (`PROC FREQ`).


* **Part 3: Statistical Modeling** — Executes parametric and non-parametric statistical hypothesis testing and regression analyses.


* **Part 4: Clinical Outcome & Survival/Trend Analysis** — Evaluates target outcomes, longitudinal trends, and survival/treatment metrics over time.


* **Part 5: Data Visualization** — Generates publication-ready figures, histograms, boxplots, and scatterplots (`PROC SGPLOT`).


* **Part 6: Reporting & Output Delivery** — Exports formatted tables and summary statistics using SAS Output Delivery System (ODS).



---

## 💻 Prerequisites & Requirements

* **SAS Software Environment:**
* SAS 9.4 (Desktop Edition) OR SAS OnDemand for Academics / SAS Enterprise Guide.




* **Required SAS Modules:**
* Base SAS


* SAS/STAT


* SAS/GRAPH or ODS Graphics (`PROC SGPLOT`)





---

## 🚀 Usage & Execution

### Running the Consolidated Script

1. Open **SAS Studio**, **SAS Enterprise Guide**, or **SAS Windowing Environment**.


2. Load the main execution script from the project directory:
```sas
Project/Group2_Project_Complete_Code.sas

```


3. Submit and run the script.

### Running Modular Parts

To run specific workflow sections, open `Project/Group2_Project_Parts1-6_UPDATED.sas` and execute the desired labeled block (`Part 1` through `Part 6`).

---

## 📄 Output Deliverables

* **`Log_ Parts1-6_Group2_Project.sas.pdf`**: Execution logs confirming clean execution without errors or warnings.


* **`Program Summary_Parts1-6_Group2_Project.sas.pdf`**: Compiled analytical summary report containing statistical output tables, distribution plots, and graphical findings.
