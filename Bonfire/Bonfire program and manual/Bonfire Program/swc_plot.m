function swc_plot(SWC)

% Description:
%   Called by bonfire.  Plots the potition and connectivity of the neuron described by matrix SWC.
% 
% Input:
%   SWC -   neuronal morphology description in SWC format
% 
% Output:
%   Graphical - display of neuronal morphology
% 

R = find(SWC(:,2) == 1);
scatter(SWC(R,3),SWC(R,4),1.5*pi*SWC(R,6).^2,'g','filled');

D = find(SWC(:,2) == 3);
scatter(SWC(D,3),SWC(D,4),1.5*pi*SWC(D,6).^2,'m');

B = find(SWC(:,2) == 5);
scatter(SWC(B,3),SWC(B,4),5*pi*SWC(B,6).^2,'y','filled');

T = find(SWC(:,2) == 6);
scatter(SWC(T,3),SWC(T,4),5*pi*SWC(T,6).^2,'r','filled');

for ii = 2:size(SWC,1);
    x1 = SWC(ii,3);
    y1 = SWC(ii,4);
    x0 = SWC(SWC(ii,7),3);
    y0 = SWC(SWC(ii,7),4);
    plot([x1 x0],[y1 y0],'m')
end