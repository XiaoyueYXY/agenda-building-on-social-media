#library(dplyr)
library(lme4)
library(lmerTest) # to get p value
library(MuMIn) # to get r square
library(readr)
library(sjPlot) # to plot interactions
library(car) # For VIF calculation

final_data <- read_csv("final_data.csv")

# Add daily_corp_tweets and daily_media_tweets columns
#daily_totals <- final_data %>%
#  group_by(Date) %>%
#  summarize(
#    daily_corp_tweets = sum(attention_organization, na.rm = TRUE),
#    daily_media_tweets = sum(attention_media, na.rm = TRUE)
#  )


# Merge back with the original data
#final_data <- final_data %>%
#  left_join(daily_totals, by = "Date")


# REML=FALSE if want to use MLE
# Model 1: Test only main effects for RQ1
# Multicollinearity check
# Extract the fixed-effects design matrix
# Common threshold for VIF is 5
fixed_effects_model <- lm(attention_media ~ lag_attention_media + attention_organization + lag_attention_organization,
                          data = final_data)
# Calculate VIF
vif_values <- vif(fixed_effects_model)
print(vif_values)


fm1<- lmer(attention_media ~ lag_attention_media + attention_organization + lag_attention_organization + (1|topic) + (1|Date), final_data)
summary(fm1)
r.squaredGLMM(fm1)
performance::icc(fm1, by_group = TRUE)



# Model 2: Test the interaction effect of news factors for H1
fixed_effects_model <- lm(attention_media ~ lag_attention_media + attention_organization + lag_attention_organization + 
                            surprise*attention_organization + controversy*attention_organization + scope*attention_organization + positive_consequences*attention_organization + negative_consequences*attention_organization + elite_persons*attention_organization +
                            surprise*lag_attention_organization + controversy*lag_attention_organization + scope*lag_attention_organization + positive_consequences*lag_attention_organization + negative_consequences*lag_attention_organization + elite_persons*lag_attention_organization + 
                            surprise + controversy + scope + positive_consequences + negative_consequences + elite_persons,
                          data = final_data)
# Calculate VIF
vif_values <- vif(fixed_effects_model)
print(vif_values)

fm2 <- lmer(attention_media ~ lag_attention_media + attention_organization + lag_attention_organization + 
              surprise*attention_organization + controversy*attention_organization + scope*attention_organization + positive_consequences*attention_organization + negative_consequences*attention_organization + elite_persons*attention_organization +
              surprise*lag_attention_organization + controversy*lag_attention_organization + scope*lag_attention_organization + positive_consequences*lag_attention_organization + negative_consequences*lag_attention_organization + elite_persons*lag_attention_organization + 
              surprise + controversy + scope + positive_consequences + negative_consequences + elite_persons +
              (1|topic) + (1|Date), final_data)
summary(fm2)
r.squaredGLMM(fm2)
performance::icc(fm2, by_group = TRUE)

plot_model(fm2, type = "pred", terms = c("lag_attention_organization", "controversy"))
plot_model(fm2, type = "pred", terms = c("lag_attention_organization", "scope"))
plot_model(fm2, type = "pred", terms = c("lag_attention_organization", "negative_consequences"))


# Model 3: Test the interaction effect of newsworthiness for H2
fixed_effects_model <- lm(attention_media ~ lag_attention_media + attention_organization + lag_attention_organization + 
                            attention_organization*newsworthiness + lag_attention_organization*newsworthiness,
                          data = final_data)
# Calculate VIF
vif_values <- vif(fixed_effects_model)
print(vif_values)


fm3 <- lmer(attention_media ~ lag_attention_media + attention_organization + lag_attention_organization + attention_organization*newsworthiness + lag_attention_organization*newsworthiness + (1|topic) + (1|Date), final_data)
summary(fm3)
r.squaredGLMM(fm3)
performance::icc(fm3, by_group = TRUE)
plot_model(
  fm3,
  type = "pred",
  terms = c("lag_attention_organization", "newsworthiness"),
  title = "",  # Remove the figure title
  axis.title = c("Lagged Attention Corporate Organization", "News Organization Attention"),  # Rename x and y axes
  legend.title = "Newsworthiness"  # Name the legend
)



