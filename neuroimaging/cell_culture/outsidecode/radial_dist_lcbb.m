function [rbin]=rdfcalc(C,xlim,ylim)

%This file takes a file containing the co-ordinates of the centers as
%input, and finds the rdf

%xlim=512; % The maximum x co-ordinate of the image
%ylim=512; % The maximum y co-ordinate of the image

n=size(C,1);

rmin=1;
rmax=100;
dr=2;

rvecarray=rmin:dr:rmax;

m=size(rvecarray,2);

rbin=zeros(m,2);
rbin(:,1)=rvecarray;
R = 

for i=1:n % i will the index for the reference object 
    
    rvec=rvecarray(j);
    
    for j=i+1:n % test all pairs relative to reference object
        x1=C(i,1);
        y1=C(i,2);
        bini=0;

        % calculuate radial distance
        rk= sqrt((C(k,1)-C(i,1))^2 +(C(k,2)-C(i,2))^2);
        R(i,j) = rk

%         if rk>= rvec && rk<=(rvec+dr)
%             bini=bini+1;
%         end
        
        
        
    end
end

% hist(R(:))