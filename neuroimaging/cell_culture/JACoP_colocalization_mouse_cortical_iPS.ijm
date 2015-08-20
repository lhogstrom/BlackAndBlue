// perform JACoP - intensity-based colocalization analysis
// 568 = PSD95
// 647 = SYN1

// well_num = "F4";
// series = 1;
// imageCount = 9
// for (image = 1; image <= imageCount; image++) {
//     if (image <=9){
//         str_n = "0" + image;
//     }
//     else {
//         str_n = image;
//     }
 
//     fname3 = "PSD95_SYN1_MAP_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 561.TIF";
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/" + fname3);

//     fname4 = "PSD95_SYN1_MAP_" + well_num + "_" + series + "_"+ str_n + "_w4Conf 640.TIF";
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/" + fname4);

//     run("JACoP ", "imga=[" + fname3 + "] imgb=[" + fname4 + "] thra=221 thrb=447 pearson overlap mm cytofluo");
//     selectWindow("Log");
//     saveAs("Text", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/analysis/metrics for " + fname3 + " and " + fname4);
//     close("Log");
//     selectWindow("Cytofluorogram between " + fname3 + " and " + fname4);
//     saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/analysis/Cytofluorogram between " + fname3 + " and " + fname4);
//     close("*");
// }

// perform JACoP for mouse cortical neurons
// 568 = PSD95
// 647 = SYN1
imageCount = 9
for (image = 2; image <= imageCount; image++) {
    // {
    // if (image <=9){
    //     str_n = "0" + image;
    // }
    // else {
    //     str_n = image;
    // }
    str_n = image;
 
    fname3 = "PSD95_MAP2_SYN1_" + str_n + "_w2Conf 561.TIF";
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/" + fname3);

    fname4 = "PSD95_MAP2_SYN1_" +  str_n + "_w3Conf 640.TIF";
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/" + fname4);

    run("JACoP ", "imga=[" + fname3 + "] imgb=[" + fname4 + "] thra=278 thrb=299 pearson overlap mm cytofluo");
    selectWindow("Log");
    saveAs("Text", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/analysis/metrics for " + fname3 + " and " + fname4);
    close("Log");
    selectWindow("Cytofluorogram between " + fname3 + " and " + fname4);
    saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/analysis/Cytofluorogram between " + fname3 + " and " + fname4);
    close("*");
}
