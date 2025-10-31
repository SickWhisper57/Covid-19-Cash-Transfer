#  Causal Impact Analysis: COVID-19 Cash Transfers on Small Businesses in Kenya

## Project Overview

This repository is an independent replication of the 2022 *Journal of Development Economics* paper, **"Cash Transfers as a Response to COVID-19: Experimental Evidence from Kenya."**

My objective was to validate the original paper's findings by translating its Stata-based econometric methodology into a modern **R** workflow. The project successfully reproduces the causal impact of cash transfers on key business outcomes, demonstrating a strong understanding of data analysis and causal inference.

* **Original Publication:** [https://www.sciencedirect.com/science/article/pii/S0304387822000840](url)
* **Replication By:** Tanish Bhagat

---

## Technical Stack & Methods

* **Programming Language:** R
* **Key R Packages:**
    * **`haven`**: For loading the original Stata (`.dta`) dataset.
    * **`dplyr`**: For all data cleaning and transformation.
    * **`fixest`**: For high-performance, advanced panel data regression.
* **Statistical Method:** **Two-Way Fixed Effects (TWFE) Regression**. This model isolates the *causal* impact of the cash transfer by controlling for:
    1.  **Individual Fixed Effects** (`identifier`): Any unobserved, unchanging characteristics of a business (e.g., a great location, a talented owner).
    2.  **Time Fixed Effects** (`period2`): Any shocks that affected *all* businesses at the same time (e.g., a new lockdown rule, a holiday).

---

## Key Findings & Visualizations

The analysis successfully replicated the paper's main conclusions.

### 1. Average Treatment Effect (Bar Chart)

The cash transfer had a large, statistically significant positive effect on **Revenue** and a smaller, but still significant, positive effect on **Food Spend**. It had **no significant effect on Profit**.

<img width="565" height="335" alt="bar chart" src="https://github.com/user-attachments/assets/de30882c-8507-412b-b383-6ffd28be2992" />


### 2. Dynamic Impact on Profit Over Time (Line Chart)

To see *why* profit wasn't affected, I ran an "event study" to check the effect week-by-week.

The results show that the effect on profit was **never statistically different from zero** in any period. The blue line (the effect) bounces around zero, and the error bars always overlap the zero line, confirming our first finding.

<img width="501" height="310" alt="line chart" src="https://github.com/user-attachments/assets/65baaddd-5167-474c-9bbc-c68910ed416b" />



