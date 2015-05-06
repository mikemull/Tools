import math
import numpy as np

ad_data = {
'A' :	(10,	.015,	.010,	.005,	100),
'B' :   (9,	.016,	.012,	.006,	200),
'C' :	(8,	.017,	.014,	.007,	300),
'D' :	(7,	.018,	.015,	.008,	400),
'E' :	(6,	.019,	.016,	.010,	500)
}

    
x = (0,0)
y = (10,10)
a = (1,6)
b = (3,7)
c = (4,3)
d = (7,7)
e = (8,2)
f = (9,5)

centroids = [(float(x), float(y)) for x,y in [(25,125), (44,105), (29,97), (35,63), (55,63), (42,57), (23,40), (64,37), (33,22), (55,20)]]
clusters = [[c] for c in centroids]

points = [(28.0,145.0), (50.0, 130.0), (65.0, 140.0), (38.0, 115.0), (55.0, 118.0), (43.0, 83.0), (50.0, 90.0), (63.0, 88.0),
          (50.0, 60.0), (50.0, 30.0) ]

'''
UL=(3,15) and LR=(13,7); Blue: UL=(14,10) and LR=(23,6)  XX
UL=(7,8) and LR=(12,5); Blue: UL=(13,10) and LR=(16,4) XX
Yellow: UL=(3,15) and LR=(13,7); Blue: UL=(11,5) and LR=(17,2) XX
Yellow: UL=(7,12) and LR=(12,8); Blue: UL=(16,16) and LR=(18,5)
'''


def dt(s,t):
    return math.sqrt(sum( ( float(s[i]) - float(t[i]) )**2  for i in range(2)))


def max_to_cluster( c1, c2, points ):
    max_c1 = 0.0
    max_p1 = None
    max_c2 = 0.0
    max_p2 = None
    for p in points:
        dc1 = min( [dt(p,cp) for cp in c1] )
        dc2 = min( [dt(p,cp) for cp in c2] )
        if  dc1 <= dc2 and dc1 > max_c1:
            max_c1 = dc1
            max_p1 = p
        if dc2 <= dc1 and dc2 > max_c2:
            max_c2 = dc2
            max_p2 = p

    return max_p1,max_c1, max_p2, max_c2



def cossim(alpha):
    a = [1.0, 0.0, 1.0, 0.0, 1.0, alpha*2.0]
    b = [1.0, 1.0, 0.0, 0.0, 1.0, alpha*6.0]
    c = [0.0, 1.0, 0.0, 1.0, 0.0, alpha*2.0]

    ac = np.dot(a,c)/(np.linalg.norm(a)*np.linalg.norm(c))
    ab = np.dot(a,b)/(np.linalg.norm(a)*np.linalg.norm(b))
    bc = np.dot(b,c)/(np.linalg.norm(b)*np.linalg.norm(c))

    return 1-ac, 1-ab, 1-bc

def cossim2(alpha):
    a = [1.0, 0.0, 1.0, 0.0, 1.0, alpha*2.0]
    b = [1.0, 1.0, 0.0, 0.0, 1.0, alpha*6.0]
    c = [0.0, 1.0, 0.0, 0.1, 0.0, alpha*2.0]
    import scipy.spatial
    ac = scipy.spatial.distance.cosine(a,c)
    ab = scipy.spatial.distance.cosine(a,b)
    bc = scipy.spatial.distance.cosine(b,c)

    return ac, ab, bc


