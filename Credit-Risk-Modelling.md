Credit Risk Modelling
================

#### Loading the data

Data can be found
[Here](https://raw.githubusercontent.com/obaidpervaizgill/CreditRiskModelling/master/credit.csv).
We will exclude the `phone` variable. We will also convert the dependent
variable `default` to a factor

``` r
library(tidyverse)
credit_data <- read_csv("https://raw.githubusercontent.com/obaidpervaizgill/CreditRiskModelling/master/credit.csv") %>% select(- 16) %>% 
  mutate(default = factor(default))
head(credit_data)
```

    # A tibble: 6 x 16
      checking_balance months_loan_dur~ credit_history purpose amount
      <chr>                       <dbl> <chr>          <chr>    <dbl>
    1 < 0 DM                          6 critical       furnit~   1169
    2 1 - 200 DM                     48 good           furnit~   5951
    3 unknown                        12 critical       educat~   2096
    4 < 0 DM                         42 good           furnit~   7882
    5 < 0 DM                         24 poor           car       4870
    6 unknown                        36 good           educat~   9055
    # ... with 11 more variables: savings_balance <chr>, employment_duration <chr>,
    #   percent_of_income <dbl>, years_at_residence <dbl>, age <dbl>,
    #   other_credit <chr>, housing <chr>, existing_loans_count <dbl>, job <chr>,
    #   dependents <dbl>, default <fct>

``` r
# Tabulating the dependent variable
table(credit_data$default)
```

``` 

 no yes 
700 300 
```

#### Creating the train and test sets

We will use the `CreateDataPartition` function of the `caret` package to
ensure proportionality of the response variable in the train and test
sets.

``` r
library(caret)
indexes <- createDataPartition(credit_data$default, times = 1, p = 0.7)
train <- credit_data[indexes$Resample1, ]
test <- credit_data[-indexes$Resample1, ]
```

#### Training the model

We can use logistics regression since the response variable is binary.

``` r
train_model <- glm(default ~., data = train, family = "binomial")

# Predicting
test_pred <- predict(train_model, test[, 1:15])
```
