required_packages <- c("tidyverse", "countrycode", "broom", "sandwich", "lmtest", "car", "modelsummary")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) {install.packages(new_packages, dependencies = TRUE)}
invisible(sapply(required_packages, library, character.only = TRUE))

hdi_2023          <- read_csv("hdi_2023.csv", show_col_types = FALSE)
v_dem             <- read_csv("v_dem.csv", show_col_types = FALSE)
gini              <- read_csv("gini_index.csv", show_col_types = FALSE)
infant_mortality  <- read_csv("infant_mortality.csv", show_col_types = FALSE)
urban_rate        <- read_csv("urban_rate.csv", show_col_types = FALSE)
gov_effect        <- read_csv("gov_effect.csv", show_col_types = FALSE)

#HDI
hdi_raw <- read_csv("hdi_2023.csv", col_names = FALSE, show_col_types = FALSE)
header_row <- 6
hdi <- hdi_raw %>%
  slice((header_row + 1):n()) %>%
  set_names(hdi_raw[header_row, ]) %>%
  select(country = Country, HDI = Value) %>%
  mutate(HDI = as.numeric(HDI), iso3 = countrycode(country, "country.name", "iso3c")) %>%
  filter(!is.na(iso3), !is.na(HDI)) %>%
  distinct(iso3, .keep_all = TRUE)

#DEMOCRACY INDEX
v_dem <- read_csv("v_dem.csv", show_col_types = FALSE)
v_dem <- v_dem %>%
  filter(year == 2023) %>%
  select(iso3 = country_text_id, democracy = v2x_libdem) %>%
  filter(!is.na(iso3), !is.na(democracy)) %>%
  distinct(iso3, .keep_all = TRUE)

#INCOME EQUALITY INDEX
gini <- read_csv("gini.csv", skip = 4, show_col_types = FALSE)
gini <- gini %>%
  select(iso3 = `Country Code`, gini = `2023`) %>%
  mutate(gini = as.numeric(gini)) %>%
  filter(!is.na(iso3), !is.na(gini)) %>%
  distinct(iso3, .keep_all = TRUE)

#INFANT MORTALITY RATE
infant_mortality <- read_csv("infant_mortality.csv", skip = 4, show_col_types = FALSE)
infant_mortality <- infant_mortality %>%
  select(iso3 = `Country Code`, infant_mortality = `2023`) %>%
  mutate(infant_mortality = as.numeric(infant_mortality)) %>%
  filter(!is.na(iso3), !is.na(infant_mortality)) %>%
  distinct(iso3, .keep_all = TRUE)

#URBANIZATIN RATE
urban_rate <- read_csv("urban_rate.csv", skip = 4, show_col_types = FALSE)
urban_rate <- urban_rate %>%
  select(iso3 = `Country Code`, urban_rate = `2023`) %>%
  mutate(urban_rate = as.numeric(urban_rate)) %>%
  filter(!is.na(iso3), !is.na(urban_rate)) %>%
  distinct(iso3, .keep_all = TRUE)

#GOVERNMENT EFFICIENCY SCORE
gov_effect_raw <- read_csv("gov_effect.csv", show_col_types = FALSE)
names(gov_effect_raw)
gov_effect <- gov_effect_raw %>%
  transmute(iso3 = `Country Code`, gov_effect = readr::parse_number(`2023 [YR2023]`)) %>%
  filter(!is.na(iso3), !is.na(gov_effect)) %>%
  distinct(iso3, .keep_all = TRUE)

#MERGING THE DATA
data_final <- hdi %>%
  left_join(v_dem, by = "iso3") %>%
  left_join(gini, by = "iso3") %>%
  left_join(infant_mortality, by = "iso3") %>%
  left_join(urban_rate, by = "iso3") %>%
  left_join(gov_effect, by = "iso3") %>%
  drop_na()

model_final <- lm(
  HDI ~ democracy + gini + infant_mortality + urban_rate + gov_effect,
  data = data_final)

summary(model_final)
coeftest(model_final, vcov = vcovHC(model_final, type = "HC3"))

vif(model_final)

nrow(data_final) #NUMBER OF DATA AVALIABLE

#HDI AND DEMOCRACY
ggplot(data_final, aes(democracy, HDI)) +
  geom_point(alpha = 0.75) +
  geom_smooth(method = "lm", se = TRUE) +
  theme_minimal(base_size = 13) +
  labs(
    title = "Democracy and Human Development (2023)",
    x = "V-Dem Liberal Democracy Index",
    y = "HDI")

#COEFFICIENT PLOT
tidy(model_final, conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
  ggplot(aes(estimate, term)) +
  geom_point(size = 2.8) +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  theme_minimal(base_size = 13) +
  labs(
    title = "Coefficient Plot (Model, 95% CI)",
    x = "Coefficient estimate",
    y = "Predictors")

#RESIDUAL PLOT
data_final <- data_final %>%
  mutate(
    fitted = fitted(model_final),
    resid  = residuals(model_final))

ggplot(data_final, aes(fitted, resid)) +
  geom_point(alpha = 0.7) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  theme_minimal(base_size = 13) +
  labs(
    title = "Residual Plot",
    x = "Fitted HDI",
    y = "Residuals")

#ACTUALY vs FITTED HDI
ggplot(data_final, aes(fitted, HDI)) +
  geom_point(alpha = 0.75) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  theme_minimal(base_size = 13) +
  labs(
    title = "Actual vs Fitted HDI",
    x = "Predicted HDI",
    y = "Observed HDI")

sapply(data_final[, c("HDI","democracy","gini","infant_mortality","urban_rate","gov_effect")], class)
summary(data_final[, c("HDI","democracy","gini","infant_mortality","urban_rate","gov_effect")])
summary(model_final)

cor.test(data_final$HDI, data_final$democracy) #PEARSON'S CORRELATION

par(mfrow = c(2, 2))
plot(model_final)
par(mfrow = c(1, 1)) #RESIDUALS GRAPHS

bptest(model_final) #BPTEST