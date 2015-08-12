// pefrom contrast and merging for combined image
// well_num = "E7";
// series = 1;
// imageCount = 9
// for (image = 1; image <= imageCount; image++) {
//     if (image <=9){
//         str_n = "0" + image;
//     }
//     else {
//         str_n = image;
//     }
//     fname1 = "SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w2Conf 488.TIF";
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/" + fname1); 
//     // run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");
//     fname2 = "SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 640.TIF";
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/" + fname2);
//     //run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");    
//     fname3 = "SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w1Conf 405.TIF";
//     open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/" + fname3);
//     //run("Brightness/Contrast...");
//     run("Enhance Contrast", "saturated=0.35");    
//     run("Merge Channels...", "c1=[SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w1Conf 405.TIF] c2=[SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w2Conf 488.TIF] c3=[SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 640.TIF]");
//     saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_auto_contrast.tif");
//     close();
// }

// perform JACoP - intensity-based colocalization analysis
well_num = "D7";
series = 1;
imageCount = 9
for (image = 1; image <= imageCount; image++) {
    if (image <=9){
        str_n = "0" + image;
    }
    else {
        str_n = image;
    }
    fname1 = "SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w2Conf 488.TIF";
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/" + fname1);
    fname2 = "SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 640.TIF";
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/" + fname2);
    // open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w2Conf 488.TIF");
    // open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/SYN1_MAP2_" + well_num + "_" + series + "_"+ str_n + "_w3Conf 561.TIF");
    run("JACoP ", "imga=[" + fname1 + "] imgb=[" + fname2 + "] thra=221 thrb=447 pearson overlap mm cytofluo");
    selectWindow("Log");
    saveAs("Text", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/analysis/metrics for " + fname1 + " and " + fname2);
    close("Log");
    selectWindow("Cytofluorogram between " + fname1 + " and " + fname2);
    saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150715/analysis/Cytofluorogram between " + fname1 + " and " + fname2);
    close("*");
}

