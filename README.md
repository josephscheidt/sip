# Student Independent Performance

Student Independent Performance attempts to evaluate the performance of a school based on its standardized test scores independent of the demographic makeup of that school.

You can explore the data visually through a Tableau Public dashboard at

https://public.tableau.com/views/ElementarySchools_15519521744010/WashingtonElementarySchools?:embed=y&:display_count=yes

Or see a table of the summary data per school at

https://public.tableau.com/profile/joseph.scheidt#!/vizhome/ElementarySchools_15519521744010/WADataTable

## Details

When evaluating the performance of various public schools and trying to compare them, good metrics are scarce. One of the few to allow a real basis for comparison is standardized test scores. Unfortunately, it has been shown that the two main contributors to student test scores are race and economic status, two factors entirely unrelated to school quality and outside of the school's control.

To combat this inadequacy, I developed a metric called Student Independent Performance, which attempts to measure a school's performance through standardized test scores after controlling for the demographic makeup of the children who attend. Specifically, Student Independent Performance is calculated by taking the difference between a schools standardized test score and a predicted standardized test score given the percentage of poor students and percentage of underpriveleged races.

The predicted standardized test score is caluclated using a logistic regression with test score as the dependent variable and free/reduced student lunch percentage, white percentage, and Asian percentage as the independent variables. Free/reduced student lunch is a common proxy indicator for poverty, and the major racial gap for standardized test performance exists between combined white and Asian students and everyone else.

Currently in this repository are the data involved in calculating SIP for Washington State elementary schools, along with code used to scrape the data from the internet (in Python) and code used to process the data set and calculate SIP (in R). I could have done the first in R (with rvest and rselenium) or the second in Python (with pandas) but I specifically wanted to demonstrate my ability to work with either language.

The data come from www.schooldigger.net, which is sourced from the National Center for Education Statistics, U.S. Department of Education, the U.S. Census Bureau, the Washington State Department of Health and the Washington Office of Superindentent of Public Instruction. 

This simple measure was inspired by baseball's FIP (Fielding Independent Pitching) statistic, which evaluates pitchers based on only what is almost entirely within the pitchers control: walks, strikeouts, and home runs.
