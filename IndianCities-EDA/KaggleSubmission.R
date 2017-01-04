---
  title: "Exploratory data analysis"
author: "Gaurav Dangi"
date: "2 January 2017"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

### Loading libraries
```{r, message=FALSE, warning=FALSE}
library(data.table)
library(ggplot2);library(plotly);library(DT);library(highcharter)
library(ggmap)
library(plyr);library(dplyr)
```

```{r, message=FALSE, warning=FALSE}
indian_cities <- fread("../input/cities_r2.csv")
attach(indian_cities)

indian_cities <- as.data.table(indian_cities)

state.wise <- indian_cities[,list(sum(population_total),sum(population_male),sum(population_female),
                                  sum(total_graduates),sum(literates_total),sum(literates_male),sum(literates_female),sum(male_graduates),sum(female_graduates)),
                            by = state_name]
state.wise <- state.wise[order(state.wise$V1,decreasing = T),]
names(state.wise) <- c("State","population_total","population_male","population_female",
                       "total_graduates","literates_total","literates_male","literates_female","male_graduates","female_graduates")

state.wise <- state.wise[order(state.wise$population_total,decreasing = T),]

options(scipen=999)

DT::datatable(state.wise)

detach(indian_cities)
attach(state.wise)
a <- ggplot(state.wise,aes(x=reorder(State,population_total),y=population_total)) + 
  geom_bar(stat = "identity",fill = "#D55E00")+
  xlab("States") + ylab("Total population") + ggtitle("State by total population")+
  coord_flip()
ggplotly()

hchart(state.wise,x=State,y=population_total,type = "column", color = State) %>%
  hc_title(text = "State by total population") %>% hc_add_theme(hc_theme_google())

hchart(state.wise,x=State,value = population_total,type = "treemap", color = population_total) %>%
  hc_title(text = "State by total population") %>% 
  hc_add_theme(hc_theme_google())
```

The one is called literate if he/she is able to read and write.

Let's see states on the basis of total literacy
```{r, message=FALSE, warning=FALSE}
hchart(state.wise,x=State,y=literates_total,type = "column",color = State) %>%
hc_title(text = "State by total literate") 
```

Maharashtra has the higghest number of total literate, but it also has higghest total population. 

```{r, message=FALSE, warning=FALSE}
state.wise$Literacy.rate <- literates_total/population_total

hchart(state.wise,x=State,y=Literacy.rate,type = "column",color = State) %>%
hc_title(text = "State by total literate") %>% hc_yAxis(text = "Literacy rate")
ggplot(state.wise,aes(x=reorder(State,Literacy.rate),y=Literacy.rate))+
geom_bar(stat = 'identity',fill = "#D55E00") + coord_flip()
```

So Kerala has the highest literacy rate, followed by Himachal Pradesh, Mizoram, Tripura, Meghalaya and Assam. I had no idea that these states has higher literacy rate than west bengal, Maharashtra and Gujarat.


### Which state has maximum number of graduates?

Now let's see graduates according to the states. There is a big difference between graduates and literates. Literates are those who can read and write whereas graduates are those who has successfully complete an academic degree, course of training

```{r, message=FALSE, warning=FALSE}
ggplot(state.wise,aes(x=reorder(State,total_graduates),y=total_graduates))+
  geom_bar(stat = 'identity',fill = "#D55E00") + coord_flip()
```

So maximum number of gradutaes are from maharashtra, followed by Uttar Pradesh and so on.

Now, what percent of population graduates from each state?

```{r, message=FALSE, warning=FALSE}
state.wise$graduate.ratio <- state.wise$total_graduates/state.wise$population_total

ggplot(state.wise,aes(x=reorder(State,graduate.ratio),y=graduate.ratio))+
  geom_bar(stat = 'identity',fill = "#D55E00") + ggtitle("Percent of graduates")+coord_flip()

hchart(state.wise,x=State,y=graduate.ratio,type = "column") %>%
  hc_title(text = "Percent of graduates")
```

So Himachal pradesh has highest percentage of graduate, followed by Manipur, Uttrakhand and so on. 
Mizoram has good percentage of literacy rate (3rd highest) but as we can see it has lowest percentage of graduate.
Beside ranking, number doesn't seems to be good. The highest percentage of graduates which is from Himachal Pradesh is 25.5%.

### Percentage of literate and graduate girls from each state
As we know girl's education is an issue in India. Now let's see which state is facing this issue most.

```{r, message=FALSE, warning=FALSE}
hchart(state.wise,x=State,y=female.literate,type = "column",color = State) %>%
hc_title(text="Percentage of women litracy")

ggplot(state.wise,aes(x=reorder(State,female_graduates.ratio),y=female_graduates.ratio,fill=factor(State)))+
geom_bar(stat = 'identity') + 
ggtitle("Percentage of graduate (female)") + xlab("States")+ylab("Percentage") +
coord_flip()

```

So, as a result, Mizoram and Bihar followed by nagaland has least graduate females, even less than 10%. 
This implies that less than 10% of girls/females are graduate from Mizoram, Bihar and Nagaland.

```{r, message=FALSE, warning=FALSE}

```