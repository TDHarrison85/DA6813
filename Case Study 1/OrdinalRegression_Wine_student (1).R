### Here, we will model an ordinal logistic regression model.

# We will use the ordinal package to run the orginal regression.
# This package provides you with p-values of all estimates.
# MASS is an alternative package that can perform ordinal reg that provides additional output. 
#install.packages("ordinal")
#install.packages("MASS")

# Load the libraries
library(ordinal)
library(MASS)

# Load the data
data(wine)

# Let's look at the data
w=wine
str(w)


# Here, our dependent variable is "Rating", which is an ordered factor. 
# If you ever have a ordinal response that is not a ordered factor, 
# you can convert it, since the "clm - cumulative link model" function that we will use from 
# the ordinal package requires an ordinal dependent variable. 
# To convert, use for e.g. "new.variable = ordered(old.variable, levels = c(1,2,3,4,5))"
# This will create a new variable that maintains all the levels of the old variable, 
# but with the levels ordered from 1 (low) to 5 (high). 

# Notice that all the variables other than response are factor with multiple levels. 
# For now, I will use just contact and temp as predictors, both of which have 2 levels. 
# Contact has options No or Yes, and temp has options cold or warm. 

om1 = clm(rating ~ contact + temp, data = w)
summary(om1)


# The model outputs the estimates for contact and temp. Behind the scenes, clm function created 
# 2 variables, contactyes = 1 for when contact = yes, and 0 otherwise, and tempwarm = 1 for when 
# temp = warm, and 0 otherwise. Here, both contactyes and tempwarm and positively correlated to rating.

exp(coef(om1))

# Here the interpretation of the coefs are based on the ordered response. 
# For example, 1 unit change in contactyes or tempwarm (i.e. going from 0 to 1) increases
# the odds of receiving a rating 2-10 compared to a rating 1 by exp(coef(pm1)) amount. 
# Similarly, the same change increases the odds of receiving a rating 3-10 versus a rating 
# between 2 by exp(coef(pm1)) amount. These coefs are called proportional odds. 
# The proportional odds assumptions of any ordinal model states that the coefs that describe the 
# relationship between the lowest vs. all other categories of the response, is the same for 
# describing the relationship between next lowest and all higher categories of the response. 


nominal_test(om1)

# If any independent variable fails these tests (that is, a significant p-value is returned), 
# that variable can be handled differently in the model using the nominal options in the clm function.
# In this case, both contact and temp satisfies the assumption, since p-value is insignificant. 

# Alternatively, we can also use the "polr" function from the MASS package
# for ordered logit model. This function does not provide the significance tests directly. It does show 
# AIC and residual deviance for model comparisons. 

pm1 = polr(rating ~ contact +temp, w)
summary(pm1)
exp(coef(pm1))
