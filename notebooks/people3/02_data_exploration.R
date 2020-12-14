library(tidyverse)
library(dplyr)
library(plotly)
library(ggplot2)

dav_race_only_est %>% 
  plot_ly(x = ~race, y = ~Hisp, type = 'bar', name = 'Hispanic or Latinx') %>% 
  add_trace(y = ~nonHisp, name = 'Non-Hispanic or Latinx') %>% 
  layout(yaxis = list(title = 'Count'), barmode = 'group')

p <- dav_race_only_est %>% 
  filter(race != 'total') %>% 
  ggplot(aes(x = race, y = estimate, fill = ethnicity)) +
  geom_col()

ggplotly(p)

#
dav_lang_only_est %>% 
  slice(-1) %>% 
  filter(str_detect(language, 'Engless', negate = TRUE)) %>% 
  filter(language != 'langTotal') %>% 
  plot_ly(labels = ~language, values = ~estimate) %>% 
  add_pie(hole = 0.6)
