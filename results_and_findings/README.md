# Results and Findings

## Introduction

One of the major challenges in precipitation modelling is that rainfall behaviour is highly irregular and difficult to predict accurately. Unlike variables such as temperature or atmospheric pressure, precipitation does not occur consistently across time. Most observations in weather datasets typically record little or no rainfall, while only a small number of observations represent moderate or extreme rainfall events. This creates an imbalanced and highly skewed target variable that complicates statistical modelling.

The goal of this analysis was therefore not simply to predict precipitation, but to understand how atmospheric conditions such as humidity, temperature, wind speed, and station pressure contribute to rainfall behaviour and whether meaningful predictive relationships could still be extracted from the data despite these limitations.

To address this problem, the dataset first underwent preprocessing and cleaning to remove invalid precipitation values, handle missing observations, and convert weather variables into numerical formats suitable for statistical analysis. After preprocessing, exploratory data analysis was conducted to understand the behaviour and distribution of the atmospheric variables before model construction.

A baseline multiple regression model was then developed to evaluate the combined influence of the selected atmospheric predictors on precipitation. Additional modelling techniques such as polynomial regression and Ridge regularization were later introduced to test whether nonlinear relationships or coefficient regularization could improve predictive performance and model stability.

The findings below present the major statistical observations, graphical interpretations, and modelling insights obtained throughout the analysis.

---

# Exploratory Data Analysis

## Precipitation Distribution

The precipitation variable displayed a highly right-skewed distribution with a large concentration of observations around zero rainfall. This indicates that most hourly observations experienced little or no precipitation, while relatively few observations represented moderate or heavy rainfall events.

This imbalance is common in climatological precipitation datasets and reflects the irregular nature of rainfall events. The long right tail observed in the histogram suggests the presence of occasional extreme precipitation values.

The skewed distribution also highlights one of the major modelling challenges in precipitation prediction. Since precipitation is not normally distributed, linear regression models may struggle to fully capture rainfall variability, especially during extreme weather events.

---

## Relative Humidity Distribution

The distribution of relative humidity was concentrated at higher humidity levels, with most observations ranging between approximately 50% and 95%. This indicates that humid atmospheric conditions were common throughout the sampled period at JFK Airport.

The histogram showed relatively few extremely low humidity observations, suggesting that dry atmospheric conditions occurred less frequently. Higher humidity levels are meteorologically important because elevated atmospheric moisture increases the likelihood of cloud formation and precipitation events.

Compared to the precipitation variable, relative humidity exhibited a more stable and evenly distributed pattern with fewer extreme outliers. This made it a suitable predictor candidate for precipitation modelling due to its relationship with atmospheric moisture content.

---

## Dry Bulb Temperature Distribution

The dry bulb temperature variable displayed an approximately bell-shaped distribution with observations spread across a broad temperature range. Most temperatures fell between roughly 35°F and 80°F, indicating substantial atmospheric variability across the sampled weather periods.

Compared to the precipitation variable, temperature exhibited a more balanced and statistically stable distribution with fewer extreme values. The relatively balanced distribution and moderate variability of dry bulb temperature make it well-suited for regression-based modelling approaches.

The histogram also showed mild clustering around certain temperature ranges, which may reflect seasonal weather patterns captured within the dataset. From a meteorological perspective, temperature plays an important role in atmospheric moisture dynamics and precipitation formation processes.

---

## Wind Speed Distribution

The wind speed variable exhibited a positively skewed distribution, with most observations concentrated between approximately 5 and 15 mph. Higher wind speed events occurred less frequently, resulting in a long right tail extending toward more extreme wind conditions.

This pattern is typical in meteorological datasets where calm to moderate winds are substantially more common than severe wind events. The histogram suggests that the dataset was dominated by relatively stable atmospheric conditions, with only occasional periods of strong winds likely associated with storms or weather disturbances.

The skewed nature of the distribution also suggests that the relationship between wind speed and precipitation may not be entirely linear. This provided additional motivation for exploring polynomial regression techniques to better capture potential nonlinear atmospheric interactions.

---

## Station Pressure Distribution

The station pressure variable displayed an approximately symmetric and near-normal distribution centered around standard atmospheric pressure levels near 30.0 inches Hg. Most observations fell within a relatively narrow range, indicating generally stable atmospheric pressure conditions during the sampled period.

Compared to variables such as precipitation and wind speed, station pressure exhibited lower variability and a more stable distribution pattern. This behaviour is consistent with meteorological expectations, as atmospheric pressure typically fluctuates within a constrained physical range.

