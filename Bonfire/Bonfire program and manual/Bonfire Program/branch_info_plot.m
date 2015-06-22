function branch_info_plot(branch_total,condition_list,vect,scheme)

% Description:
%   Called by bonfire_results.  Creates graphical outputs for order-specific segmental lenght and number data.
% 
% Input:
%   branch_total -      an array consisting of two smaller matrixes of process number data {1} and length data {2}.  Each is a G x C x D x S arrays
%                       containing order-specific average lengths and numbers of all processes in the three groups, where G is the order-specific
%                       group, C is the condition number, D indicates whether it is data (D=1) or STE of the data(D=2), and S indicates the labeling
%                       scheme used) 
%   condition_list -    the names of the conditions included in analysis (for use in the figure legends)
%   vect -              vector describing the order-level cutoffs for 
%   scheme -            a number 1-3 indicating which order labeling scheme is being used.
% 
% Output:
%   Graphical - displays the order-specific average process length and average number of processes per cell.
% 

x_data = [];
x_mod = [];

subplot(2,1,1); hold on;
bar_width = .65/size(branch_total{1}(:,:,1,scheme),2);
x_base = 1:size(branch_total{1}(:,:,1,scheme),1);
color_ind = gray_cl(size(branch_total{1}(:,:,1,scheme),2));

for ii = 1:size(branch_total{1}(:,:,1,scheme),2);
    x_mod = (-.65/2+1/2*bar_width + (ii-1)*bar_width);
    x_data(ii,:) = x_base + x_mod;
    bar(x_data(ii,:),branch_total{1}(:,ii,1,scheme),'BarWidth',bar_width,'FaceColor',color_ind(ii,:));
end

for qq = 1:size(branch_total{1}(:,:,1,scheme),2);
    errorbar(x_data(qq,:),branch_total{1}(:,qq,1,scheme),branch_total{1}(:,qq,2,scheme),'ko');
end

legend(condition_list,'Location','North'); legend boxoff;
ylabel('# of Processes/Cell');
set(gca,'XTick',[x_base])
set(gca,'XTickLabel',{['Order < ' num2str(vect(scheme,1))] ; [num2str(vect(scheme,1)) ' =< Order < ' num2str(vect(scheme,2))] ; [num2str(vect(scheme,2)) ' =< Order']});

if scheme == 1; title('Average Process Number/Cell by Order - Centrifugal (Inside-Out) Labeling Scheme');
elseif scheme == 2; title('Average Process Number/Cell and Process Length by Order - Root, Intermediate, Terminal (RIT) Labeling Scheme');
elseif scheme == 3; title('Average Process Number/Cell and Process Length by Order - Centripetal (Tips-In) Labeling Scheme');
end

x_data = [];
x_mod = [];

subplot(2,1,2); hold on;
bar_width = .65/size(branch_total{2}(:,:,1,scheme),2);
x_base = [1 2 3];
color_ind = gray_cl(size(branch_total{2}(:,:,1,scheme),2));

for ii = 1:size(branch_total{2}(:,:,1,scheme),2);
    x_mod = (-.65/2+1/2*bar_width + (ii-1)*bar_width);
    x_data(ii,:) = x_base + x_mod;
    bar(x_data(ii,:),branch_total{2}(:,ii,1,scheme),'BarWidth',bar_width,'FaceColor',color_ind(ii,:));
end

for qq = 1:size(branch_total{2}(:,:,1,scheme),2);
    errorbar(x_data(qq,:),branch_total{2}(:,qq,1,scheme),branch_total{2}(:,qq,2,scheme),'ko');
end

ylabel('Average Length of Processes (um)');
set(gca,'XTick',[1 2 3])
set(gca,'XTickLabel',{['Order < ' num2str(vect(scheme,1))] ; [num2str(vect(scheme,1)) ' =< Order < ' num2str(vect(scheme,2))] ; [num2str(vect(scheme,2)) ' =< Order']});