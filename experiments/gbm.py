import numpy as np
import matplotlib.pyplot as plt


x = 1.0 #initial balance
r = 0.05 
s = 0.18 
T = 100

gbar = r - 0.5*s**2 # time average of the log returns
gbarvar = s*T**(-0.5)/gbar # variance of the rate of return. Not sure how this was derived, but probably from properties of lognormal distribution.
tc = s**2/gbar**2 # time scale which separates "long term" from regime where randomness dominates

pem = np.zeros(T)
pmil = np.zeros(T)
pexact = np.zeros(T)
pem[0] = x
pmil[0] = x

g = np.zeros(T)

dW = np.random.randn(T) # We can use the increments dW to generate a Wiener process
#W = np.zeros(T)
W = np.cumsum(dW)

#implementation of Euler-Maruyama method and Milstein's higher order method for integrating geometric Brownian motion SDE
#also calculating the log returns at each time step using the EM method
for i in range(1,T):
    pem[i] = pem[i-1] + r*pem[i-1] + s*pem[i-1]*(W[i]-W[i-1])
    pmil[i] = pmil[i-1] + r*pmil[i-1] + s*pmil[i-1]*(W[i]-W[i-1]) + 0.5*s*s*pmil[i-1]*((W[i]-W[i-1])**2-1)
    g[i] = np.log(pem[i]/pem[0])/i

#exact solution to geometric Brownian motion using a Wiener process constructed from dW
pexact = x * np.exp( gbar * np.arange(T) + s*W )     
#plot the difference between the measured log returns and the predicted log returns
gerr = (g - gbar)/gbar
plt.plot(gerr, 'r--')
plt.show()

plt.plot(pem,'rx')
plt.plot(pmil,'bo')
plt.plot(pexact)
plt.show()

