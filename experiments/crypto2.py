
import binascii

f2pairs = [('7b50baab', 'ac343a22'),
      ('5f67abaf', 'bbe033c0'),
      ('7c2822eb', '325032a9'),
      ('e86d2de2', '1792d21d')]


for l0, l1 in f2pairs:
    l0bytes = [ ord(x) for x in binascii.unhexlify(l0) ]
    l1bytes = [ ord(x) for x in binascii.unhexlify(l1) ]

    kbytes = [ cb ^ mb for cb,mb in zip(l0bytes, l1bytes) ]
    print l0, l1, kbytes

