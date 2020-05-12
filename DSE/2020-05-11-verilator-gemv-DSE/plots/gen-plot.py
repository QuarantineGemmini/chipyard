#!/usr/bin/env python

import matplotlib
import matplotlib.pyplot as plt
import csv
import os
import os.path
import numpy as np

DIR=os.path.dirname(os.path.realpath(__file__))

def read_csv_data(fname):
  with open(fname) as f:
    data = []
    for row in csv.DictReader(f, delimiter="\t"):
      data.append(row)
    return data

data_131072 = read_csv_data(f"{DIR}/gemv-mnk-131072.csv")
data_4096   = read_csv_data(f"{DIR}/gemv-mnk-4096.csv")
data_256    = read_csv_data(f"{DIR}/gemv-mnk-256.csv")

#-----------------------------------------------

font = {'size': 15}
matplotlib.rc('font', **font)

modes = ["orig", "fsm", "hw", "fg"]

fig, (ax0, ax1, ax2) = plt.subplots(1,3, sharey=True)
fig.set_figwidth(25)
width=0.20

x = np.arange(len(data_131072))

ax0.set_xticks(x)
ax1.set_xticks(x)
ax2.set_xticks(x)
text_params = {"rotation":45, "horizontalalignment":"right"}
ax0.set_xticklabels(map(lambda x: x["m,n,k"], data_131072), **text_params)
ax1.set_xticklabels(map(lambda x: x["m,n,k"], data_4096), **text_params)
ax2.set_xticklabels(map(lambda x: x["m,n,k"], data_256), **text_params)

ax0.set_title("vector length: 131072")
ax1.set_title("vector length: 4096")
ax2.set_title("vector length: 256")

ax0.set_ylabel("speedup")

for y in [1,2,3,4,5]:
  ax0.axhline(y,color="lightgray",linestyle="--",zorder=0)
  ax1.axhline(y,color="lightgray",linestyle="--",zorder=0)
  ax2.axhline(y,color="lightgray",linestyle="--",zorder=0)

for idx in range(len(modes)):
  mode   = modes[idx]
  offset = (-1.5 + idx)*width
  ys0    = list(map(lambda x: float(x[mode]), data_131072))
  ys1    = list(map(lambda x: float(x[mode]), data_4096))
  ys2    = list(map(lambda x: float(x[mode]), data_256))
  ax0.bar(x+offset, ys0, width)
  ax1.bar(x+offset, ys1, width)
  ax2.bar(x+offset, ys2, width, label=mode)

#ax0.set_ylim(bottom=0)
ax2.legend()


# create multi bar chart with 3 subplots that share same title
# - x-axis is 45-degree slant
# - y-axis is speedup
# - each subplot title is 131072 vector length, 4096, or 252 
# - NO TITLE
#   - the comment for the image is "GEMV speedup (DIM=32, FG_DIM=8)"

# for each data, create subplot

# print subplot
plt.tight_layout()
plt.savefig(f"{DIR}/gemv-plot.png")
print(f"finished generating {DIR}/gemv-plot.png")
