function [condition_array] = bonfire_loadresults(vect1,vect2,vect3)

% Description:
%   Called by bonfire_results.  Prompts the user to identify the target folders that will be included in the display.  
% 
% Input:
%   vect1 - a 1 x 2 matrix specifying the dividing boundaries used to segment data into groups for order-specific analysis (labeling scheme 1)
%   vect2 - a 1 x 2 matrix specifying the dividing boundaries used to segment data into groups for order-specific analysis (labeling scheme 2)
%   vect3 - a 1 x 2 matrix specifying the dividing boundaries used to segment data into groups for order-specific analysis (labeling scheme 3)
%   Prompts the user to identify targer folders analyzed previously with bonfire steps 1-4, and searches in these folders for data on cellular
%   morphology.  The script then reads in the CellName_Output.mat file, yielding the following;
%       -sholl_array -  
%       -p_SWC -        
%       -SWC -          
%       
% Output:
%   condition_array -   a structured array containing summary data for the condition on the number and STE of all the Sholl curves and other branching
%                       metrics measured during analysis
% 


% Initialize variables for packaging into condition_array 
iii = 1;
directory_root = 1;
condition_list = [];
p_SWC_temp = [];
sholl_total = [];
sholl_detail = [];
T_B_total = [];
N_list = [];

