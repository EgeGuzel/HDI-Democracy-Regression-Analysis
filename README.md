# HDI-Democracy Regression Analysis

## Project Overview

This project employs Multiple Linear Regressionto analyze the association between a country's Liberal Democracy Index (V-Dem) and its Human Development Index (HDI) for the year 2023. The analysis specifically isolates the net effect of democratization by controlling for key confounding variables, including Income Inequality (Gini Index), Health Outcomes (Infant Mortality Rate), Urbanization, and Government Effectiveness. All statistical procedures utilize R and robust standard errors (HC3) to address potential heteroskedasticity in the cross-sectional data.

## Data Overview

* **hdi_2023:** Human Development Index (HDI), our dependent variable. It provides a more holistic view of national success than GDP alone by combining life expectancy, education, and standard of living. The data is taken from UNDP.

* **v_dem:** V-Dem Liberal Democracy Index, the primary independent variable. Unlike simple "democracy" checks, this index uses expert coding to measure the protection of individual liberties and legislative constraints on the executive. The data is taken from V-Dem Institute.

* **gov_effect:** Government Effectiveness, used as a control for "State Capacity." This helps us distinguish between a country that is simply "well-run" (bureaucracy) versus one that is "democratic". The data is taken from World Bank.

* **indant_mortality:** Infant Mortality Rate, included to account for the baseline level of public health and infrastructure in a country. The data is taken from World Bank.

* **gini_index:** Gini Index, controls for the distribution of wealth, ensuring that a high average income (which boosts HDI) isn't masking extreme poverty. The data is taken from World Bank.

* **urban_rate:** Urbanization Rate, measures the percentage of the total population living in urban areas. This is a critical structural control, as urbanization is often linked to better access to education, technology, and specialized labor markets that naturally improve HDI scores. The data is taken from World Bank.
