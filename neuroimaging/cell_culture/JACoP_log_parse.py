import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

fname1 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/analysis/metrics for SYN1_GLU1_F7_3_17_w2Conf 488.TIF and SYN1_GLU1_F7_3_17_w3Conf 561.txt'

### construct a data frame that parses the JACoP log file
### Extract colocalization coeffiients 
metricList = []
pearsonList = []
overlapcoefList = []
overlapThrList = []
k1List = []
k2List = []
k1ThrList = []
k2ThrList = []
seriesList = []
infile = open(fname1)      # open the file for reading
lineList = infile.readlines()
for ix, line in enumerate(lineList):
    ### grab Pearson coef
    if line.find("Pearson's") > -1:
        nextLine = lineList[ix+1]
        pearsonList.append(float(nextLine[2:]))
    ### grab overlap Coeff without threshold
    if line.find("Image B:") > -1: 
        nextLine = lineList[ix+6]
        overlapcoefList.append(float(nextLine[2:]))
    ### grab overlap Coeff with threshold
    if line.find("Using thresholds (thrA") > -1: 
        nextLine = lineList[ix+3]
        overlapThrList.append(float(nextLine[2:]))
    ### grab well and series number
    if line.find("w2Conf") > -1:
        seriesList.append(line[19:26])
    ### grab overlap K1 without threshold
    if line.find("Image B:") > -1: 
        nextLine = lineList[ix+9]
        k1List.append(float(nextLine[3:]))
    ### grab overlap K2 without threshold
    if line.find("Image B:") > -1: 
        nextLine = lineList[ix+10]
        k2List.append(float(nextLine[3:]))
    ### grab overlap K1 with threshold
    if line.find("Using thresholds") > -1: 
        nextLine = lineList[ix+6]
        k1ThrList.append(float(nextLine[3:]))
    ### grab overlap K1 with threshold
    if line.find("Using thresholds") > -1: 
        nextLine = lineList[ix+7]
        k2ThrList.append(float(nextLine[3:]))   
# d = {'well_series': seriesList, 'overlap_coeff': overlapcoefList, 'Pearsons':pearsonList}
d = {'overlap_coeff': overlapcoefList,'overlap_coeff_thr': overlapThrList, 'Pearsons':pearsonList,'K1':k1List,'K2':k2List,'K1_thr':k1ThrList,'K2_thr':k2ThrList}
colocFrm = pd.DataFrame(data=d, index=seriesList)

### create boxplot
colocFrm.boxplot()
plt.show()
