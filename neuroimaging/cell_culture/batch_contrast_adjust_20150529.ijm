imageCount = 10
for (image = 1; image <= imageCount; image++) {
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/PSD95_MAP2_SYN1_" + image + "_w1Conf 488.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/PSD95_MAP2_SYN1_" + image + "_w2Conf 561.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/PSD95_MAP2_SYN1_" + image + "_w3Conf 640.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    run("Merge Channels...", "c1=[PSD95_MAP2_SYN1_" + image + "_w1Conf 488.TIF] c2=[PSD95_MAP2_SYN1_" + image + "_w2Conf 561.TIF] c3=[PSD95_MAP2_SYN1_" + image + "_w3Conf 640.TIF]");
    saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/PSD95_MAP2_SYN1_" + image + "_w3Conf_auto_contrast.tif");
}