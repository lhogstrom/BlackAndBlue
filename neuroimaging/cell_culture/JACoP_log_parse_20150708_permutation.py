import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os
import seaborn as sns

### colocalization log files for wells C7,D7,E7
fname1 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/analysis/metrics for PSD95_SYN1_MAP2_F2_2_09_w3Conf 561.TIF and PSD95_SYN1_MAP2_F2_2_09_w4Conf 640.txt'
fname2 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/analysis/metrics for PSD95_SYN1_MAP2_F3_1_09_w3Conf 561.TIF and PSD95_SYN1_MAP2_F3_1_09_w4Conf 640.txt'
fname3 = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/analysis/metrics for PSD95_SYN1_MAP_F4_1_09_w3Conf 561.TIF and PSD95_SYN1_MAP_F4_1_09_w4Conf 640.txt'

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
    m1ThrList = []
    m2ThrList = []    
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
        if line.find("w3Conf") > -1:
            seriesList.append(line[25:32])
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
        ### grab overlap K2 with threshold
        if line.find("Using thresholds") > -1: 
            nextLine = lineList[ix+7]
            k2ThrList.append(float(nextLine[3:]))   
        ### grab overlap M1 with threshold
        if line.find("Manders' Coefficients (using threshold") > -1: 
            nextLine = lineList[ix+1]
            m1ThrList.append(float(nextLine[3:7]))   
        ### grab overlap M2 with threshold
        if line.find("Manders' Coefficients (using threshold") > -1: 
            nextLine = lineList[ix+2]
            m2ThrList.append(float(nextLine[3:7]))                           
    # d = {'well_series': seriesList, 'overlap_coeff': overlapcoefList, 'Pearsons':pearsonList}
    ixDict[fname] = seriesList
    d = {}
    d = {'overlap_coeff': overlapcoefList,'overlap_coeff_thr': overlapThrList, 'Pearsons':pearsonList,'K1':k1List,'K2':k2List,'K1_thr':k1ThrList,'K2_thr':k2ThrList,'M1_thr':k1ThrList,'M2_thr':k2ThrList}
    tmpFrm = pd.DataFrame()
    tmpFrm = pd.DataFrame(data=d, index=seriesList)
    colocFrm = colocFrm.append(tmpFrm)

#boxplot frame
metric = "M1_thr"
boxDict = {}
boxDict['50K'] = colocFrm.ix[ixDict[fname1],metric]
boxDict['75K'] = colocFrm.ix[ixDict[fname2],metric]
boxDict['100K'] = colocFrm.ix[ixDict[fname3],metric]
boxplotFrm = pd.DataFrame(data=boxDict)
### create boxplot
boxplotFrm.boxplot(column=['50K','75K','100K'])
plt.title('PSD95 & SYN1 colocalization',fontsize=20)
plt.ylabel('M1',fontsize=20)
plt.xlabel('cell count per well',fontsize=20)
# plt.show()
graphDir = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/analysis/'
outF = os.path.join(graphDir,'PSD95_SYN1_Manders_M1.png')
plt.savefig(outF, bbox_inches='tight',dpi=200)
plt.close()

### show the effect of thresholding
# metric1 = 'overlap_coeff'
# metric2 = 'overlap_coeff_thr'
# boxDict = {}
# boxDict['1:1000'] = colocFrm.ix[ixDict[fname1],metric1]
# boxDict['1:1000 Thr'] = colocFrm.ix[ixDict[fname1],metric2]
# boxDict['1:2000'] = colocFrm.ix[ixDict[fname2],metric1]
# boxDict['1:2000 Thr'] = colocFrm.ix[ixDict[fname2],metric2]
# boxDict['1:5000'] = colocFrm.ix[ixDict[fname3],metric1]
# boxDict['1:5000 Thr'] = colocFrm.ix[ixDict[fname3],metric2]
# boxplotFrm = pd.DataFrame(data=boxDict)
# ### create boxplot
# boxplotFrm.boxplot()
# plt.title('TUBB3 & MAP2 colocalization',fontsize=20)
# plt.ylabel('K2',fontsize=20)
# plt.xlabel('primary antibody concentration',fontsize=20)
# plt.show()


