// load files 
// open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_2_w1Conf 640.TIF");
// open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_2_w2Conf 488.TIF");
// open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_2_w3Conf 561.TIF");

// run("Merge Channels...", "c1=[primary_neuron_20150520_2_w1Conf 640.TIF] c2=[primary_neuron_20150520_2_w2Conf 488.TIF] c3=[primary_neuron_20150520_2_w3Conf 561.TIF] create");

open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_3_w1Conf 640.TIF");
open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_3_w2Conf 488.TIF");
open("/Users/hogstrom/Dropbox (MIT)/imaging_data/20150520/primary_neuron_20150520_3_w3Conf 561.TIF");

run("Merge Channels...", "c1=[primary_neuron_20150520_3_w1Conf 640.TIF] c2=[primary_neuron_20150520_3_w2Conf 488.TIF] c3=[primary_neuron_20150520_3_w3Conf 561.TIF] create");

