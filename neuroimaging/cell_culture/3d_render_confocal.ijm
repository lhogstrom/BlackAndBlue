//setTool("hand");
run("3D Viewer");
call("ij3d.ImageJ3DViewer.setCoordinateSystem", "false");
call("ij3d.ImageJ3DViewer.add", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_2_w1Conf 640.TIF", "None", "primary_neuron_20150520_2_w1Conf 640.TIF", "0", "true", "true", "true", "2", "0");
call("ij3d.ImageJ3DViewer.setColor", "255", "0", "0");
call("ij3d.ImageJ3DViewer.setThreshold", "125");
call("ij3d.ImageJ3DViewer.add", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_2_w2Conf 488.TIF", "None", "primary_neuron_20150520_2_w2Conf 488.TIF", "0", "false", "true", "false", "2", "0");
call("ij3d.ImageJ3DViewer.select", "primary_neuron_20150520_2_w2Conf 488.TIF");
call("ij3d.ImageJ3DViewer.setTransparency", "0.64");
call("ij3d.ImageJ3DViewer.add", "/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_2_w3Conf 561.TIF", "None", "primary_neuron_20150520_2_w3Conf 561.TIF", "0", "false", "false", "true", "2", "0");
call("ij3d.ImageJ3DViewer.select", "primary_neuron_20150520_2_w3Conf 561.TIF");
call("ij3d.ImageJ3DViewer.select", "primary_neuron_20150520_2_w3Conf 561.TIF");
call("ij3d.ImageJ3DViewer.setTransparency", "0.78");
call("ij3d.ImageJ3DViewer.record360");
run("Save", "save=[/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/Movie_2_w2Conf.tif]");
