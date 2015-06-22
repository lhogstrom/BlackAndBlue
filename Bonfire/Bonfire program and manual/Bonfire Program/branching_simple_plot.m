function branching_simple_plot(T_B_total,branch_summary,condition_list)

% Description:
%   Called by bonfire_results.  Creates graphical output for cell-level (non-order-specific) information on segmental length and number.
% 
% Input:
%   T_B_total -         a T x C x D matrix, where T indicated branch points (T=1) vs. terminal points (T=2), C indicates the condition number, and D
%                       indicates data (D=1) vs. STE of the data (D=2). 
%   branch_summary -    a D x T x C matrix, where D indicates data (D=1) vs STE of the data (D=2), T indicates the type of data (1 = average segment
%                       number per cell, 1 = average segment length per cell, and 3 = average total cable length per cell), and C indicates the
%                       condition number 
%   condition_list -    the names of the conditions included in analysis (for use in the figure legends)
% 
% Output:
%   Graphical display of non-order-specific information, including the number of branch and terminal points per cell, the number of neurite segments
%   per cell, the average segment length per cell, and the average total arbor length per cell for each of the conditions selected
% 

x_data = [];
subplot(2,1,1); cla; hold on;
bar_width = .65/size(T_B_total,2);
x_base = [1 2];

color_ind = gray_cl(size(T_B_total,2));

for ii = 1:size(T_B_total,2);
    x_mod = (-.65/2+1/2*bar_width + (ii-1)*bar_width);
    x_data(ii,:) = x_base + x_mod;
    bar(x_data(ii,:),T_B_total(:,ii,1),'BarWidth',bar_width,'FaceColor',color_ind(ii,:));
end

for qq = 1:size(T_B_total,2);
    errorbar(x_data(qq,:),T_B_total(:,qq,1),T_B_total(:,qq,2),'ko');
end

legend(condition_list,'Location','NorthWest'); legend boxoff;
ylabel('# of Branch or Terminal Points');
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',{'Branch Points' ; 'Terminal Points'});
title('Average Number of Branch Points and Terminal Points Per Cell');

x_data = [];
subplot(2,3,4); cla; hold on;
bar_width = .65/size(branch_summary,3);
x_base = [1];

color_ind = gray_cl(size(branch_summary,3));

for ii = 1:size(branch_summary,3);
    x_mod = (-.65/2+1/2*bar_width + (ii-1)*bar_width);
    x_data(ii,:) = x_base + x_mod;
    bar(x_data(ii,:),branch_summary(1,1,ii),'BarWidth',bar_width,'FaceColor',color_ind(ii,:));
end

for ii = 1:size(branch_summary,3);
    errorbar(x_data(ii,:),branch_summary(1,1,ii),branch_summary(2,1,ii),'ko');
end

ylabel('# of Processes Per Cell');
set(gca,'XTick',[1])
set(gca,'XTickLabel',{''});
title('Number of Processes');


x_data = [];
subplot(2,3,5); cla; hold on;
bar_width = .65/size(branch_summary,3);
x_base = [1];

color_ind = gray_cl(size(branch_summary,3));

for ii = 1:size(branch_summary,3);
    x_mod = (-.65/2+1/2*bar_width + (ii-1)*bar_width);
    x_data(ii,:) = x_base + x_mod;
    bar(x_data(ii,:),branch_summary(1,2,ii),'BarWidth',bar_width,'FaceColor',color_ind(ii,:));
end

for ii = 1:size(branch_summary,3);
    errorbar(x_data(ii,:),branch_summary(1,2,ii),branch_summary(2,2,ii),'ko');
end

ylabel('Average Length of Processes Per Cell');
set(gca,'XTick',[1])
set(gca,'XTickLabel',{''});
title('Average Length of Processes');


x_data = [];
subplot(2,3,6); cla; hold on;
bar_width = .65/size(branch_summary,3);
x_base = [1];

color_ind = gray_cl(size(branch_summary,3));

for ii = 1:size(branch_summary,3);
    x_mod = (-.65/2+1/2*bar_width + (ii-1)*bar_width);
    x_data(ii,:) = x_base + x_mod;
    bar(x_data(ii,:),branch_summary(1,3,ii),'BarWidth',bar_width,'FaceColor',color_ind(ii,:));
end

for ii = 1:size(branch_summary,3);
    errorbar(x_data(ii,:),branch_summary(1,3,ii),branch_summary(2,3,ii),'ko');
end

ylabel('Total Cable Length Per Cell');
set(gca,'XTick',[1])
set(gca,'XTickLabel',{''});
title('Total Cable Length');