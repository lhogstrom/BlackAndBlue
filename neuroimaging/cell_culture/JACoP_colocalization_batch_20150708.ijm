// pefrom contrast and merging for combined image
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
//     fname1 = "PSD95_SYN1_MAP_" + well_num + "_" + series + "_"+ str_n + "_w1Conf 405.TIF";
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/" + fname1);
//     //run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");    

//     fname2 = "PSD95_SYN1_MAP_" + well_num + "_" + series + "_"+ str_n + "_w2Conf 488.TIF";
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/" + fname2); 
//     // run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");

//     fname3 = "PSD95_SYN1_MAP_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 561.TIF";
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/" + fname3);
//     //run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");    

//     fname4 = "PSD95_SYN1_MAP_" + well_num + "_" + series + "_"+ str_n + "_w4Conf 640.TIF";
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/" + fname4);
//     //run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");    
    
//     // merge channels 
//     run("Merge Channels...", "c1=[" + fname1 + "] c2=[" + fname2 + "] c3=[" + fname3 + "] c4=[" + fname4 + "]");
//     saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/PSD95_SYN1_MAP_" + well_num + "_" + series + "_"+ str_n + "_auto_contrast.tif");
//     close();
// }

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

// perform Permutation
// 568 = PSD95
// 647 = SYN1
well_num = "F4";
series = 1;
imageCount = 9
for (image = 1; image <= imageCount; image++) {
    image2 = image + 1;
    if (image <=9){
        str_n1 = "0" + image;
        str_n2 = "0" + image2;
    }
    else {
        str_n1 = image;
        str_n2 = image2;
    }
 
    fname3 = "PSD95_SYN1_MAP_" + well_num + "_" + series + "_"+ str_n1 + "_w3Conf 561.TIF";
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/" + fname3);

    fname4 = "PSD95_SYN1_MAP_" + well_num + "_" + series + "_"+ str_n2 + "_w4Conf 640.TIF";
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/" + fname4);

    run("JACoP ", "imga=[" + fname3 + "] imgb=[" + fname4 + "] thra=221 thrb=447 pearson overlap mm cytofluo");
    selectWindow("Log");
    saveAs("Text", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/analysis/permutation for " + fname3 + " and " + fname4);
    close("Log");
    // selectWindow("Cytofluorogram between " + fname3 + " and " + fname4);
    // saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150708/analysis/Cytofluorogram between " + fname3 + " and " + fname4);
    close("*");
}

