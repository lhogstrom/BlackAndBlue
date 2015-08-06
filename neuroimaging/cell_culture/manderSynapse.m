function [MCCmarker, MCCab, pcc_no_nuc] = manderSynapse(Iraw,img_name)
global fig_num
fig_path = ['C:\Documents and Settings\Sam\My Documents\Google Drive\bayesian_application\Thorsten_fitting\'] ;
%Set parameters
%

%Fraction of Otsu threshold to increase intensity by for synapse
%segmentation:
% fraction parameters for images after contrast enhancement 
% marker_params.otsuCorrectFrac = 0.5;
% ab_params.otsuCorrectFrac = 0.2;

% fraction parameters for raw images 
nuc_params.otsuCorrectFrac = -0.4;
marker_params.otsuCorrectFrac = 0;
ab_params.otsuCorrectFrac = 0;

%Maximum continuous region size of synapses (to remove nuclei based on
%size):
marker_params.maxObjSize = 1000;
ab_params.maxObjSize = 1000;
nuc_params.maxObjSize = 100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Check if synapsin 1 was used as marker, otherwise it's PSD95:
if size(Iraw,3) == 3 ;
    Inuc_raw = Iraw(:,:,3);
    Inuc = mat2gray(Inuc_raw); 
    Inuc_eq = adapthisteq(Inuc);      
else
end

if ~isempty(strfind(img_name,'Syn1')) %if synapsin 1
    Imarker_raw = Iraw(:,:,1);    
    Iab_raw = Iraw(:,:,2);
    marker_params.name = 'Syn1' ;    
elseif ~isempty(strfind(img_name,'PSD95'))
    Imarker_raw = Iraw(:,:,2);    
    Iab_raw = Iraw(:,:,1);
    marker_params.name = 'PSD95' ;
else
    error('Synaptic marker channel cannot be determined') ;
end

    Imarker = mat2gray(Imarker_raw);    
    Iab = mat2gray(Iab_raw);    
    Imarker_eq = adapthisteq(Imarker);  
    Iab_eq = adapthisteq(Iab);    
%     Imarker_eq = Imarker;  
%     Iab_eq = Iab;    
%%
if exist('Inuc', 'var')
    nuc_params = segmentNuc(Inuc_eq, nuc_params) ;      
else
    nuc_params.otsuCorrectFrac = 0.4;
    nuc_params.maxObjSize = 1200;
    nuc_params = segmentNuc(Iab_eq, nuc_params) ;
end
nucMask = nuc_params.NucMask ;
marker_params.NucMask = nucMask ;
ab_params.NucMask = nucMask ;           
    
%     Imarker_eq = Imarker;  
%     Iab_eq = Iab;    
    
%     marker_params.NucMask = marker_params.NucMask | ab_params.NucMask ;
%     ab_params.NucMask = marker_params.NucMask | ab_params.NucMask ;       
%%
if isempty(strfind(img_name,'_p'))&& ~exist('Inuc', 'var')  % %remove nuclear region for antibody with DNA       
    marker_params.nucRm = 0 ;
    ab_params.nucRm = 0 ;
else
    marker_params.nucRm = 1 ;
    ab_params.nucRm = 1 ;
end
%remove nuclear region for ArpC2 even without DNA
if ~isempty(strfind(img_name,'ArpC2'))        
    marker_params.nucRm = 1 ;
    ab_params.nucRm = 1 ;
end

% markerMask = segment_synapse(Imarker_eq, marker_params) ;
% abMask = segment_synapse(Iab_eq, ab_params) ;
markerMask = segment_synapse(Imarker, marker_params) ;
abMask = segment_synapse(Iab, ab_params) ;

%% Plotting
markerMask_perim = bwperim(markerMask);
Imarker_eq_perim = imoverlay(Imarker_eq, markerMask_perim, [1 0 0]);

abMask_perim = bwperim(abMask);
Iab_eq_perim = imoverlay(Iab_eq, abMask_perim, [0 1 1]);

Imonta = cat(4, imoverlay(Imarker_eq, false(size(Iab_eq)), [0 0 0]),...
    imoverlay(Iab_eq, false(size(Iab_eq)), [0 0 0]),...    
    Imarker_eq_perim, Iab_eq_perim) ;

figure(102)
montage(Imonta,'DisplayRange', [0.1 0.9]) ;
% set(gcf, 'position', [1         35        1920        1006])
set(gcf, 'position', [1921         121        1920        1006])
% print(102 ,'-dpng','-r300', [fig_path,num2str(fig_num, '%03d'),'.png']) ; fig_num = fig_num +1 ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IabCell = mat2cell(Iab,size(Iab,1)/2*[1 1],size(Iab,2)/2*[1 1]);
ImarkerCell = mat2cell(Imarker,size(Imarker,1)/2*[1 1],size(Imarker,2)/2*[1 1]);
abMaskCell = mat2cell(abMask,size(abMask,1)/2*[1 1],size(abMask,2)/2*[1 1]);
markerMaskCell = mat2cell(markerMask,size(markerMask,1)/2*[1 1],size(markerMask,2)/2*[1 1]);
nucMaskCell = mat2cell(nucMask,size(nucMask,1)/2*[1 1],size(nucMask,2)/2*[1 1]);

%Compute MCC (Manders correlation coefficient):
[MCCmarker MCCab] = cellfun(@mander,IabCell,ImarkerCell,abMaskCell, markerMaskCell);
pcc_no_nuc = cellfun(@PCC_no_nuc,IabCell,ImarkerCell,nucMaskCell);
%Compute PCC (Pearson correlation coefficient):
% PCC = corr(Iab(markerMask),Imarker(markerMask));

%Make sparse for saving memory:
% abMask = sparse(abMask);
% markerMask = sparse(markerMask);


%Save and output images, masks, and MCC:
% save(fullfile(fileparts(params.imgPath),'CoLocSynapseAnalysis.mat'),'MCCab','MCCmarker','PCC','Iab','abMask','Imarker','markerMask');
end

function params = segmentNuc(Iab_eq, params)
%%
global fig_num
fig_path = ['C:\Documents and Settings\Sam\My Documents\Google Drive\bayesian_application\Thorsten_fitting\'] ;
% Iab_eq = adapthisteq(Iab);   
figure(100)
subplot(2,2,1)
imshow(Iab_eq,[], 'InitialMagnification', 'fit');

Tab = graythresh(Iab_eq);

% IabOtsuMaskNuc = im2bw(Iab_eq,1.4*Tab); %segment bright nuclei
IabOtsuMaskNuc = im2bw(Iab_eq,Tab+params.otsuCorrectFrac*Tab); %segment bright nuclei
% IabOtsuMaskNuc = im2bw(Iab_eq,1*Tab); %segment bright nuclei
figure(100)
subplot(2,2,2)
% figure(61)
imshow(IabOtsuMaskNuc,[], 'InitialMagnification', 'fit');


IabOtsuMaskNuc = imopen(IabOtsuMaskNuc,strel('disk',3));


% figure(62)
figure(100)
subplot(2,2,3)
imshow(IabOtsuMaskNuc,[], 'InitialMagnification', 'fit');

% Tab_open = graythresh(Iab_open);

IabOtsuMaskNuc = bwareaopen(IabOtsuMaskNuc, params.maxObjSize);
% IabOtsuMaskNuc = imclose(IabOtsuMaskNuc,strel('disk',3));
IabOtsuMaskNuc = imdilate(IabOtsuMaskNuc,strel('disk',8));
IabOtsuMaskNuc = imfill(IabOtsuMaskNuc,'holes');

%%remove elongated objects
NucObj = regionprops(IabOtsuMaskNuc,'Eccentricity');
NucEccen = cat(1, NucObj.Eccentricity);
ElongInd = find(NucEccen > 0.9) ;
IabOtsuMaskNucLbl = bwlabel(IabOtsuMaskNuc) ;

for j = 1:numel(ElongInd)
    IabOtsuMaskNucLbl(IabOtsuMaskNucLbl == ElongInd(j)) = 0 ;
end

IabOtsuMaskNuc = IabOtsuMaskNucLbl>0 ; % conver labeled image to binary 
params.NucMask = IabOtsuMaskNuc ;

figure(100)
subplot(2,2,4)
imshow(IabOtsuMaskNuc,[], 'InitialMagnification', 'fit');
% print(100 ,'-dpng','-r300', [fig_path,num2str(fig_num, '%03d'),'.png']) ; fig_num = fig_num +1 ;
end

function abMask = segment_synapse(Iab_eq, params)
%% Do Otsu thresholding on marker and ab.
global fig_num
fig_path = ['C:\Documents and Settings\Sam\My Documents\Google Drive\bayesian_application\Thorsten_fitting\'] ;
if params.nucRm == 1 ;
    IabOtsuMaskNuc = params.NucMask ;        
    sat_lim = stretchlim(Iab_eq(~IabOtsuMaskNuc)) ;
    Iab_ad = imadjust(Iab_eq, sat_lim);
% Iab_ad = Iab_eq ;
else
    Iab_ad = imadjust(Iab_eq);
% Iab_ad = Iab_eq ;
end


Iab_nobg = imtophat(Iab_ad,strel('disk',10)) ;
% Iab_nobg = imtophat(Iab,strel('disk',10)) ;
if params.nucRm == 1 ;
    IabOtsuMaskNuc = params.NucMask ;    
    Tab = graythresh(Iab_nobg(~IabOtsuMaskNuc));
else
    Tab = graythresh(Iab_nobg);
end

[count, bin_l] = hist(Iab_nobg(:),100);
    figure(350)
    bar(bin_l, count,'hist') ;
%         [count_max, ind] = max(count);
    [count_s,ind] = sort(count,2,'descend') ;
%     bg = bin_l(ind(2)) ;
    hold on
    plot(Tab*ones(1,count_s(1)+1), [0:round(count_s(1))], 'r--', 'linewidth', 2);  % varying D2/D1
    hold off
% print(350 ,'-dpng','-r300', [fig_path,num2str(fig_num, '%03d'),'.png']) ; fig_num = fig_num +1 ;

IabOtsuMask = im2bw(Iab_nobg,Tab+(params.otsuCorrectFrac*Tab)); %Corrected Otsu to reduce threshold
% IabOtsuMask = imfill(IabOtsuMask,'holes');
IabOtsuMaskNuc = false(size(IabOtsuMask)) ;
if params.nucRm == 1 ;
    IabOtsuMaskNuc = params.NucMask ;
    IabOtsuMask(IabOtsuMaskNuc)=0 ;
else
end

figure(8)
imshow(IabOtsuMask,[], 'InitialMagnification', 'fit');
IabOtsuMask_perim = bwperim(IabOtsuMask);
Iab_ad_perim = imoverlay(Iab_ad, IabOtsuMask_perim, [1 .3 .3]);

figure(9)
% subplot(2,2,3)
imshow(Iab_ad_perim,[], 'InitialMagnification', 'fit');

%% watershed 
%%watershed doesn't work well for mask of small objects as synapses. Apply wartershed to the original image instead 
Iab_maxs = imextendedmax(Iab_ad,  0.001);
Iab_overlay_max = imoverlay(Iab_ad,Iab_maxs, [0.3 1 .3]);

figure(11)
imshow(Iab_overlay_max,[], 'InitialMagnification', 'fit');

Iab_com = imcomplement(Iab_ad);
Iab_com = imimposemin(Iab_com, Iab_maxs);
figure(12)
imshow(Iab_com,[], 'InitialMagnification', 'fit');
Iab_shed = watershed(Iab_com);


Iab_shed_perim = imoverlay(Iab_ad, Iab_shed==0, [1 .3 .3]);

figure(13)
imshow(Iab_shed_perim,[], 'InitialMagnification', 'fit');

Iab_shed(Iab_shed==1) = 0; %make background zero.
Iab_shed(Iab_shed>1) = 1; %make foreground one.
Iab_shed = logical(Iab_shed); %convert watershed mask to logical.
Iab_shed = imreconstruct(Iab_maxs,Iab_shed);
abMask = Iab_shed & IabOtsuMask ;

IabMask_perim = bwperim(abMask);
Iab_shed_perim = imoverlay(Iab_ad, IabMask_perim, [1 .3 .3]);

figure(14)
% subplot(2,2,4)
imshow(Iab_shed_perim,[], 'InitialMagnification', 'fit');

Imonta = cat(4, imoverlay(Iab_ad, false(size(Iab_ad)), [0 0 0]),...
    imoverlay(IabOtsuMaskNuc, false(size(Iab_ad)), [0 0 0]),...
    Iab_ad_perim,Iab_shed_perim) ;
figure(101)
montage(Imonta) ;
set(gcf, 'position', [1921         121        1920        1006])
end        

function [MCCmarker, MCCab] = mander(Iab, Imarker, abMask, markerMask)
MCCmarker = sum(Imarker(markerMask & abMask))/sum(Imarker(markerMask));
MCCab = sum(Iab(markerMask & abMask))/sum(Iab(abMask));
end

function [pcc_no_nuc] = PCC_no_nuc(Iab, Imarker, nucMask)
pcc_no_nuc = corr(Iab(~nucMask), Imarker(~nucMask)) ;
end