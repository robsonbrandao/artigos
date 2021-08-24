#word_count.py

import string 
import map_reduce

def mapper(input_key,input_value):
  return [(word,1) for word in 
          input_value.lower().split()]



def reducer(intermediate_key,intermediate_value_list):
  return (intermediate_key,sum(intermediate_value_list))

filenames = ["text/text1.txt","text/text2.txt","text/text3.txt"]
i = {}
for filename in filenames:
  f = open(filename)
  i[filename] = f.read()
  f.close()

print (map_reduce.map_reduce(i,mapper,reducer))
