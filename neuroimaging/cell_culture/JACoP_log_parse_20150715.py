import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os
import seaborn as sns

### colocalization log files for wells C7,D7,E7
fname1 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/analysis/metrics for SYN1_MAP2_C7_1_09_w2Conf 488.TIF and SYN1_MAP2_C7_1_09_w3Conf 640.txt'
fname2 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/analysis/metrics for SYN1_MAP2_D7_1_09_w2Conf 488.TIF and SYN1_MAP2_D7_1_09_w3Conf 640.txt'
fname3 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/analysis/metrics for SYN1_MAP2_E7_1_09_w2Conf 488.TIF and SYN1_MAP2_E7_1_09_w3Conf 640.txt'

### construct a data frame that parses the JACoP log file
### Extract colocalization coeffiients 
files = [fname1, fname2, fname3]
colocFrm = pd.DataFrame()
ixDict = {}
#loop through reading stats from files
for ixx,fname in enumerate(files):
    infile = open(fname)      # open the file for reading
    lineList = infile.readlines()
    # create empty lists
    metricList = []
    pearsonList = []
    overlapcoefList = []
    overlapThrList = []
    k1List = []
    k2List = []
    k1ThrList = []
    k2ThrList = []
    seriesList = []
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
    ixDict[fname] = seriesList
    d = {}
    d = {'overlap_coeff': overlapcoefList,'overlap_coeff_thr': overlapThrList, 'Pearsons':pearsonList,'K1':k1List,'K2':k2List,'K1_thr':k1ThrList,'K2_thr':k2ThrList}
    tmpFrm = pd.DataFrame()
    tmpFrm = pd.DataFrame(data=d, index=seriesList)
    colocFrm = colocFrm.append(tmpFrm)

#boxplot frame
metric = 'K2_thr'
boxDict = {}
boxDict['1:1000'] = colocFrm.ix[ixDict[fname1],metric]
boxDict['1:2000'] = colocFrm.ix[ixDict[fname2],metric]
boxDict['1:5000'] = colocFrm.ix[ixDict[fname3],metric]
boxplotFrm = pd.DataFrame(data=boxDict)
### create boxplot
boxplotFrm.boxplot()
plt.title('TUBB3 & MAP2 colocalization',fontsize=20)
plt.ylabel('K2',fontsize=20)
plt.xlabel('primary antibody concentration',fontsize=20)
plt.show()

### show the effect of thresholding
metric1 = 'overlap_coeff'
metric2 = 'overlap_coeff_thr'
boxDict = {}
boxDict['1:1000'] = colocFrm.ix[ixDict[fname1],metric1]
boxDict['1:1000 Thr'] = colocFrm.ix[ixDict[fname1],metric2]
boxDict['1:2000'] = colocFrm.ix[ixDict[fname2],metric1]
boxDict['1:2000 Thr'] = colocFrm.ix[ixDict[fname2],metric2]
boxDict['1:5000'] = colocFrm.ix[ixDict[fname3],metric1]
boxDict['1:5000 Thr'] = colocFrm.ix[ixDict[fname3],metric2]
boxplotFrm = pd.DataFrame(data=boxDict)
### create boxplot
boxplotFrm.boxplot()
plt.title('TUBB3 & MAP2 colocalization',fontsize=20)
plt.ylabel('K2',fontsize=20)
plt.xlabel('primary antibody concentration',fontsize=20)
plt.show()


