addpath('/Users/hogstrom/Documents/code/BlackAndBlue/neuroimaging/cell_culture/')

fname = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_F7_2_02_w2Conf 488.TIF';
Iraw1 = imread(fname);
fname = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_F7_2_02_w3Conf 561.TIF';
Iraw2 = imread(fname);
fname = '/Users/hogstrom/Dropbox (MIT)/imaging_data/20150716/SYN1_GLU1_F7_2_02_w1Conf 405.TIF';
Iraw3 = imread(fname);

%combine into sinlge matrix
Iraw(:,:,1) = Iraw1;
Iraw(:,:,2) = Iraw2;
Iraw(:,:,3) = Iraw3;

img_name = 'Syn1_img'; 
[MCCmarker, MCCab, pcc_no_nuc] = manderSynapse(Iraw,img_name)


%%
im5(:,:,1) = Iraw2;
im5(:,:,2) = Iraw1;
[C_rad, C0, pval] = radial_CCF(im5);

plot(C_rad(1:540)) %plot offset up to 50%
ylabel('corr','FontSize',18)
xlabel('pixel offset','FontSize',18)
title('cross correlation by pixel offset','FontSize',18)