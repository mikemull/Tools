'''
20 81 48 04 c1 76 72 93 b9 9f 1d 9c ab3bc3e7 
ac 1e 37 bf b1 55 99 e5 f4 0e ef 80 5488281d 
P  a  y     B  o  b     1  0  0  $
'''

import binascii

x = 0xb9 ^ 49 ^ 53
y = 0xb9 ^ 49

print hex(x)
print hex(x^y)
