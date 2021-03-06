## Inverse transform sampling
#Muzhou Liang
## Generate samples of a continuous dist
## Uniform to Exponential
Nsim = 10^4; lambda = 1
#generate a vector of uniform numbers.
U = runif(Nsim)
#we've already found the CDF for exp(lambda), set it equal to u, 
#and solved for x.
#X is our vector of exp(lambda) numbers generated by the Inv CDF method
X = -log(U) / lambda
#Y is just for comparison - hopefully X is distributed the same as Y.
Y = rexp(Nsim, rate = lambda)
par(mfrow = c(1,2))
hist(X, freq=FALSE, main="Exp from Uniform")
curve(dexp(x), col = "red", add = TRUE)
hist(Y, freq=FALSE, main="Exp from R")
curve(dexp(x), col = "red", add = TRUE)

## Uniform to Normal
## Box-Muller algorithm, an accurate normal generator
Nsim = 10^4
#generate two sets of independent uniform numbers
U1 = runif(Nsim)
U2 = runif(Nsim)
#X1 and X2 use both uniform numbers to make 2 normally distributed numbers.
X1 = sqrt(-2*log(U1)) * cos(2*pi*U2)
X2 = sqrt(-2*log(U1)) * sin(2*pi*U2)
par(mfrow = c(1,2))
hist(X1, freq=F)
curve(dnorm(x), col = 'red', add = T)
hist(X2, freq=F)
curve(dnorm(x), col = 'red', add = T)
#Note how well the histogram fits the normal curve (in red).

#Remember that the basic idea of the Inverse CDF sampler for continuous
#distributions is that any point from 0-1 can be translated to a point
#in the support of a probability distribution via the CDF. 
#The below plot illustrates how this works for the N(0,1) distribution:
par(mfrow = c(1,1))
curve(pnorm(x), -4, 4, col='red', lwd=2, ylab='u')
u = runif(1); abline(h=u, v=qnorm(u), lty=2) 
#repeat these 2 lines a few times, see how each point translates.

## Genrate samples of a discrete dist - very analagous
## Uniform to Poisson (when lambda is large)
#This is the version of Inverse CDF Sampling for a discrete distr.
Nsim = 10^4; 
#remember that in the Poisson distribution, mean = variance = lambda
lambda = 100
spread = 3*sqrt(lambda) # sd = sqrt(lambda)
#t is a sequence of possible values from this distribution
#that are within 3 sd of the mean. It's truncated at 0.
t = round(seq(
  max(0,lambda-spread),
  lambda+spread,1
  ))
prob = ppois(t, lambda) #the probability of each point
par(mfrow = c(1,1))
plot(t, prob, pch=16, cex=0.5)
X = rep(0,Nsim)
for (i in 1:Nsim){
  u = runif(1) #generate a uniform number
  X[i] = t[1] + sum(prob<u) #which point on t corresponds with that probability?
}
par(mfrow = c(1,2))
hist(X, freq=FALSE, main="Pois from Uniform")
hist(rpois(Nsim, lambda), freq=FALSE, main = 'Pois from rpois()')

## Mixture representations (depending on conditional density)

## X|y ~ Pois(y) and Y ~ Gamma(n, beta)
## then X ~ Neg(n,p) where beta = (1-p)/p
Nsim = 10^4
n=6; p=.3
y = rgamma(Nsim, n, rate=p/(1-p))
x = rpois(Nsim, y)
par(mfrow = c(1,1))
hist(x, main="", freq=F, col="grey", breaks=40)
lines(1:50, dnbinom(1:50,n,p), col="red")