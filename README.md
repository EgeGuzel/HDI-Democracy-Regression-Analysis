# HDI-Democracy Regression Analysis

## Project Overview

This project employs Multiple Linear Regressionto analyze the association between a country's Liberal Democracy Index (V-Dem) and its Human Development Index (HDI) for the year 2023. The analysis specifically isolates the net effect of democratization by controlling for key confounding variables, including Income Inequality (Gini Index), Health Outcomes (Infant Mortality Rate), Urbanization, and Government Effectiveness. All statistical procedures utilize R and robust standard errors (HC3) to address potential heteroskedasticity in the cross-sectional data.

## Methodology
The analysis follows a rigorous statistical workflow implemented in R:

* **Data Integration:** Merged datasets from UNDP, V-Dem, and the World Bank using ISO3 country codes for high-precision mapping.

* **Statistical Model:** A Multiple Linear Regression (OLS) model was estimated.
  
* **Robustness Checks:**
  * HC3 Robust Standard Errors: Applied to correct for potential heteroskedasticity in cross-national data.
  * Multicollinearity: Verified using Variance Inflation Factor (VIF) to ensure predictors are independent.
  * Outlier Detection: Diagnostic plots (Cook's Distance/Leverage) were used to ensure model stability.

## Data Description
The dataset consists of observations for over 50 countries, standardized for the year 2023.

* **Dependent Variable:**
  * Human Development Index (HDI): A composite statistic of life expectancy, education, and per capita income. Source: United Nations Development Programme (UNDP).

* **Independent Variable:**
  * Liberal Democracy Index (V-Dem): Measuring electoral quality, individual liberties, and judicial independence. Source: Varieties of Democracy (V-Dem) Institute.

* **Control Variables:**
  * Gini Index: Measures income inequality to control for wealth distribution. Source: World Bank (World Development Indicators).
  * Infant Mortality Rate: A proxy for the general quality and accessibility of the healthcare system. Source: World Bank (WDI).
  * Government Effectiveness: Measures state capacity and bureaucratic quality (State Capacity control). Source: World Bank (Worldwide Governance Indicators).
  * Urbanization Rate: Percentage of the population in urban areas to account for structural economic shifts. Source: World Bank (WDI).

## How to Run
1. Clone this repository to your local machine.
2. Ensure you have R and RStudio installed.
3. Place the following datasets in the data/ folder (or the root directory): hdi_2023.csv, v_dem.csv, gini_index.csv, infant_mortality.csv, urban_rate.csv, gov_effect.csv.
4. Open "Project.R". The script will automatically check for and install missing packages (tidyverse, countrycode, sandwich, etc.).
5. Run the script to generate the models and plots.

# Results & Visualizations
The following visualizations offer a comprehensive look at the data's distribution, the individual impact of each predictor, and the overall diagnostic health of our statistical model.

## A First Look: Relationship Between HDI and Democracy Index
The scatterplot above visualizes the raw correlation between the Human Development Index (HDI) and the V-Dem Liberal Democracy Index for 2023. The upward-sloping trend line clearly indicates that as a country's democracy score increases, its HDI also tends to increase.

<img width="1048" height="866" alt="Rplot" src="https://github.com/user-attachments/assets/fb86cb35-d949-49c5-a161-a66b3de2f2a5" />

**Crucial Caveat:** While this shows a strong positive correlation, it does not prove causation. This simple relationship could be driven by other underlying factors, such as national wealth, the distribution of income, or the general quality of the healthcare system. To understand the true net effect of democracy, a multiple regression model—which controls for these additional variables—is necessary.

## Which Factors Are the Most Powerful Drivers of HDI?
This coefficient plot visualizes the results from our multiple regression model, showing the estimated effect and statistical significance of each variable after controlling for all other factors.

<img width="1048" height="866" alt="Rplot01" src="https://github.com/user-attachments/assets/029c3f71-7698-47ca-af8d-2691df11c019" />

## Key Findings & Model Interpretation

* **Positive Drivers (Boosts HDI):**

  * Democracy: As predicted, liberal democracy is a highly significant positive driver. Even when controlling for state capacity and wealth, democratic institutions provide a unique contribution to human development.

  * Government Effectiveness: This is another powerful positive predictor. It shows that the quality of public services and bureaucratic efficiency are essential for high HDI scores.

* **Negative Drivers (Lowers HDI):**

  * Infant Mortality: This is one of the strongest predictors in our model. Higher infant mortality rates—a proxy for poor healthcare access—are significantly associated with lower human development.

  * Income Inequality (Gini Index): High inequality has a statistically significant negative impact, suggesting that concentrated wealth hinders broad-based human development.

* **Statistical Significance:**
Notice that the error bars for Democracy, Government Effectiveness, and Infant Mortality do not cross the dashed vertical line (0). This confirms they are all statistically significant.

  * Urbanization Rate: In our specific model, urbanization shows the smallest effect. If its error bars touch or cross the zero line, it means living in cities is less critical for development than the quality of institutions and social equity.

**Summary:** Our model proves that "Institutional Quality" (Democracy & Governance) and "Social Equity" (Health & Equality) are far more critical for a nation's development than simple urbanization.

<img width="5400" height="600" alt="hdi_denklem_final" src="https://github.com/user-attachments/assets/fab29089-40f7-4a21-b655-b73eec9ccf08" />

This study employs an Ordinary Least Squares (OLS) regression model to quantify the socioeconomic determinants of the Human Development Index (HDI). The model demonstrates high explanatory power, with an Adjusted R-squared of 0.8868, indicating that nearly 89% of the variance in human development levels across the sampled jurisdictions is accounted for by the included predictors. The overall model is highly significant (F=82.49,p<2.2e−16), validating the robustness of the selected variables.

<img width="1600" height="625" alt="Code_Generated_Image" src="https://github.com/user-attachments/assets/a51530b7-c0db-4c29-8625-f53c9c95aaff" />

Signif. codes:  0 ‘ * * * ’ 0.001 ‘ * * ’ 0.01 ‘ * ’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.03282 on 47 degrees of freedom
Multiple R-squared:  0.8977,	Adjusted R-squared:  0.8868 
F-statistic: 82.49 on 5 and 47 DF,  p-value: < 2.2e-16

### Key Coefficient Analysis:

* **Democracy Index (β=0.1211):** This is the most significant positive predictor (p<0.001). For every one-unit increase in the democracy index, the HDI is expected to rise by approximately 0.12 points, highlighting the critical role of political stability and civil liberties in human welfare.

* **Infant Mortality Rate (β=−0.0053):** As expected, there is a strong negative correlation (p<0.001). Higher mortality rates directly indicate deficiencies in healthcare infrastructure, leading to a decline in overall development scores.

* **Gini Index (β=−0.0025):** Income inequality has a statistically significant negative impact on HDI (p<0.01). This suggests that even in growing economies, high levels of wealth concentration can hinder broad-based human development.

* **Urbanization Rate (β=0.0008):** Although positive and statistically significant (p<0.05), the direct impact of urbanization on HDI is relatively marginal compared to political and health factors.

* **Government Efficiency (β=0.0174):** While the coefficient is positive, it is only marginally significant at the 10% level (p=0.056). This suggests a trend where better governance leads to higher HDI, though the relationship in this specific dataset is less definitive than others.

## Verifying the Results: Model Reliability Checks

**1. VIF Test (Variance Inflation Factor):** Checks for multicollinearity among independent variables; a high VIF value indicates that predictors are overly correlated, which can distort coefficient estimates.

<img width="1048" height="860" alt="Rplot02" src="https://github.com/user-attachments/assets/90056772-1b20-4a3f-ab14-0b25ebb25764" />

**Interpretation:** Our model passed this test successfully as all VIF values remained well below the critical threshold of 5, indicating that variables like Democracy and Gini Index provide independent and reliable information to the model.

**2. Residuals Plot:** Examined to see if the error terms are randomly distributed, confirming whether the model has successfully captured the underlying patterns in the data.

<img width="1048" height="860" alt="Rplot03" src="https://github.com/user-attachments/assets/97d776a4-c561-4f08-990b-351d726fe5bd" />

**Interpretation:** The residuals are randomly scattered around the zero line without any distinct patterns, suggesting that our linear specification for HDI determinants is appropriate.

**3. Fitted vs. Actual Plot:** Visualizes the alignment between the model's predictions and the real-world data; points clustering along a diagonal line signify high predictive accuracy.

<img width="1048" height="860" alt="Rplot04" src="https://github.com/user-attachments/assets/f840ce22-06bb-41a1-8169-6cf2a3edc7a0" />

**Interpretation:** The strong alignment of data points along the diagonal confirms the model's high predictive power, consistent with our high Adjusted R-squared of 0.8868.

**4. Residuals vs. Fitted Plot:** Used to verify homoscedasticity (constant variance of errors) and to ensure that the relationship between variables is appropriately modeled as linear.
  * **Interpretation:** The relatively constant spread of residuals across all fitted values confirms homoscedasticity, meaning the model's accuracy is stable across different levels of human development.

**5. Scale-Location Plot:** Examines the spread of standardized residuals over the range of fitted values to more clearly detect potential heteroscedasticity issues.
  * **Interpretation:** The horizontal line with equally spread points indicates that the variance of our error terms is constant, fulfilling one of the key Gauss-Markov assumptions for OLS.
  * 
**6. Q-Q Residuals Plot:** Checks if the error terms follow a normal distribution; points falling along the 45-degree line support the normality assumption required for valid t-tests and F-tests.
    * **Interpretation:** Most residuals fall directly on the 45-degree reference line, proving that our error terms are normally distributed and our p-values for coefficients like Democracy (p<0.001) are statistically valid.

**7. Residuals vs. Leverage Plot:** Identifies influential outliers or leverage points that may be disproportionately biasing the regression results.
  * **Interpretation:** No data points fall outside the Cook’s distance boundaries, ensuring that our final coefficients are not being skewed by any single influential country or observation.

<img width="1048" height="860" alt="Rplot05" src="https://github.com/user-attachments/assets/9d81518d-6fd8-4686-b450-c0cda1ef8cc9" />
