// // pefrom contrast and merging for combined image
// well_num = "F7";
// series = 3;
// imageCount = 17
// for (image = 9; image <= imageCount; image++) {
//     if (image <=9){
//         str_n = "0" + image;
//     }
//     else {
//         str_n = image;
//     }
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w1Conf 405.TIF"); 
//     // run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w2Conf 488.TIF");
//     //run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");    
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 561.TIF");
//     //run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");    
//     run("Merge Channels...", "c1=[SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w1Conf 405.TIF] c2=[SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w2Conf 488.TIF] c3=[SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 561.TIF]");
//     saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_auto_contrast.tif");
//     close();
// }

// perform JACoP - intensity-based colocalization analysis
well_num = "F7";
series = 2;
imageCount = 9
for (image = 1; image <= imageCount; image++) {
    if (image <=9){
        str_n = "0" + image;
    }
    else {
        str_n = image;
    }
    fname1 = "SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w2Conf 488.TIF";
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/" + fname1);
    fname2 = "SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 561.TIF";
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/" + fname2);
    // open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w2Conf 488.TIF");
    // open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 561.TIF");
    run("JACoP ", "imga=[" + fname1 + "] imgb=[" + fname2 + "] thra=971 thrb=746 pearson overlap mm cytofluo");
    selectWindow("Log");
    saveAs("Text", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/analysis/metrics for " + fname1 + " and " + fname2);
    close("Log");
    selectWindow("Cytofluorogram between " + fname1 + " and " + fname2);
    saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/analysis/Cytofluorogram between " + fname1 + " and " + fname2);
    close("*");
}

