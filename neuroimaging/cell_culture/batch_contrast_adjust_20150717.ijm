imageCount = 99
for (image = 1; image <= imageCount; image++) {
    if (image <=9){
        str_n = "0" + image;
    }
    else {
        str_n = image;
    }
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150717/SYN1_PSD95_C9_1_" + str_n + "_w1Conf 405.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150717/SYN1_PSD95_C9_1_" + str_n + "_w2Conf 488.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150717/SYN1_PSD95_C9_1_" + str_n + "_w3Conf 561.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    run("Merge Channels...", "c1=[SYN1_PSD95_C9_1_" + str_n + "_w1Conf 405.TIF] c2=[SYN1_PSD95_C9_1_" + str_n + "_w2Conf 488.TIF] c3=[SYN1_PSD95_C9_1_" + str_n + "_w3Conf 561.TIF]");
    saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150717/SYN1_PSD95_C9_1_" + str_n + "_auto_contrast.tif");
    close();
}