# Retail Analytics Cloud

## Overview

Retail Analytics Cloud is an end-to-end analytics engineering project that demonstrates the design and implementation of a modern cloud analytics platform.

The project simulates a retail business environment and transforms raw customer, sales, and experimentation data into business-ready analytics models using:

- Google BigQuery
- dbt
- Python
- Power BI

The goal is to demonstrate how raw business data can be transformed into trusted analytical datasets that support reporting, experimentation, and data-driven decision making.

---

# Business Objectives

The platform answers key retail analytics questions:

- Which products and customers generate the most profit?
- How do customer segments perform?
- Are promotions generating incremental value?
- Does a treatment outperform a control group?
- Are experiment results statistically significant?
- Should the business roll out a new strategy?

---

# Architecture

The project follows a modern analytics engineering architecture:

            Source Data

                |
                v

          BigQuery RAW Layer

    +--------------------------+
    | experiment_metadata      |
    | fact_customer_experiment |
    +--------------------------+

                |
                v

          dbt STAGING Layer

    +---------------------------+
    | stg_customer_experiment   |
    +---------------------------+

                |
                v

       dbt INTERMEDIATE Layer

    +---------------------------+
    | int_experiment_metrics    |
    +---------------------------+

                |
                v

          dbt ANALYTICS Layer

    +-------------------------------+
    | mart_experiment_results       |
    | mart_experiment_group_metrics |
    | mart_experiment_statistics    |
    +-------------------------------+

                |
                v

             Power BI


---

# Technology Stack

## Data Warehouse

**Google BigQuery**

Used for:

- Cloud data storage
- SQL analytics
- Scalable processing

---

## Transformation

**dbt Core**

Used for:

- Data modeling
- Testing
- Documentation
- Lineage tracking
- Analytics layer creation

---

## Programming

**Python**

Used for:

- Synthetic data generation
- Experiment creation
- Data loading pipelines

---

## Visualization

**Power BI**

Used for:

- Executive dashboards
- Experiment analysis
- Business insights

---

# Data Model

## Raw Layer

### experiment_metadata

Purpose:

Stores experiment-level configuration.

Grain:

One row per experiment.

Examples:

- Experiment ID
- Promotion ID
- Start date
- End date


---

### fact_customer_experiment

Purpose:

Stores customer-level experiment assignments and outcomes.

Grain:

One row per customer per experiment.

Contains:

- Customer assignment
- Control/Treatment group
- Purchase behavior
- Revenue
- Profit
- Returns

---

# dbt Models

## Staging

### stg_customer_experiment

Purpose:

Clean and standardize raw experiment data before analysis.

Grain:

One row per customer per experiment.

---

## Intermediate

### int_experiment_metrics

Purpose:

Creates reusable experiment metrics by group.

Grain:

One row per experiment and group.

Calculates:

- Customer count
- Purchaser count
- Purchase rate
- Revenue
- Profit
- Profit margin

---

# Analytics Marts

## mart_experiment_results

Purpose:

Executive experiment summary.

Grain:

One row per experiment.

Provides:

- Control performance
- Treatment performance
- Absolute lift
- Relative lift
- Incremental customers
- Incremental revenue
- Incremental profit

Business question:

> Did the experiment create measurable business value?

---

## mart_experiment_group_metrics

Purpose:

Detailed Control vs Treatment analysis.

Grain:

One row per experiment and group.

Used for:

- Power BI comparisons
- Performance analysis
- Experiment drill-downs

---

## mart_experiment_statistics

Purpose:

Statistical evaluation of experiment results.

Provides:

- Conversion comparison
- Lift calculations
- Z-score
- Statistical significance
- Rollout recommendation

Business question:

> Is the observed improvement likely due to the treatment?

---

# Data Quality

dbt tests validate:

- Required fields are populated
- Experiment IDs are unique
- Group values are valid
- Models produce expected outputs

Example:

---

# Running the Project

## Install dependencies

---

## Load data

Run Python pipelines:

---

## Run dbt models

From the dbt directory:

---

## Run tests

---

## Generate documentation

View documentation:

---

# Project Skills Demonstrated

This project demonstrates:

- Analytics Engineering
- Dimensional modeling concepts
- Cloud data warehousing
- SQL development
- dbt development
- Data quality testing
- Documentation
- Experiment analysis
- Statistical testing
- Business intelligence development

---

# Future Enhancements

Planned improvements:

- Additional retail dimensions
- Customer segmentation analytics
- Automated experiment monitoring
- Advanced statistical models
- Power BI executive dashboard
- CI/CD deployment workflow

## dbt Lineage

The dbt project follows a layered analytics architecture:

![dbt lineage graph](screenshots/dbt_lineage.png)