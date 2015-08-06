import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

fname1 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_F7_2_02_Roi_meaurements_GLU1.txt'
fname2 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_F7_2_02_Roi_meaurements_SYN1.txt'
glu1Tbl = pd.read_csv(fname1, sep='\t')
syn1Tbl = pd.read_csv(fname2, sep='\t')

roiTbl = pd.DataFrame(glu1Tbl.Mean)
roiTbl['GLU1'] = glu1Tbl.Mean.values
roiTbl['SYN1'] = syn1Tbl.Mean.values
roiTbl = roiTbl.drop('Mean',1)
roiTbl.boxplot()
plt.title('mean puncta intensity')

graphDir = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/analysis'
outF = os.path.join(graphDir,'mean_puncta_intensity_F7.png')
plt.savefig(outF, bbox_inches='tight',dpi=200)

### puncta size 
roiTbl = pd.DataFrame(glu1Tbl.Mean)
roiTbl['Puncta'] = glu1Tbl.Area.values
# roiTbl['SYN1'] = syn1Tbl.Area.values
roiTbl = roiTbl.drop('Mean',1)
roiTbl.boxplot()
plt.title('mean puncta area')
outF = os.path.join(graphDir,'mean_puncta_area_F7.png')
# plt.savefig(outF, bbox_inches='tight',dpi=200)
plt.savefig(outF,dpi=200)

