imageCount = 99
for (image = 1; image <= imageCount; image++) {
    if (image <=9){
        str_n = "0" + image;
    }
    else {
        str_n = image;
    }
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150702/PSD95_SYN1_MAP2_" + str_n + "_w1Conf 405.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150702/PSD95_SYN1_MAP2_" + str_n + "_w2Conf 488.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150702/PSD95_SYN1_MAP2_" + str_n + "_w3Conf 561.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150702/PSD95_SYN1_MAP2_" + str_n + "_w4Conf 640.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    run("Merge Channels...", "c1=[PSD95_SYN1_MAP2_" + str_n + "_w1Conf 405.TIF] c2=[PSD95_SYN1_MAP2_" + str_n + "_w2Conf 488.TIF] c3=[PSD95_SYN1_MAP2_" + str_n + "_w3Conf 561.TIF] c4=[PSD95_SYN1_MAP2_" + str_n + "_w4Conf 640.TIF]");
    saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150702/PSD95_SYN1_MAP2_" + str_n + "  _auto_contrast.tif");
    close();
}