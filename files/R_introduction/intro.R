#' A brief introduction to R
#' -------------------------------
#' see also:
#' http://cran.r-project.org/doc/contrib/Baggott-refcard-v2.pdf
#+

#' #### Assignment operator "<-"
x <- c(1,2,3,4,5,6,7)
x
x <- c(1:7)
x
x <- 1:7
x

#' #### R as calculator
5 + (6 + 7) * pi^2
log(exp(1))
log(1000, 10)
sin(pi/3)^2 + cos(pi/3)^2

log2(32)
sqrt(2)
seq(0, 5, length=6)
2^seq(0, 5, length=6)

#' #### Basic data types
#' Logical
x <- T
y <- F
x
y

#' logical operators
x & y
x | y
!x
c(T,F,T,F) && c(T,T,F,F)
c(T,F,T,F) || c(T,T,F,F)

c(T,F,T,F) | c(T,T,F,F)
c(T,F,T,F) & c(T,T,F,F)

#' Numerical
a <- 5
b <- sqrt(2)
a
b

a == 5
a < 5
a <= 5

#' Character
a <- "1"
b <- 1
a
b

a <- "character"
b <- "a"
c <- a

a
b
c

letters
a %in% letters
"a" %in% letters

#' factor
fac <- c("small","small","medium","tall","huge","huge","small","tiny")
fac
fac <- as.factor(fac)
levels <- c("small", "medium", "huge")
ordFac <- factor(sample(levels,10, replace=T), levels=levels, ordered=T)
ordFac

#' Vector
x <- c(5.2, 1.7, 6.3) 
log(x) 
y <- 1:5
z <- seq(from=1, to=1.4, by = 0.1)
y + z

length(y)
mean(y + z)


#' Matrix
m <- matrix(1:12, 4, byrow = T)
m 
y <- -1:2
m.new <- m + y
m.new
t(m.new)
m.new

m/m

dim(m)
dim(t(m.new))

#' missing values
x <- c(1, 2, 3, NA)
x + 3

#' "NaN", +/- Inf
log(c(0, 1, 2))
0/0

#' #### Subsetting
x <- c("a", "b", "c", "d", "e", "f", "g", "h")
x <- letters[1:8]
x[1]
x[3:5]
x[-(3:5)]
x[c(T, F, T, F, T, F, T, F)]
x[x <= "d"]
m[,2]
m[3,]

#' Lists are very flexible
Empl <- list(employee="Anna", husband="Fred", children=3, child.ages=c(4,7,9))
str(Empl)
Empl[[4]]
Empl$child.a
Empl[4]   #' a sublist consisting of the 4th component of Empl
names(Empl) <- letters[1:4]
Empl <- c(Empl, service=8)
unlist(Empl)  #' converts it to a vector. Mixed types will be converted to character, giving a character vector.

#' with matrices
x.mat <- matrix(c(3, -1, 2, 2, 0, 3), ncol = 2)
x.mat	   
dimnames(x.mat) <- list(c("L1","L2","L3"), c("R1","R2"))
x.mat

#' subsetting
cw <- chickwts
?chickwts

#' Let's look at it:
str(cw)
summary(cw)
summary(cw$weight)
cw[3,2]
View(cw)
#' Labels in data frames
labels(cw)
#' you can edit the data using fix:
fix(cw)
#' but this is not a good idea! better edit manually:
x <- which(cw$weight==136)
cw[x,"weight"] <- 140


#' #### plots in R:
plot(fac)
plot(ordFac)
pie(table(fac))

boxplot(weight~feed,cw)
pie(table(cw$feed))

plot(sin(seq(0, 2*pi, length=100)))
plot(sin(seq(0, 2*pi, length=100)), type="l")

#' Histogram:
par(mfrow=c(1,2))   #' set up multiple plots
simdata <- rchisq(100,8)
hist(simdata)  #' default number of bins
hist(simdata, breaks=2)  #' etc,4,20

#' Scatterplot
par(mfrow=c(1,1))
z1 <- rnorm(50)
z2 <- rnorm(50)
rho <- .75         #' (or any number between -1 and 1)
x2 <- rho*z1+sqrt(1-rho^2)*z2
plot(z1,x2)

#' #### Control structures and functions
#' Grouped expressions in R
x = 1:9
if(length(x) <= 10) {
   x <- c(x,10:20)
	 print(x) 
} else {
	print(x[1])
}

#' Loops in R
for(i in 1:length(x)) {
    x[i] <- rnorm(1)
}
x

j = 1
while(j < 10) {
  print(j)
  j <- j + 2 
}

#' #### distributions
#' start with the letters "d" for density, "p" for cumulative dsitribution 
#' function, "q" for quantiles or "r" fro random numbers

curve(dnorm,-3,3)
curve(dunif,-1,2)
plot(dpois(1:10,4), type="h", ylab="density", xlab="value")
points(dpois(1:10,4), type="p")

hist(rexp(100))
hist(rexp(10000))
boxplot(rexp(100))

