#This script preprocesses the data set with Washington State elementary school
#racial and economic demographic information along with test scores. It
#uses this information to build a logistic regression model to predict test
#scores for each school, then calculates the Student Independent Performance
#metric.

#Developed by Joseph Scheidt

library(tidyverse)
library(ggplot2)

#Read in data
elem <- read_csv("elementary_schools.csv")

#Select relevant variables
el <- elem %>%
    select("Rank (of 1062 )", "School_a", "Grades", "District", "# Students_a",
           "Student/ Teacher Ratio_a", "Rank ( 2017 )", "Rank Change From 2017",
           "Fulltime Teachers", "Free/Disc Lunch Recipients_a",
           "Average Standard Score ( 2018 )", "White", "Black", "Hispanic",
           "Asian", "American Indian", "Pacific Islander",
           "Two or More Races")

#Rename variables
names(el) <- c("rank", "school", "grades", "district", "number_of_students",
               "student_teacher_ratio", "2017_rank", "rank_change", 
               "fulltime_teachers", "free_disc_lunch", "avg_test_score", 
               "white", "black", "hispanic", "asian", "american_indian", 
               "pacific_islander", "biracial")

#Replace NAs in the data with 0 (this is the actual meaning of NA in the data)
el = el %>%
    replace_na(list(white = 0, black = 0, hispanic = 0, asian = 0,
                    american_indian = 0, pacific_islander = 0,
                    biracial = 0))

# Transform existing value representations to extract percentages only
for (j in 10:ncol(el)) {
    for (i in 1:nrow(el)) {
        el[i,j] = gsub(" %.*$", "", el[i,j])
        el[i,j] = gsub("^.*\\(", "", el[i,j])
    }
}

# Convert percentage values to actual proportional values (ie between 0 and 1)
el$free_disc_lunch = as.numeric(el$free_disc_lunch) / 100
el$white = as.numeric(el$white) / 100
el$black = as.numeric(el$black) / 100
el$hispanic = as.numeric(el$hispanic) / 100
el$asian = as.numeric(el$asian) / 100
el$american_indian = as.numeric(el$american_indian) / 100
el$pacific_islander = as.numeric(el$pacific_islander) / 100
el$biracial = as.numeric(el$biracial) / 100
el$avg_test_score = as.numeric(el$avg_test_score) / 100

# Build logit regression model, using free/discounted lunch as a proxy for
# poverty and white plus asian percentages to control for racial performance
# gaps
model <- glm(formula = avg_test_score ~ free_disc_lunch + 
                 white + asian, 
             family = quasibinomial(link = "logit"), data = el)

#Check model - all features included have vanishingly small p-values, as
#expected
summary(model)
plot(model)

#Predict test score for each school based on student demographics
el <- el %>%
    mutate(expected_test_score = predict(model, el, type = "response"))

#Plot average vs expected test scores. R squared is about 0.62.
ggplot(el, aes(x = expected_test_score, y = avg_test_score)) +
    geom_point() +
    geom_smooth(method = "lm")
    
#Change district names to match those in shapefile
el$district <- gsub("Columbia \\(Walla Walla\\) School District",
                    "Columbia School District \\(Walla Walla\\)", el$district)
el$district <- gsub("Fife School District",
                    "Fife Public Schools", el$district)
el$district <- gsub("Kiona-Benton City School District",
                    "Kiona-Benton School District", el$district)
el$district <- gsub("Longview School District",
                    "Longview Public Schools", el$district)
el$district <- gsub("Mary M Knight School District",
                    "Mary M. Knight School District", el$district)
el$district <- gsub("Seattle Public Schools",
                    "Seattle School District", el$district)
el$district <- gsub("Spokane School District",
                    "Spokane Public Schools", el$district)
el$district <- gsub("Tacoma School District",
                    "Tacoma Public Schools", el$district)
el$district <- gsub("Vancouver School District",
                    "Vancouver Public Schools", el$district)
el$district <- gsub("Walla Walla Public Schools",
                    "Walla Walla School District", el$district)
el$district <- gsub("Yelm School District",
                    "Yelm Community Schools", el$district)

#Write results to csv file
write_csv(el, path = "WA_elementary_SIP.csv")

