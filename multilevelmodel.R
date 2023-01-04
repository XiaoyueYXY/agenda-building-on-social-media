library(lme4)
library(lmerTest) # to get p value
library(MuMIn) # to get r square
library(readr)
library(sjPlot) # to plot interactions

final_data <- read_csv("final_data_1.csv")

# REML=FALSE if want to use MLE
fm1 <- lmer(attention_media ~ lag_attention_media + attention_organization*newsworthiness + lag_attention_organization*newsworthiness + (1|topic) + (1|Date), final_data)
summary(fm1)
r.squaredGLMM(fm1)
performance::icc(fm1, by_group = TRUE)
plot_model(fm1, type = "pred", terms = c("lag_attention_organization", "newsworthiness"))

fm2 <- lmer(attention_media ~ lag_attention_media + attention_organization + lag_attention_organization + controversy*attention_organization + scope*attention_organization + positive_consequences*attention_organization + negative_consequences*attention_organization + elite_persons*attention_organization + controversy*lag_attention_organization + scope*lag_attention_organization + positive_consequences*lag_attention_organization + negative_consequences*lag_attention_organization + elite_persons*lag_attention_organization + (1|topic) + (1|Date), final_data)
summary(fm2)
r.squaredGLMM(fm2)
performance::icc(fm2, by_group = TRUE)

plot_model(fm2, type = "pred", terms = c("lag_attention_organization", "controversy"))
plot_model(fm2, type = "pred", terms = c("lag_attention_organization", "scope"))
plot_model(fm2, type = "pred", terms = c("lag_attention_organization", "positive_consequences"))
plot_model(fm2, type = "pred", terms = c("lag_attention_organization", "negative_consequences"))
plot_model(fm2, type = "pred", terms = c("lag_attention_organization", "elite_persons"))

#get rid of the impact of positive_consequence
final_data$newsworthiness2 = rowSums(final_data[,c("controversy", "scope", "negative_consequences", "elite_persons")])

fm3 <- lmer(attention_media ~ lag_attention_media + attention_organization*newsworthiness2 + lag_attention_organization*newsworthiness2 + (1|topic) + (1|Date), final_data)
summary(fm3)
r.squaredGLMM(fm3)
performance::icc(fm3, by_group = TRUE)
plot_model(fm3, type = "pred", terms = c("lag_attention_organization", "newsworthiness2"))

# explore the reversed relationship
fm4 <- lmer(attention_organization ~ lag_attention_organization + attention_media*newsworthiness + lag_attention_media*newsworthiness + (1|topic) + (1|Date), final_data)
summary(fm4)
r.squaredGLMM(fm4)

fm5 <- lmer(attention_organization ~ lag_attention_organization + attention_media*newsworthiness2 + lag_attention_media*newsworthiness2 + (1|topic) + (1|Date), final_data)
summary(fm5)
r.squaredGLMM(fm5)

