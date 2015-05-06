
import binascii

c = '09e1c5f70a65ac519458e7e53f36'
m = 'attack at dawn'

cbytes = [ ord(x) for x in binascii.unhexlify(c) ]

mbytes = [ ord(x) for x in m ]

kbytes = [ cb ^ mb for cb,mb in zip(cbytes, mbytes) ]

m2 = m[:-3]+'usk'
m2bytes = [ ord(x) for x in m2 ]

c2bytes = [ chr(mb ^ kb) for mb,kb in zip(m2bytes, kbytes) ]

c2 = binascii.hexlify(''.join(c2bytes))

print c2


