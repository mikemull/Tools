from __future__ import division

import numpy as np

m = np.array([ [0,   0, 1],
               [0.5, 0, 0],
               [0.5, 1, 0] ])

m2 = np.array([ [0,   1.0, 0,   0  ],
                [0.5, 0,   0,   0  ],
                [0.5, 0,   0,   1.0] ,
                [0,   0,   1.0, 0  ] ])

L = np.array([[0., 1., 1., 0.],
              [1., 0., 0., 0.],
              [0., 0., 0., 1.],
              [0., 0., 1., 0.]])
h=np.array([1.,1.,1.,1.]).T


x = np.ones(9) * 1/3
x.shape = (3,3)

#a = 0.85 * m + 0.15 * x
a = m

r = np.array([1]*3)
r2 = np.array([1/4]*4)
tr = [0.3*2/3, 0.3/3, 0, 0]

def pr(a,r):
    for i in range(5):
        r = np.dot(a,r)
        print r
    return r


def tspr(a,r,tr):

    for i in range(20):
        r = np.dot(a,r) + tr
        print r
    return r

'''
TSPR(3) = .1092
TSPR(2) = .7535
TSPR(4) = .6680
TSPR(4) = .1718
'''

'''
4 [21 + k + 3 (x + (1-x) k)]
'''

def blkstrip(k,x):
    return 4 * (21 + k + 3 * (x + (1-x) * k))