Despite the relatively small variation in pressure values, station pressure remains meteorologically important in weather prediction. Lower pressure systems are commonly associated with unstable atmospheric conditions and rainfall events, while higher pressure systems are generally linked to calmer and drier weather conditions.

---

# Multiple Regression Interpretation

The multiple linear regression model was statistically significant overall (F-test p < 0.001), indicating that the selected atmospheric variables collectively contributed to precipitation prediction.

Relative humidity, wind speed, and station pressure were statistically significant predictors of precipitation. Relative humidity and wind speed showed positive relationships with precipitation, while station pressure displayed a negative relationship, consistent with meteorological expectations where lower pressure systems are commonly associated with rainfall events.

Dry bulb temperature was not statistically significant after accounting for the other atmospheric predictors, suggesting that its contribution to precipitation variability may overlap with variables such as humidity and pressure.

Although the model achieved statistical significance, the overall explanatory power remained modest (R² ≈ 0.032). This suggests that precipitation behaviour is influenced by additional atmospheric and environmental factors not fully captured within the selected predictors. The highly skewed and irregular nature of precipitation data also contributes to the difficulty of accurately modelling rainfall behaviour using linear regression techniques.

---

# Polynomial Regression Interpretation

To account for potential nonlinear relationships between atmospheric variables and precipitation, a polynomial regression model was developed by introducing a second-degree polynomial term for wind speed.

The overall polynomial regression model remained statistically significant (F-test p < 0.001), indicating that the selected predictors collectively contributed to precipitation prediction. Relative humidity and station pressure remained statistically significant predictors, showing similar directional relationships to those observed in the multiple linear regression model.

The first polynomial wind speed component was statistically significant, suggesting that wind speed contributed meaningfully to precipitation prediction. However, the second-degree polynomial component was not statistically significant, indicating limited evidence of a strong nonlinear wind speed effect within the dataset.

Dry bulb temperature again remained statistically insignificant after controlling for the other atmospheric variables, suggesting that its predictive contribution may overlap with variables such as humidity and pressure.

The polynomial regression model produced an RMSE of approximately 0.0365 and an R² value of approximately 0.032, representing only a marginal change relative to the baseline multiple regression model. This suggests that introducing polynomial terms did not substantially improve overall predictive performance.

The limited improvement observed from polynomial regression indicates that precipitation behaviour within the dataset may be influenced by additional nonlinear atmospheric processes and external environmental factors not fully captured by the selected predictors.

---

# Ridge Regression Interpretation

Ridge regression was implemented to evaluate whether coefficient regularization could improve model stability and predictive performance. The Ridge model applies L2 regularization by shrinking coefficient magnitudes while retaining all predictors within the model.

The Ridge regression model produced an RMSE of approximately 0.03648, which was very similar to the results obtained from the baseline multiple regression and polynomial regression models. This suggests that regularization did not substantially improve predictive accuracy within the selected feature set.

The limited improvement from Ridge regression indicates that severe overfitting or extreme multicollinearity was likely not present among the selected atmospheric predictors. The relatively stable performance across models suggests that the baseline regression structure was already reasonably robust.

Although Ridge regression did not significantly outperform the other models, it still provided useful insight into model stability and the overall behaviour of the atmospheric predictor variables.

---

# Model Diagnostic Plot Interpretation

The Actual vs Predicted precipitation plot showed that the regression model was able to capture lower precipitation levels reasonably consistently, particularly around observations with little or no rainfall.

However, the model struggled to accurately predict larger precipitation events, as higher actual precipitation values continued to receive relatively small predicted values. This pattern reflects the difficulty of modelling highly skewed and irregular rainfall behaviour using linear regression techniques.

The clustering of observations near low precipitation values is consistent with the underlying precipitation distribution, where most hourly observations recorded little or no rainfall. The diagnostic plot therefore reinforces the earlier findings regarding the challenges of precipitation prediction and the limited explanatory power of the regression models.

---

# Overall Conclusion

The analysis demonstrated that atmospheric variables such as relative humidity, wind speed, and station pressure contribute meaningfully to precipitation prediction and exhibit relationships consistent with meteorological expectations.

Despite achieving statistical significance, the regression models produced only modest explanatory power, highlighting the complex and stochastic nature of precipitation behaviour. Polynomial regression and Ridge regularization produced only marginal performance improvements relative to the baseline multiple regression model.

Overall, the project illustrates both the usefulness and limitations of regression-based approaches for precipitation modelling while demonstrating the importance of exploratory data analysis, feature interpretation, and model evaluation in climatological data science workflows.
