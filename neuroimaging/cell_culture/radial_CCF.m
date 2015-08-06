function [C_rad, C0, pval] = radial_CCF(im5)
imA = im5(:,:,1) ;
imB = im5(:,:,2) ;
C = normxcorr2(imA, imB) ;
% figure(3), surf(C), shading flat
%%%
[ypeak, xpeak] = find(C==max(C(:)));
%
num_th = 64;
% [r th] = meshgrid([0:size(im5,1)/512:(size(im5,1)*(1-1/512))], linspace(0, 2*pi, num_th));% polar coord meshgrid. 5*r points
[r, th] = meshgrid([0:(size(im5,1)-1)], linspace(0, 2*pi, num_th));% polar coord meshgrid. 5*r points
X = r.*cos(th)+ size(im5,2); % convert mesh to cartesian coord
Y = r.*sin(th)+ size(im5,1);

C_rad_blk = interp2(C,X,Y, 'cubic');
C_rad = mean(C_rad_blk,1) ;

[C0, pval] = corr(double(imA(:)), double(imB(:))) ;
end