# The Causal Effect of the 2017 Honduran Election Crisis on Human Trafficking Flows into the United States
## Author: Jason McGrath : University College Dublin 

# 📘 Overview
This repository contains the research materials, analysis scripts, and supporting documentation for my MSc Economics and Data Analytics thesis:

“_The Causal Effect of the 2017 Honduran Election Crisis on Human Trafficking Flows into the United States: Evidence from Synthetic Control_.”

The study investigates whether political instability in Honduras following the 2017 presidential election crisis had a causal impact on human trafficking flows into the United States. Using the Synthetic Control Method (SCM), I constructed a counterfactual Honduras based on a donor pool of Latin American countries to isolate potential causal effects.

# 🧠 Research Summary
+ Objective: Estimate whether the 2017 Honduran election crisis increased human trafficking victims detected in the U.S.
+ Methodology:
  + Synthetic Control Method (Abadie et al., 2010)
  + Donor pool: El Salvador, Guatemala, Nicaragua, Dominican Republic, Colombia, Ecuador, and Paraguay
  + Covariates: GDP per capita, unemployment rate, homicide rate, political stability index, net migration rate
  + Robustness tests: placebo-in-space, leave-one-out analysis, and donor data backfilling
+ Key Finding:
The results show a temporary divergence between Honduras and its synthetic counterpart during 2017–2019 that dissipates by 2020.
Randomisation inference and robustness checks indicate no statistically significant persistent causal effect of the 2017 election crisis on trafficking flows.

# 📊 Data Sources
+ UNODC Global Report on Trafficking in Persons (2005–2022)

+ World Bank World Development Indicators (WDI)

+ U.S. Trafficking in Persons (TIP) Reports (2022–2023)

+ International Labour Organization (ILO)

+ UN Population Division World Urbanization Prospects

# 📂 Repository Structure
```
📁 thesis-honduras-trafficking/
│
├──  README.md                # Project documentation 
├──  thesis_summary.pdf       # Executive summary or published version
├──  data/                    # Raw and cleaned data files
├──  scripts/                 # R scripts for SCM, preprocessing, and visualizations
├──  references/              # Citation materials
└──  results/                 # Model 

```

# 📈 Results Summary
+ Honduras showed an increase of ~135 trafficking victims per year post-2017, but these effects were statistically insignificant.

+ No evidence of a persistent causal impact of political instability on trafficking flows.

+ Findings emphasize data reliability challenges and the need for improved international reporting before drawing strong causal inferences.

# 🧩 Limitations
+ Limited pre-treatment years constrain counterfactual precision.

+ Potential underreporting and reporting discontinuities post-2017.

+ Donor pool dependency (Guatemala as sole optimal donor).

# 🏁 Conclusion
While the analysis does not confirm a significant causal relationship between the 2017 Honduran election crisis and U.S. trafficking flows, it contributes to the growing field of causal inference in illicit markets and highlights data and methodological challenges in human trafficking research.













