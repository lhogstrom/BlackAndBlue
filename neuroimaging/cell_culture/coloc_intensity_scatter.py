import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os
import tifffile
import seaborn as sns

# import TiffImagePlugin as tp

# fname1 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_F7_2_02_Roi_meaurements_GLU1.txt'
# fname2 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_F7_2_02_Roi_meaurements_SYN1.txt'
# glu1Tbl = pd.read_csv(fname1, sep='\t')
# syn1Tbl = pd.read_csv(fname2, sep='\t')

fname1 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_F7_2_02_w2Conf 488.TIF'
fname2 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_F7_2_02_w3Conf 561.TIF'

with tifffile.TiffFile(fname1) as tif1:
    syn1Mtrx = tif1.asarray()
    syn1meta = tif1[0].image_description

with tifffile.TiffFile(fname2) as tif2:
    glu1Mtrx = tif2.asarray()
    glu1meta = tif2[0].image_description

sA = syn1Mtrx.flatten()
gA = glu1Mtrx.flatten()
plt.plot(sA,gA, '.')

#apply threshold
iA = sA>775
iG = gA>569
sAthr = sA[iA*iG]
gAthr = gA[iA*iG]

#density plot 
# plt.plot(sAthr,gAthr,'.')
sns.jointplot(x=sAthr, y=gAthr, kind="kde");


### seaborn example

sns.set(style="dark")
# Set up the matplotlib figure
cmap = sns.cubehelix_palette(start=0, light=1, as_cmap=True)
f, axes = plt.subplots(1, 1, figsize=(4, 4), sharex=True, sharey=True)
# ax = axes.flat
# sns.kdeplot(sA, gA, cmap=cmap, shade=True, cut=5, ax=ax)
sns.kdeplot(sA[:100], gA[:100], cmap=cmap, shade=True)
f.tight_layout()
plt.show()
plt.plot(sA[:100], gA[:100],'.')

#scatter plot
sns.jointplot(sA[:10000], gA[:10000]);
plt.show()

# hexbin plots
with sns.axes_style("white"):
    sns.jointplot(x=sA[:], y=gA[:], kind="hex", color="k",xlim=(0,500),ylim=(0,500));
    # sns.jointplot(x=sA[:], y=gA[:], kind="hex", color="k");

#kernel density plot
sns.jointplot(x=sA[:20000], y=gA[:20000], kind="kde",xlim=(0,1000),ylim=(0,400));

# topo plot
f, ax = plt.subplots(figsize=(6, 6))
sns.kdeplot(sA[:20000], gA[:20000], ax=ax,xlim=(0,1000),ylim=(0,400))



