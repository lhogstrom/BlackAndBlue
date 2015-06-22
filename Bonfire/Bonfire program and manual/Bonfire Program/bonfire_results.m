function bonfire_results

% Description:
%   Displays the results of the
% 
% Input:
%   Prompts the user to identify a series of taret folders, containing the cell data that has been analyzed in steps 1-4 of the bonfire process up to
%   this point.  This step does not alter the data any at this point.
% 
% Output:
%   Graphical -     Displays a series of figures showing the results of the analysis for the folders selected at the beginning.  Figures include the
%                   data, and error bars represent the standard error of the mean.  Currently displays;
%       -Sholl analysis & order-specific Sholl analysis for three labeling schemes 
%       -Process number and length (for three labeling schemes)
%       -Number of terminal and branch points, total segment number, average segment length, and total cabel length 
% 

% Sets the bucket sizes for the three labeling schemes used (i.e., establishes which order ranges are incuded in group 1, 2, and 3 for the purposes of
% the order-specific analysis), and loads the data from all the cells in the selcted folders.
[N ring_start r_inc pix_conv scale_factor vect] = bonfire_parameters;
condition_array = bonfire_loadresults(vect(1,:), vect(2,:), vect(3,:));

% Unpacks the data from the array named condition_array, which is created by bonfire_loadresults as a way of easily getting the data from one place to
% another
ring_dist = condition_array{1,1};
sholl_total = condition_array{1,2};
sholl_detail = condition_array{1,3};
branch_total = condition_array{1,4};
T_B_total = condition_array{1,5};
branch_summary = condition_array{1,7};
condition_list = condition_array{2,1};
N_list = condition_array{2,2};

% Builds the list of condition names (i.e., the names of the folders selected for inclusion in the display), as well as the sample size for each
% condition.  This is used to provide an appropriate legend in each figure.
condition_list_temp = [];
for ii = 1:size(condition_list,1);
    new_line = [condition_list(ii,:) ' (N = ' num2str(N_list(ii)) ')'];
    condition_list_temp = strvcat(condition_list_temp,new_line);
end
condition_list = strcat(condition_list_temp);


% PLOTTING THE SHOLL DATA
window_size = [750 500];

% Plot the order-specific Sholl curves for each of the three labeling schemes.
for kk = 1:3;
    figure(10 + kk); clf; hold on; set(figure(10 + kk),'Position',[160+20*kk 170-20*kk window_size]);
    swc_sholl_summary(ring_dist,sholl_detail,kk,vect(kk,:));
    subplot(3,1,1); legend(condition_list); legend boxoff;
end

% Plot the standard Sholl curves for all conditions selected
figure(10); clf; hold on;
set(figure(10),'Position',[240 90 window_size]);
color_ind = gray_cl(size(sholl_total,2)); 
for ii = 1:size(sholl_total,2);
    errorbar(ring_dist,sholl_total(:,ii,1),sholl_total(:,ii,2),'color',color_ind(ii,:));
end
legend(condition_list); legend boxoff;
title('Sholl Analysis');
ylabel('Number of Intersections'); xlabel('Distance from Soma (um)')
axis tight;


% PLOTTING THE SEGMENTAL NUMBER AND LENGTH ANALYSIS
window_size = [750 500];

% Plot the oder-specific branching analysis data
for jj = 1:3;
    figure(20 + jj); clf; hold on; set(figure(20 + jj),'Position',[10+20*jj 160-20*jj window_size]);
    branch_info_plot(branch_total,condition_list,vect,jj);
end

% Plot the standard segmental number and length analysis data for all conditions selected
figure(20); clf; hold on;
set(figure(20),'Position',[90 80 window_size]);
branching_simple_plot(T_B_total,branch_summary,condition_list);