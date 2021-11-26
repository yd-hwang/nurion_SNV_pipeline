#!/bin/python
#plot.py
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt

fig = plt.figure()
ax = fig.subplots()
ax.plot([1, 2, 3])
fig.savefig('python_plot.png')