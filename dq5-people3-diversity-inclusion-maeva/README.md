## Data Question 5: People3

People3 is a benefit corporation that provides diversity and inclusion training, workshops, and inclusion-centered consulting. Benefit corporations are corporate entities which commit to creating public benefits and sustainable value in addition to generating profit. In this project, you will be working toward people3's goal of helping people navigate people differences.

The deliverable for this project is an app built with R Shiny that can be used to help companies see how their employee makeup compares to the broader demographics of their geographic region and can illuminate areas where outreach or improved efforts could be beneficial.

**Part 1:** Start by exploring what data is available through the [US Census](https://www.census.gov/programs-surveys/ces/data/restricted-use-data/demographic-data.html). You might consider using the [*censusapi*](https://github.com/hrecht/censusapi) or [*tidycensus*](https://walker-data.com/tidycensus/index.html) R libraries to help retrieve the needed data in a usable format. You should focus on finding data that can be used to understand the demographic makeup of a region, including ethnicity, race, gender, age, and level of education.

It is recommended that you begin by working with data from Davidson County and/or the Nashville-Davidson--Murfreesboro Combined Statistical Area, but your final product should include other major metropolitan areas. You can include Memphis, Chattanooga, or Knoxville, or you could include some other large metropolitan areas in the Southeast.

**Part 2:** Build an app using R Shiny. This app should allow the user to upload a data file containing counts by race/age/education/sex. See the example file (https://docs.google.com/spreadsheets/d/132TpF5-hLoFxaKbIAkIgLA62P2263gOKY5kYiSd33-8/edit?usp=sharing) to see the expected format for the input. The app should then provide information as to the demographic makeup of the uploaded data compared to the makeup of a selected geographic region.

Apps demonstrations will be done on December 17.