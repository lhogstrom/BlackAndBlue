function [condition_array] = bonfire_loadresults(vect1,vect2,vect3)
% vect = [2 3; 2 3; 2 3];
% vect1 = vect(1,:);
% vect2 = vect(2,:);
% vect3 = vect(3,:);

% Description:
%   Called by bonfire_results.  Prompts the user to identify the target folders that will be included in the display.  
% 
% Input:
%   vect1 - a 1 x 2 matrix specifying the dividing boundaries used to segment data into groups for order-specific analysis (labeling scheme 1)
%   vect2 - a 1 x 2 matrix specifying the dividing boundaries used to segment data into groups for order-specific analysis (labeling scheme 2)
%   vect3 - a 1 x 2 matrix specifying the dividing boundaries used to segment data into groups for order-specific analysis (labeling scheme 3)
%   Prompts the user to identify targer folders analyzed previously with bonfire steps 1-4, and searches in these folders for data on cellular
%   morphology
% 
% Output:
%   condition_array -   a structured array containing summary data for the condition on the number and STE of all the Sholl curves and other branching
%                       metrics measured during analysis
% 


% Initialize variables for packaging into condition_array 
iii = 1;
directory_root = 1;
condition_list = [];
p_SWC_total = {};
p_SWC_temp = [];
sholl_total = [];
sholl_detail = [];
T_B_total = [];
N_list = [];

while directory_root ~= 0;

    directory_root = uigetdir('','Pick a folder you want included in the results display.  Press "Cancel" if there are no more folders to include');
    condition_name = directory_root(1,max(find(directory_root == '\')+1):end);
    condition_list = strvcat(condition_list,condition_name);
    if directory_root == 0;
        return
    end
    
    A = dir(directory_root);
    cell_list = [];
    p_SWC_temp = [];
    for ii = 3:size(A,1);
        if getfield(A,{ii,1},'isdir') == 1;
            cell_list = strvcat(cell_list,getfield(A,{ii,1},'name'));
        else
        end
    end
    
    proc_num_each_cell = [];
    proc_av_length_each_cell = [];
    cable_length_each_cell = [];
    
    for qq = 1:size(cell_list,1);
        load([directory_root,'\',strcat(cell_list(qq,:)),'\Cell_',strcat(cell_list(qq,:)),'_Output.mat']);
        sholl_array = cell_info{4};
        p_SWC{qq} = cell_info{3};
        SWC = cell_info{2};
        
        sholl_cell_list(:,qq) = sholl_array{3}(:,1);
        sholl_Sc1_list(:,qq,:) = swc_sholl_breakdown(sholl_array{2},vect1);
        sholl_Sc2_list(:,qq,:) = swc_sholl_breakdown(sholl_array{3},vect2);
        sholl_Sc3_list(:,qq,:) = swc_sholl_breakdown(sholl_array{4},vect3);
        
        lengths_Sc1_list{:,qq,:} = swc_lengths_breakdown(p_SWC{qq},4,vect1);
        lengths_Sc2_list{:,qq,:} = swc_lengths_breakdown(p_SWC{qq},5,vect2);
        lengths_Sc3_list{:,qq,:} = swc_lengths_breakdown(p_SWC{qq},6,vect3);
        
        p_SWC_temp = [p_SWC_temp ; p_SWC{qq}];
        
        T_B_num(1,qq) = length(find(SWC(:,2) == 5));
        T_B_num(2,qq) = length(find(SWC(:,2) == 6));
        
        proc_num_each_cell(qq) = size(p_SWC{qq},1);
        proc_av_length_each_cell(qq) = mean(p_SWC{qq}(:,8));
        cable_length_each_cell(qq) = sum(p_SWC{qq}(:,8));
    end
    p_SWC_total{iii} = p_SWC_temp;
    ring_dist = sholl_array{1};
    N_list(iii) = size(cell_list,1);
    
    sholl_av_new = [];
    sholl_av_new(:,1,1) = mean(sholl_cell_list,2);
    sholl_av_new(:,1,2) = std(sholl_cell_list,0,2)/sqrt(size(sholl_cell_list,2));
    sholl_total(:,iii,:) = sholl_av_new;

    sholl_Gav_new = [];
    sholl_Gav_new(:,1,:,1) = mean(sholl_Sc1_list,2);
    sholl_Gav_new(:,1,:,2) = std(sholl_Sc1_list,0,2)/sqrt(size(sholl_Sc1_list,2));
    sholl_detail(:,iii,:,:,1) = sholl_Gav_new; 
    
    sholl_Gav_new = [];
    sholl_Gav_new(:,1,:,1) = mean(sholl_Sc2_list,2);
    sholl_Gav_new(:,1,:,2) = std(sholl_Sc2_list,0,2)/sqrt(size(sholl_Sc2_list,2));
    sholl_detail(:,iii,:,:,2) = sholl_Gav_new;

    sholl_Gav_new = [];
    sholl_Gav_new(:,1,:,1) = mean(sholl_Sc3_list,2);
    sholl_Gav_new(:,1,:,2) = std(sholl_Sc3_list,0,2)/sqrt(size(sholl_Sc3_list,2));
    sholl_detail(:,iii,:,:,3) = sholl_Gav_new;

    [lengths_total(:,iii,:,1) num_proc_total(:,iii,:,1)] = branch_condition_summary_gen(lengths_Sc1_list,cell_list);
    [lengths_total(:,iii,:,2) num_proc_total(:,iii,:,2)] = branch_condition_summary_gen(lengths_Sc2_list,cell_list);
    [lengths_total(:,iii,:,3) num_proc_total(:,iii,:,3)] = branch_condition_summary_gen(lengths_Sc3_list,cell_list);
    
    branch_total{1} = num_proc_total;
    branch_total{2} = lengths_total;
    
    T_B_total(:,iii,1) = mean(T_B_num,2);
    T_B_total(:,iii,2) = std(T_B_num,0,2)/sqrt(size(T_B_num,2));
    
    branch_summary(1,:,iii) = [mean(proc_num_each_cell) mean(proc_av_length_each_cell) mean(cable_length_each_cell)];
    branch_summary(2,:,iii) = [std(proc_num_each_cell)/sqrt(length(proc_num_each_cell)) std(proc_av_length_each_cell)/sqrt(length(proc_av_length_each_cell)) std(cable_length_each_cell)/sqrt(length(cable_length_each_cell))]; 
    
    each_cell_data{iii} = [proc_num_each_cell' proc_av_length_each_cell' cable_length_each_cell'];
    
    condition_array(1,1) = {ring_dist};
    condition_array(1,2) = {sholl_total};
    condition_array(1,3) = {sholl_detail};
    condition_array(1,4) = {branch_total};
    condition_array(1,5) = {T_B_total};
    condition_array(1,6) = {p_SWC_total};
    condition_array(1,7) = {branch_summary};
    condition_array(2,1) = {condition_list};
    condition_array(2,2) = {N_list};
    condition_array(3,1) = {each_cell_data};
    
    iii = iii + 1;
    clear p_SWC;
    clear sholl_cell_list sholl_Sc1_list sholl_Sc2_list sholl_Sc3_list;
    clear lengths_Sc1_list lengths_Sc2_list lengths_Sc3_list;
    clear T_B_num proc_num_each_cell proc_av_length_each_cell cable_length_each_cell;
end