while directory_root ~= 0;
%     Until the user presses esc. or cancel, the program will repeatedly ask for a target folder.  This builds the list of conditions that are
%     included in this particular data display.
    directory_root = uigetdir('','Pick a folder you want included in the results display.  Press "Cancel" if there are no more folders to include');
    condition_name = directory_root(1,max(find(directory_root == '\')+1):end);
    condition_list = strvcat(condition_list,condition_name);
    if directory_root == 0;
        return
    end
    

%     Build the list of cells that are included in the condition folder

    A = dir(directory_root);
    cell_list = [];
    for ii = 3:size(A,1);
        if getfield(A,{ii,1},'isdir') == 1;
            cell_list = strvcat(cell_list,getfield(A,{ii,1},'name'));
        else
        end
    end
    
%     Compile all the information about a condition by walking through each cell in the folder and collecting the relevane statistics and
%     measurements:
    for qq = 1:size(cell_list,1);
        load([directory_root,'\',strcat(cell_list(qq,:)),'\Cell_',strcat(cell_list(qq,:)),'_Output.mat']);
        sholl_array = cell_info{4};
        p_SWC{qq} = cell_info{3};
        SWC = cell_info{2};
        
%         Build and N x qq matrixes, where qq is the number of cells in the condition, which has the total Sholl profile for each of the qq cells
        sholl_cell_list(:,qq) = sholl_array{3}(:,1);
        
%         Group the order-specific Sholl information for each cell into a single N x Q x G matrix for each of the ordering schemes, where N is the
%         number of Sholl rings, Q is the cell number, and G is a number 1-3 indicating group number for the purposes of order-specific analysis.  One
%         such matrix is created for each labeling scheme.
        sholl_Sc1_list(:,qq,:) = swc_sholl_breakdown(sholl_array{2},vect1);
        sholl_Sc2_list(:,qq,:) = swc_sholl_breakdown(sholl_array{3},vect2);
        sholl_Sc3_list(:,qq,:) = swc_sholl_breakdown(sholl_array{4},vect3);
        
%         Group the order-specific length information for each cell into a single N x Q x G matrix for each of the ordering schemes, where N is the
%         number of Sholl rings, Q is the cell number, and G is a number 1-3 indicating group number for the purposes of order-specific analysis.  One
%         such matrix is created for each labeling scheme.
        lengths_Sc1_list{:,qq,:} = swc_lengths_breakdown(p_SWC{qq},4,vect1);
        lengths_Sc2_list{:,qq,:} = swc_lengths_breakdown(p_SWC{qq},5,vect2);
        lengths_Sc3_list{:,qq,:} = swc_lengths_breakdown(p_SWC{qq},6,vect3);
        
%         T_B_num is a 2 x qq matrix, where qq is the number of cells in the condition.  The first row is the number of branch points, and the second
%         row is the number of terminal points.
        T_B_num(1,qq) = length(find(SWC(:,2) == 5));
        T_B_num(2,qq) = length(find(SWC(:,2) == 6));
        
%         The total number of processes, their total length, and their average length are calculated from the cell's p_SWC matrix
        proc_num_each_cell(qq) = size(p_SWC{qq},1);
        proc_av_length_each_cell(qq) = mean(p_SWC{qq}(:,8));
        cable_length_each_cell(qq) = sum(p_SWC{qq}(:,8));
    end
    
    
    
%     Compile all the information on each condition:

    ring_dist = sholl_array{1};
    N_list(iii) = size(cell_list,1);
    
%     Assembling the data for the standard Sholl analysis.  New sholl_av_new matrixes are constructed for each condition, consisting of the
%     information for all the cells in that condition. These are then compiled into the sholl_total matix, an N x C x 2 array where the first
%     dimension is the number of Sholl rings, the second dimension corresponds to the condition, and the third dimension is either the data (D3 = 1),
%     or the STE of the data (D3 = 2)
    sholl_av_new = [];
    sholl_av_new(:,1,1) = mean(sholl_cell_list,2);
    sholl_av_new(:,1,2) = std(sholl_cell_list,0,2)/sqrt(size(sholl_cell_list,2));
    sholl_total(:,iii,:) = sholl_av_new;

%     The order-specific Sholl information is compiled in a similar fashion for each of the three labeling schemes.  a sholl_Gav_new matrix is build
%     for each condition, and compiled into the sholl_detail matrix.  The sholl_detail matrix is an N x C x G x D x S matrix, where N is the number of
%     Sholl rings, C is the number of conditions, G is the oder-group (buckets 1-3 as defined by vect), D is either the data (D=1) or the STE of the
%     data (D=2), and S is the labeling scheme.
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

%     Generate the whole-cell (non-order-specific) information about process length and number in the form of a D x T x C matrix, where D indicates
%     data (D=1) vs STE of the data (D=2), T indicates the type of data (1 = average segment number per cell, 1 = average segment length per cell, and
%     3 = average total cable length per cell), and C indicates the condition number
    branch_summary(1,:,iii) = [mean(proc_num_each_cell) mean(proc_av_length_each_cell) mean(cable_length_each_cell)];
    branch_summary(2,:,iii) = [std(proc_num_each_cell)/sqrt(length(proc_num_each_cell)) std(proc_av_length_each_cell)/sqrt(length(proc_av_length_each_cell)) std(cable_length_each_cell)/sqrt(length(cable_length_each_cell))];

%     Generate the G x C x D x S arrays containing order-specific average lengths and numbers of all processes in the three groups, where G is the
%     order-specific group, C is the condition number, D indicates whether it is data (D=1) or STE of the data(D=2), and S indicates the labeling
%     scheme used)
    [lengths_total(:,iii,:,1) num_proc_total(:,iii,:,1)] = branch_condition_summary_gen(lengths_Sc1_list,cell_list);
    [lengths_total(:,iii,:,2) num_proc_total(:,iii,:,2)] = branch_condition_summary_gen(lengths_Sc2_list,cell_list);
    [lengths_total(:,iii,:,3) num_proc_total(:,iii,:,3)] = branch_condition_summary_gen(lengths_Sc3_list,cell_list);
    branch_total{1} = num_proc_total;
    branch_total{2} = lengths_total;
    
%     Mean and STE of the number of terminal and branch points per cell in the form of a T x C x D matrix, where T indicated branch points (T=1) vs.
%     terminal points (T=2), C indicates the condition number, and D indicates data (D=1) vs. STE of the data (D=2).
    T_B_total(:,iii,1) = mean(T_B_num,2);
    T_B_total(:,iii,2) = std(T_B_num,0,2)/sqrt(size(T_B_num,2));
    
%     Consolidate all the information into the condition_array for transfer to bonfire_results
    condition_array(1,1) = {ring_dist};
    condition_array(1,2) = {sholl_total};
    condition_array(1,3) = {sholl_detail};
    condition_array(1,4) = {branch_total};
    condition_array(1,5) = {T_B_total};
    condition_array(1,7) = {branch_summary};
    condition_array(2,1) = {condition_list};
    condition_array(2,2) = {N_list};
    
%     Advance the condition index by 1 (iii), and clear the arrays and matrices used to store cell data so they do not carry over between conditions
    iii = iii + 1;
    clear p_SWC;
    clear sholl_cell_list sholl_Sc1_list sholl_Sc2_list sholl_Sc3_list;
    clear lengths_Sc1_list lengths_Sc2_list lengths_Sc3_list;
    clear T_B_num proc_num_each_cell proc_av_length_each_cell cable_length_each_cell;
end

