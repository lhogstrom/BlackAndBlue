open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/PSD95_MAP2_SYN1_6_w1Conf 488.TIF");
//run("Brightness/Contrast...");
// run("Enhance Contrast", "saturated=0.35");
setMinAndMax(110, 722);
open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/PSD95_MAP2_SYN1_6_w2Conf 561.TIF");
//run("Brightness/Contrast...");
//run("Enhance Contrast", "saturated=0.35");
setMinAndMax(245, 776);
open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150529/PSD95_MAP2_SYN1_6_w3Conf 640.TIF");
//run("Brightness/Contrast...");
//run("Enhance Contrast", "saturated=0.35");
setMinAndMax(117, 3323);
run("Merge Channels...", "c1=[PSD95_MAP2_SYN1_6_w1Conf 488.TIF] c2=[PSD95_MAP2_SYN1_6_w2Conf 561.TIF] c3=[PSD95_MAP2_SYN1_6_w3Conf 640.TIF]");
