##random population
pop<-(rnorm(1000))
head(pop)
######we want to derive the sample mean of random samples, n=1,2,3,4....
##i.e pick n individuals and take their mean
n<-1:1000
###sample mean 
################
####################method 1, the regular for loop way
m1 <- rep(NA, length(n))
for (i in n) {
  x <- sample(pop, i)
  m1[i] <- mean(x)
}
plot(m1, type='l')

##########method 2 the'purrrr way'
#########purr::map() functions do what loops do but in an abstract way
#######less issues than loops
##########cleaner code
pop<- (rnorm(1000))
n<-1:1000


####map_df creates dataframe
######## .x is the list of atomic vector or output
######### .f is the fomrula
##########purr takes function and applies it to data
##map(.x,.f)
m2 <- map(n, ~ sample(pop, .x)) %>% ###our data
  map_df(~ data.frame(mean = mean(.x), sd = sd(.x)),.id = "n") ##applying function
m2
#######bringing back diamonds
diam
##assuming price would depend on carat, depth, cut and table
######building linear models for the predictions
#######one way to do this
m1<- lm(price~carat, data=diam)
m2<- lm(price~table, data=diam)
m3<- lm(price~cut, data=diam)
m4<- lm(price~depth, data=diam)
##############
#######
summary(m1)
summary(m2)
summary(m3)
summary(m4)
################compare models
AIC(m1,m2,m3,m4)
#########################Very tedious###############
#################Lets do Purrr###########################
diam<-diamonds
formulas<- list(price~carat, price~table, price~depth) ##create the list of models
model<- formulas %>%  ##bring out the list
  map(~lm(.x, data=diam)) %>%  ##function
  map(~ coef(.x)) %>%  ##coeffincients
  map_df(~ as.data.frame(t(.x))) ##arranging them as a table
model
  
  
