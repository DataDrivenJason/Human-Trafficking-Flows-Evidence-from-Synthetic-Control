library(readxl)
library(ggplot2)
library(dplyr)
library(tidyr)
library(broom)



#DATA 
FH_FIW <- read_excel("Masters 2023/Masters Year 2/Human trafficking papers/DATA/FH-FIW.xlsx")
Human_trafficking_in_persons_data <- read_excel("Masters Year 2/Human trafficking papers/DATA/Human trafficking in persons data.xlsx")
GDP_growth <- read.csv("Masters 2023/Masters Year 2/Human trafficking papers/DATA/API_NY.GDP.MKTP.KD.ZG_DS2_en_csv_v2_26269.csv", skip = 4)
net_migration <- read.csv("Masters 2023/Masters Year 2/Human trafficking papers/DATA/API_SM.POP.NETM_DS2_en_csv_v2_13382.csv", skip = 4)
refugee_data <- read.csv("Masters 2023/Masters Year 2/Human trafficking papers/DATA/API_SM.POP.REFG_DS2_en_csv_v2_18910.csv", skip = 4)
unemployment <- read.csv("Masters 2023/Masters Year 2/Human trafficking papers/DATA/Unemployment (%).csv")

######## ALL VARIABLES

# long_data_FH
# Human_trafficking_in_persons_data
# long_data_gpd_growth
# net_migration
# refugee_data
# unemployment



######################################
###################################### subsetting FH FIW
######################################
filtered_data_2013_2024 <- FH_FIW %>%
  filter(`Economy Name` %in% c("Germany", "Ukraine")) %>%
  select(`Economy Name`, `Economy ISO3`, `Indicator ID`, Indicator, `Attribute 1`, `Attribute 2`, `Attribute 3`, Partner, `2013`:`2024`)

long_data_FH <- filtered_data_2013_2024 %>%
  gather(key = "Year", value = "Score", `2013`:`2024`) %>%
  mutate(Year = as.integer(Year))  



###########################
########################### Human trafficking  filtered
###########################
col_names <- as.character(Human_trafficking_in_persons_data[2, ])
trafficing_data_clean <- Human_trafficking_in_persons_data[-c(1,2), ]
colnames(trafficing_data_clean) <- col_names

filtered_data_trafficking <- trafficing_data_clean  %>%
  filter(Country %in% c("Germany", "Ukraine"))%>%
  select(Iso3_code, Country, Indicator, Year)


##################################
################################## GDP done 
##################################
filtered_data_gdp <- GDP_growth %>%
  filter(Country.Name %in% c("Ukraine", "Germany")) %>%
  select(Country.Name, Country.Code, Indicator.Name, Indicator.Code, 
         X2000:X2023)


# Reshape the data from wide to long format
long_data_gpd_growth <- filtered_data_gdp %>%
  gather(key = "Year", value = "GDP_growth", X2000:X2023) %>%
  mutate(Year = as.integer(sub("X", "", Year)))%>%
  select(Country.Name, Year, GDP_growth)



###############################
############################### NET MIGRATION 
###############################
# Filter for Germany and Ukraine, and select columns for years 2000 to 2024
filtered_data_nm <- net_migration %>%
  filter(Country.Name %in% c("Germany", "Ukraine")) %>%
  select(Country.Name, X2000:X2023)

# Reshape the data from wide to long format
long_data_NETMIG <- filtered_data_nm %>%
  gather(key = "Year", value = "Net_Migration", X2000:X2023) %>%
  mutate(Year = as.integer(sub("X", "", Year)))  


#################################
################################# REFUGEE POPULATION
################################# 
filtered_data_refugee <- refugee_data %>%
  filter(Country.Name %in% c("Germany", "Ukraine")) %>%
  select(Country.Name, X2000:X2023)

long_data_refugee_log <- filtered_data_refugee %>%
  gather(key = "Year", value = "Refugee_Population", X2000:X2023) %>%
  mutate(Year = as.integer(sub("X", "", Year))) %>%
  mutate(Log_Refugee_Population = log(Refugee_Population + 1))



###################################
################################### Unemployment 
###################################
subset_data_unemployment <- unemployment %>%
  filter(Country.Name %in% c("Germany", "Ukraine") & Year >= 2000 & Year <= 2023) %>%
  select(Country.Name, Year, Value)


#Diff in Diff with regression set up 
filtered_data_trafficking <- filtered_data_trafficking %>%
  filter(!is.na(Indicator)) %>%
  mutate(
    treatment = ifelse(Country == "Ukraine", 1, 0),
    post = ifelse(Year >= 2022, 1, 0),
    did = treatment * post
  )

filtered_data_trafficking$Indicator_numeric <- ifelse(filtered_data_trafficking$Indicator == "Persons convicted", 1,
                                                      ifelse(filtered_data_trafficking$Indicator == "Detected trafficking victims", 2, NA))

filtered_data_trafficking <- na.omit(filtered_data_trafficking)


model_simple <- lm(Indicator_numeric ~ treatment + post + did, data = filtered_data_trafficking)

#GRAPHS 
#plots

# Plot the GDP growth of a country
ggplot(long_data_gpd_growth, aes(x = Year, y = GDP_growth, color = Country.Name, group = Country.Name)) +
  geom_line(size = 1) +  # Line plot
  geom_point(size = 2) +  # Add points at each year
  labs(title = "GDP Growth (Annual %) from 2000 to 2023",
       x = "Year",
       y = "GDP Growth (Annual %)",
       color = "Country") +
  theme_minimal() +
  theme(legend.position = "top")


#PLOT of the net migration 
migration_plot <- ggplot(long_data_NETMIG, aes(x = Year, y = Net_Migration, color = Country.Name, group = Country.Name)) +
  geom_line(size = 1) +  # Line plot
  geom_point(size = 2) +  # Add points at each year
  labs(title = "Net Migration (Annual) for Germany and Ukraine (2000-2023)",
       x = "Year",
       y = "Net Migration",
       color = "Country") +
  theme_minimal() +  # Apply a minimal theme
  theme(legend.position = "top")

#plot of the log refugee population
ggplot(long_data_refugee_log, aes(x = Year, y = Log_Refugee_Population, color = Country.Name, group = Country.Name)) +
  geom_line(size = 1) +  # Line plot
  geom_point(size = 2) +  # Add points at each year
  labs(title = "Log-Transformed Refugee Population for Germany and Ukraine (2000-2023)",
       x = "Year",
       y = "Log of Refugee Population",
       color = "Country") +
  theme_minimal() +  # Apply a minimal theme
  theme(legend.position = "top")


#Plot of the unemployement rate
unemployment <- ggplot(subset_data_unemployment, aes(x = Year, y = Value, color = Country.Name, group = Country.Name)) +
  geom_line(size = 1) +   
  geom_point(size = 2) + 
  labs(title = "Unemployment Rate for Germany and Ukraine (2000-2023)",
       x = "Year",
       y = "Unemployment Rate (%)",
       color = "Country") +
  theme_minimal() +  
  theme(legend.position = "top")






