#install.package("tidyverse")
library(tidyverse)
#####Tibble
####tibbles aee just faster then dataframes and print less numbers when
##you call the data

######Package readr

#######1) readr::read_csv

#########10 times faster than base R
###produce tibbles, dont munge the column or add the row names, dont 
##convert charcater to factors

read_csv("a,b,c
1,2,3
4,5,6") #######can be used to read csv file or to create inline csv file
read_csv("The first line of metadata
  The second line of metadata
         x,y,z
         1,2,3", skip = 2)
##########use \n to add new lines
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))
read_csv("a,b,c\n1,2,3\n4,5,6")

#############2) readr::parsing 
#####parses the data as integer and categorizes the na string
x<-parse_integer(c("1", "2123", "-", "456"), na = "-")
x
#####parsing through various decimal systems
parse_number("$123,456,789")###in US
##in europe
parse_number("123.456.789", locale = locale(grouping_mark = "."))
####if you have texts in front of your number
parse_number("It cost $123.45")
###date and time
parse_datetime("09/24/2018","%m/%d/%Y")
parse_datetime("2010/01/01 12:00 -0600", "%Y/%m/%d %H:%M %z")

###############
#################Tidy data#########################
#######package tidyr#######
##tidyr::spread
##inbuilt tables in tidyverse
table2
table2.clean<- table2 %>% 
  spread(key="type", value="count")
table2.clean

###tidyr::gather
table4a
table4a.clean<-table4a %>% 
  gather("1999","2000", key="year", value="population")
table4a.clean
##########tidyr::seperate- pulls apart columns seperated by /
table3
table3.clean<-table3 %>% 
  separate(rate, into = c("cases", "population"))
table3.clean



###########transforming data#############
#################dplyr############
##data
who<- tidyr::who
who
###1st three columns ountry
####4th column year
###rest all columns look like values
#######lets gather the values
who1 <- who %>% 
  gather(new_sp_m014:newrel_f65, key = "variable", value = "number", na.rm = TRUE)
who1
#######dissect the variable
###new_Sp_m014
###1st part= case is new or old
###2nd part= type of TB
##3rd part =gender
###4th= age
who2 <- who1 %>% 
  mutate(variable = stringr::str_replace(variable, "newrel", "new_rel"))
who2 #####to make variable names consistent, newrel  to new_rel
####first three columns are the same- so lets just keep 1
####
library(tidyr)
who3 <- who2 %>% 
  separate(variable , c("new", "type", "sexage"), sep = "_")
who3
########lets seperate age and sex
who3<- who3 %>% 
  separate(sexage, c("sex", "age"), sep=1)
who3
########lets pick only one version for a country using dplyr
who3<-who3 %>% 
  select(country, year, new, type, sex, age, number)
who3
########lets select only years 1997:2000 and only males
who.males.2000<- who3 %>% 
  filter(sex=="m" & year< 2000)
who.males.2000
#####################
##########################
################################################mutating

diam<-ggplot2::diamonds
diam
diam<- diam %>% 
  select(carat, cut, depth, table, price) %>% ###select specific colum
mutate(carat.perc = carat*100) %>% 
  filter(cut == c("Ideal", "Premium", "Good"))  
  diam
  
  ##########Joins
install.packages("nycflights13")
library(nycflights13)
ap<- nycflights13::flights
planes<- nycflights13::planes
weather<-nycflights13::weather
ap<- ap %>% 
  select(year,sched_dep_time,tailnum, origin,dest)
planes<-planes %>% 
  select(tailnum, year, model, type)

########lets combine airport  with #tailnum as it is the primary key 
##in both dataasets
#intersect(x, y): return only observations in both x and y.
#union(x, y): return unique observations in x and y.
#setdiff(x, y): return observations in x, but not in y.
flights2<- full_join(ap,planes, "tailnum")