hist(rnorm(100))
hist(rnorm(10000))

plot.ecdf(rnorm(100))
curve(pnorm, col="red",add=T)


#' #### Functions:
add <- function(a,b) { 
  result = a+b
  return(result) 
}
add(2,5)

#' General Form of Functions
#' function(arguments) {
#'   expression
#' }

larger <- function(x,y) {
  if(any(x < 0)) return(NA)
  y.is.bigger <- y > x
  x[y.is.bigger] <- y[y.is.bigger]
  x
}
larger(2,5)

#' #### getting help:
#' If you are in doubt...
help(predict)
?predict
#' or press "F1" when the cursor is "in" the function's name

#' get some delivered data
data(cars)
plot(cars)
str(cars)

carLm <- lm(dist~speed, cars)
cars$fit <- predict(carLm, cars)
signif(cars$fit,2)

plot(dist~speed,cars)

plot(cars$speed, cars$dist, xlab="Speed (mph)", ylab = "Stopping distance (ft)", las = 1)
points(cars$speed, cars$fit, type="l", col="blue")
legend("topleft",c("obs.","modelled"),pch=c(1,NA),lty=c(NA,1),col=c("black","blue"))

x1 <- rnorm(100)
y1 <- rnorm(100)
t.test(x1, y1, var.equal=F, conf.level=.99)
t.test(var.equal=F, conf.level=.99, x1, y1)

#' #### "interactive" plots
x <- 1:10
y <- 2*x + rnorm(10,0,1)
plot(x,y,type="p") #' Try also l,b,s,o,h,n
  #' axes=T, F
  #'  xlab="age", ylab="weight"
  #' sub="sub title", main="main title"
  #' xlim=c(0,12), ylim=c(-1,12)

loc <- locator(x, type="p") 
text(loc$x, loc$y, "Hey")
identify(x, y, labels = LETTERS[x]) 

#' Plots for Multivariate Data
x <- 1:20/20
y <- 1:20/20
z <- outer(x,y,function(a,b){cos(10*a*b)/(1+a*b^2)})
contour(x,y,z)
persp(x,y,z)
image(x,y,z)

#' #### get extra packages from CRAN or r-forge
#' install.packages("rgl")
#' install.packages("copula")
#' install.packages("evd")
#' install.packages("spcopula", repos="http://R-Forge.R-project.org")

#' peak, duration and volume triples
#' library(spcopula)
#' data("simulatedTriples")
#' write.csv(triples, file="simulatedTriples.csv", row.names=F)
triples <- read.csv("simulatedTriples.csv")

#'#### GL for r
library(rgl)
#' find demos:
demo(package="rgl")
demo(abundance)
demo(envmap)
demo(lollipop3d)

plot(triples)
plot3d(triples)

#' #### small worked example
#' fit margins
library(evd)
gevFit <- fgev(triples[,1])$estimate
dgevFun <- function(x) dgev(x, gevFit[1], gevFit[2], gevFit[3])

#' loglik
sum(log(dgevFun(triples[,1]))) #' -2682

#' fit a log-normal
optFunLogNorm <- function(param) {
  -sum(log(dlnorm(triples[,1], param[1], param[2])))
}

lnormFit <- optim(c(1,1), optFunLogNorm)$par

dlnormFun <- function(x) dlnorm(x, lnormFit[1], lnormFit[2])

#' loglik
sum(log(dlnormFun(triples[,1]))) #' -2730

hist(triples[,1],freq=F,n=20, ylim=c(0,0.012),xlim=c(-50,500))
curve(dgevFun, add=T, col="red")
curve(dlnormFun ,add=T, col="blue")

#'#' qq-plots
qqplot(qgev(ppoints(500), gevFit[1], gevFit[2], gevFit[3]), triples[,1])
qqline(triples[,1], 
       distribution=function(x) qgev(x, gevFit[1], gevFit[2], gevFit[3]))

qqplot(qlnorm(ppoints(500), lnormFit[1], lnormFit[2]), triples[,1])
qqline(triples[,1], 
       distribution=function(x) qlnorm(x, lnormFit[1], lnormFit[2]))

#' assessing dependence
cor(triples)
cor(triples, method="kendall")
cor(triples, method="spearman")

#' striping margins
rtTriples <- apply(triples[,c(1,3)],2,function(x) rank(x)/(nrow(triples)+1))
plot(rtTriples, asp=1)

library(copula)
copFit <- fitCopula(claytonCopula(1),rtTriples,method="ml")
persp(copFit@copula,dCopula,zlim=c(0,20))

#' #### Working with spatial data
library(sp)

data(meuse)
str(meuse)

coordinates(meuse) <- ~x+y
str(meuse)

meuse[1,]
meuse[,"zinc"]
meuse@data$zinc
meuse@data$soil

#' plot this data:
plot(meuse)
spplot(meuse)
spplot(meuse,"zinc", col.regions=bpy.colors())

spDists(meuse[1:10,])