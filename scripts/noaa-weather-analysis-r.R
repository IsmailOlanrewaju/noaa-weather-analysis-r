# =====================================================
# NOAA Weather Analysis in R
# Precipitation Prediction and Regression Modelling
# =====================================================

# -----------------------------------------------------
# 1. Load Libraries
# -----------------------------------------------------

library(readr)
library(tidyverse)
library(tidymodels)
library(glmnet)
library(stringr)
library(ggplot2)

# -----------------------------------------------------
# 2. Load Dataset
# -----------------------------------------------------

weather_raw=read_csv("C:/Users/Hp/OneDrive/Documents/jfk_weather_sample.csv")
glimpse(weather_raw)

# -----------------------------------------------------
# 3. Select Relevant Variables
# -----------------------------------------------------

weather_subset <- weather_raw %>%
  select(
    HOURLYRelativeHumidity,
    HOURLYDRYBULBTEMPF,
    HOURLYPrecip,
    HOURLYWindSpeed,
    HOURLYStationPressure
  )

# -----------------------------------------------------
# 4. Data Cleaning and Preprocessing
# -----------------------------------------------------

weather_clean <- weather_subset %>%
  mutate(
    HOURLYPrecip = ifelse(
      HOURLYPrecip == "T",
      "0.0",
      HOURLYPrecip
    ),

    HOURLYPrecip = str_remove(
      HOURLYPrecip,
      pattern = "s$"
    )
  )

weather_clean <- weather_clean %>%
  mutate(
    HOURLYPrecip = as.numeric(HOURLYPrecip)
  )

# Replace missing precipitation values with 0

weather_clean$HOURLYPrecip[
  is.na(weather_clean$HOURLYPrecip)
] <- 0

# -----------------------------------------------------
# 5. Rename Variables
# -----------------------------------------------------

weather_data <- weather_clean %>%
  rename(
    relative_humidity = HOURLYRelativeHumidity,
    dry_bulb_temp_f = HOURLYDRYBULBTEMPF,
    precip = HOURLYPrecip,
    wind_speed = HOURLYWindSpeed,
    station_pressure = HOURLYStationPressure
  )

# -----------------------------------------------------
# 6. Train-Test Split
# -----------------------------------------------------

set.seed(1234)

weather_split <- initial_split(
  weather_data,
  prop = 0.8
)

weather_train <- training(weather_split)

weather_test <- testing(weather_split)

# -----------------------------------------------------
# 7. Handle Missing Values

colSums(is.na(weather_train))

weather_train_clean <- weather_train %>%
  drop_na(
    precip,
    relative_humidity,
    dry_bulb_temp_f,
    wind_speed,
    station_pressure
  )

# -----------------------------------------------------
# 8. Exploratory Data Analysis
ggplot(weather_train_clean,
       aes(x = relative_humidity)) +
  geom_histogram(bins = 30)

ggplot(weather_train_clean,
       aes(x = dry_bulb_temp_f)) +
  geom_histogram(bins = 30)

ggplot(weather_train_clean,
       aes(x = precip)) +
  geom_histogram(bins = 30)

ggplot(weather_train_clean,
       aes(x = wind_speed)) +
  geom_histogram(bins = 30)

ggplot(weather_train_clean,
       aes(x = station_pressure)) +
  geom_histogram(bins = 30)

# -----------------------------------------------------
# 9. Multiple Linear Regression
# -----------------------------------------------------

model_multiple <- lm(
  precip ~ relative_humidity +
    dry_bulb_temp_f +
    wind_speed +
    station_pressure,
  data = weather_train_clean
)

summary(model_multiple)

pred_multiple <- predict(
  model_multiple,
  newdata = weather_train_clean
)

rmse_multiple <- sqrt(
  mean(
    (weather_train_clean$precip -
       pred_multiple)^2
  )
)

rmse_multiple

# -----------------------------------------------------
# 10. Polynomial Regression
# -----------------------------------------------------

model_poly <- lm(
  precip ~ relative_humidity +
    dry_bulb_temp_f +
    poly(wind_speed, 2) +
    station_pressure,
  data = weather_train_clean
)

summary(model_poly)

pred_poly <- predict(
  model_poly,
  newdata = weather_train_clean
)

rmse_poly <- sqrt(
  mean(
    (weather_train_clean$precip -
       pred_poly)^2
  )
)

rmse_poly

# -----------------------------------------------------
# 11. Ridge Regression
# -----------------------------------------------------

weather_recipe <- recipe(
  precip ~ relative_humidity +
    dry_bulb_temp_f +
    wind_speed +
    station_pressure,
  data = weather_train_clean
)

ridge_model <- linear_reg(
  penalty = tune(),
  mixture = 0
) %>%
  set_engine("glmnet")

ridge_workflow <- workflow() %>%
  add_recipe(weather_recipe) %>%
  add_model(ridge_model)

set.seed(1234)

folds <- vfold_cv(
  weather_train_clean,
  v = 5
)

ridge_tuned <- tune_grid(
  ridge_workflow,
  resamples = folds,
  grid = 20
)

show_best(
  ridge_tuned,
  metric = "rmse"
)

best_ridge <- select_best(
  ridge_tuned,
  metric = "rmse"
)

final_ridge <- finalize_workflow(
  ridge_workflow,
  best_ridge
)

ridge_fit <- fit(
  final_ridge,
  data = weather_train_clean
)

ridge_pred <- predict(
  ridge_fit,
  new_data = weather_train_clean
)

rmse_ridge <- sqrt(
  mean(
    (weather_train_clean$precip -
       ridge_pred$.pred)^2
  )
)

rmse_ridge

# -----------------------------------------------------
# 12. Model Comparison
# -----------------------------------------------------

model_names <- c(
  "Multiple Regression",
  "Polynomial Regression",
  "Ridge Regression"
)

train_error <- c(
  rmse_multiple,
  rmse_poly,
  rmse_ridge
)

comparison_df <- data.frame(
  model_names,
  train_error
)

comparison_df