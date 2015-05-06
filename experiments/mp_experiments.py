
import multiprocessing

def f(name):
    print name
    raise Exception

#p = multiprocessing.Process(target=f, args=('bob',))
#p.start()

pool = multiprocessing.Pool(5)

pool.map(f, [])

