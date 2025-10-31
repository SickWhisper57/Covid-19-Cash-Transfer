# 1. Load Libraries
library(haven)
library(dplyr)
library(fixest)

# 2. Load the Stata Dataset
data <- read_dta("BDJO_Dataset.dta")

# 3. RENAME COLUMNS
data <- data %>% 
  rename_with(~gsub("^groupgeneral", "gg_", .x), .cols = starts_with("groupgeneral"))

print("--- Data loaded and columns renamed! ---")

# 4. FILTER DATA
data_filtered <- data %>%
  filter(week < 900)

print("--- Data filtered! ---")

# 5. CREATE PERIOD VARIABLES
data_with_periods <- data_filtered %>%
  mutate(
    # --- THIS LOGIC IS NOW FIXED ---
    period = case_when(
      week <= -1 ~ -1,
      week >= 0 & week <= 3 ~ 0,
      week >= 4 & week <= 5 ~ 1,
      week >= 6 & week <= 7 ~ 2,
      week >= 8 & week <= 9 ~ 3,
      week >= 10 & week <= 11 ~ 4,
      week >= 12 & week <= 13 ~ 5,
      week >= 14 & week < 15 ~ 6,  # <-- Corrected line
      week >= 15 & week <= 17 ~ 7, # <-- Corrected line
      TRUE ~ NA_real_ 
    ),
    period2 = ifelse(period >= 0, period, NA_real_)
  )

print("--- Period variables created! ---")


# 6. Prepare the Data
data_clean <- data_with_periods %>%
  mutate(
    gg_open = (gg_businessstatus == 0), 
    gg_profit = ifelse(gg_open == TRUE, 0, gg_profit),
    gg_hoursopen = ifelse(gg_open == TRUE, 0, gg_hoursopen),
    
    # Create 'asinh' transformed variables
    atgg_profits = asinh(gg_profit),
    atgg_revenue = asinh(gg_revenue),
    atgg_inventoryspending = asinh(gg_inventoryspending),
    atgg_foodspend = asinh(gg_foodspend),
    atgg_hoursopen = asinh(gg_hoursopen)
  )

print("--- Data cleaned successfully! ---")


# 7. *** NEW DEBUGGING STEP ***
# Let's check our key variables for NAs before we run the regression.
print("--- Debugging Summary: Checking for NAs ---")
summary_data <- data_clean %>%
  select(atgg_profits, treat, identifier, period2)

print(summary(summary_data))


# 8. Run the Core Regressions
print("--- Running regressions for Table 1... ---")
# We'll add 'na.rm = TRUE' to be safe.
model_profit <- feols(atgg_profits ~ treat | identifier + period2,
                      cluster = ~identifier,
                      data = data_clean,
                      na.rm = TRUE) # Tells feols to drop NAs

model_revenue <- feols(atgg_revenue ~ treat | identifier + period2,
                       cluster = ~identifier,
                       data = data_clean,
                       na.rm = TRUE)

model_foodspend <- feols(atgg_foodspend ~ treat | identifier + period2,
                         cluster = ~identifier,
                         data = data_clean,
                         na.rm = TRUE)

# 9. Display Results in R Console
print("--- Replication Results: ---")
etable(model_profit, model_revenue, model_foodspend)

# 10. Extract Key Results for Excel
results_for_excel <- data.frame(
  Outcome = c("Profit (asinh)", "Revenue (asinh)", "Food Spend (asinh)"),
  Coefficient = c(
    coef(model_profit)["treat"],
    coef(model_revenue)["treat"],
    coef(model_foodspend)["treat"]
  ),
  StdError = c(
    se(model_profit)["treat"],
    se(model_revenue)["treat"],
    se(model_foodspend)["treat"]
  )
)

# 11. Save to a CSV File
write.csv(results_for_excel, "results_for_excel.csv", row.names = FALSE)

print("--- Successfully exported results to results_for_excel.csv! ---")
