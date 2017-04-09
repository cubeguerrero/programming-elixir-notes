# Problem
Try the following in iex:
```
iex > ['cat' | 'dog']
['cat', 100, 111, 103]
```

Why does iex print 'cat' as a string, but 'dog' as individual numbers.

# Solution
Basically iex saw that the 'cat' can still be printed while the added code points from the 'dog', it sees as non printable already.
