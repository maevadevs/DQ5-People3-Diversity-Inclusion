library(tidyverse)
library(dplyr)
library(plotly)
library(ggplot2)

# not successful
#dav_race_only_est %>% 
#  plot_ly(x = ~race, y = ~Hisp, type = 'bar', name = 'Hispanic or Latinx') %>% 
#  add_trace(y = ~nonHisp, name = 'Non-Hispanic or Latinx') %>% 
#  layout(yaxis = list(title = 'Count'), barmode = 'group')

# bar chart for race variables
p <- dav_race_only_est %>% 
  filter(race != 'total') %>% 
  ggplot(aes(x = reorder(race, -estimate), y = estimate, fill = ethnicity)) +
  geom_col()

ggplotly(p)

# Donut chart for languages spoken at home; 
# Highlights % who speak English and top 5 other non-English languages
dav_lang_only_est %>% 
  slice(-1) %>% 
  filter(str_detect(language, 'Engless', negate = TRUE)) %>% 
  filter(language != 'langTotal') %>% 
  head(n = 6) %>% 
  plot_ly(labels = ~language, values = ~estimate) %>% 
  add_pie(hole = 0.5)

# Bar chart for languages spoken at home
ex2 <- dav_lang_only_est %>% 
  slice(-1) %>% 
  filter(str_detect(language, 'Engless', negate = TRUE)) %>% 
  filter(language != 'langTotal') %>%
  ggplot(aes(x = reorder(language, -estimate), y = estimate, fill = language)) +
  geom_bar(stat = 'identity') +
  scale_fill_brewer(palette="Dark2") + 
  theme_minimal()

ggplotly(ex2)
