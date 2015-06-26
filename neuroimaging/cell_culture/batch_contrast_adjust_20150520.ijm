cdimageCount = 3
for (image = 1; image <= imageCount; image++) {
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_" + image + "_w2Conf 488.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_" + image + "_w3Conf 561.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_" + image + "_w1Conf 640.TIF");
    //run("Brightness/Contrast...");
    run("Enhance Contrast", "saturated=0.35");
    run("Merge Channels...", "c1=[primary_neuron_20150520_" + image + "_w2Conf 488.TIF] c2=[primary_neuron_20150520_" + image + "_w3Conf 561.TIF] c3=[primary_neuron_20150520_" + image + "_w1Conf 640.TIF]");
    saveAs("Tiff", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_" + image + "_auto_contrast.tif");
}