function bonfire_export

% Description:
%   STEP 5 of bonfire analysis.  These scripts export the results of the bonfire analysis to an excel workbook containing the order-specific and
%   whole-cell information for each labeling scheme
% 
% Input:
%   Prompts the user to identify a target condition folder, and uses the CellName_Output.mat files in it as the source for its raw data
% 
% Output:
%   Excel Workbooks -   4 excel workbooks (3 for the three different labeling schemes and 1 for scheme-independent data) containing aggregate data for
%                       the condition as well as data for each cell. 
% 

[N ring_start r_inc pix_conv scale_factor vect] = bonfire_parameters;
directory_root = 1;
condition_list = [];

while directory_root ~= 0;

    directory_root = uigetdir('','Pick a folder you want included in the results display.  Press "Cancel" if there are no more folders to include');
    waitbar_master = waitbar(0,'EXPORTING TO EXCEL');
    condition_name = directory_root(1,max(find(directory_root == '\')+1):end);
    condition_list = strvcat(condition_list,condition_name);
    if directory_root == 0;
        return
    end
    
%     Build the list of cells that are in the selected ConditionName folder
    A = dir(directory_root);
    cell_list = [];
    for ii = 3:size(A,1);
        if getfield(A,{ii,1},'isdir') == 1;
            cell_list = strvcat(cell_list,getfield(A,{ii,1},'name'));
        else
        end
    end
    
    for qq = 1:size(cell_list,1);
        load([directory_root,'\',strcat(cell_list(qq,:)),'\Cell_',strcat(cell_list(qq,:)),'_Output.mat']);
        sholl_array = cell_info{4};
        p_SWC{qq} = cell_info{3};
        SWC = cell_info{2};
        
%         Group the order-specific Sholl information for each cell into a single N x Q x G matrix for each of the ordering schemes, where N is the
%         number of Sholl rings, Q is the cell number, and G is a number 1-3 indicating group number for the purposes of order-specific analysis.  One
%         such matrix is created for each labeling scheme.
        sholl_cell_list(:,qq) = sholl_array{3}(:,1);
        sholl_Sc1_list(:,qq,:) = swc_sholl_breakdown(sholl_array{2},vect(1,:));
        sholl_Sc2_list(:,qq,:) = swc_sholl_breakdown(sholl_array{3},vect(2,:));
        sholl_Sc3_list(:,qq,:) = swc_sholl_breakdown(sholl_array{4},vect(3,:));
        
%         Group the order-specific length information for each cell into a single N x Q x G matrix for each of the ordering schemes, where N is the
%         number of Sholl rings, Q is the cell number, and G is a number 1-3 indicating group number for the purposes of order-specific analysis.  One
%         such matrix is created for each labeling scheme.
        lengths_Sc1_list{:,qq,:} = swc_lengths_breakdown(p_SWC{qq},4,vect(1,:));
        lengths_Sc2_list{:,qq,:} = swc_lengths_breakdown(p_SWC{qq},5,vect(2,:));
        lengths_Sc3_list{:,qq,:} = swc_lengths_breakdown(p_SWC{qq},6,vect(3,:));
        
        T_B_num(1,qq) = length(find(SWC(:,2) == 5));
        T_B_num(2,qq) = length(find(SWC(:,2) == 6));
    end

    warning off MATLAB:xlswrite:AddSheet;
    
    waitbar_steps = 7;
    
%     Write the segmental length and number information to the 3 order-specific excel workbooks
    waitbar(1/waitbar_steps,waitbar_master); bonfire_branch_write(lengths_Sc1_list,'Center-Out',directory_root,condition_name,cell_list,vect(1,:));
    waitbar(2/waitbar_steps,waitbar_master); bonfire_branch_write(lengths_Sc2_list,'RIT',directory_root,condition_name,cell_list,vect(2,:));
    waitbar(3/waitbar_steps,waitbar_master); bonfire_branch_write(lengths_Sc3_list,'Tips-In',directory_root,condition_name,cell_list,vect(3,:));
 
%     Write the Sholl information to the 3 order-specific excel workbooks
    waitbar(4/waitbar_steps,waitbar_master); bonfire_sholl_write(sholl_array{1},sholl_cell_list,sholl_Sc1_list,'Center-Out',directory_root,condition_name,cell_list,vect(1,:));
    waitbar(5/waitbar_steps,waitbar_master); bonfire_sholl_write(sholl_array{1},sholl_cell_list,sholl_Sc2_list,'RIT',directory_root,condition_name,cell_list,vect(2,:));
    waitbar(6/waitbar_steps,waitbar_master); bonfire_sholl_write(sholl_array{1},sholl_cell_list,sholl_Sc3_list,'Tips-In',directory_root,condition_name,cell_list,vect(3,:));
    
%     Create the labeling scheme-independent workbook
    waitbar(7/waitbar_steps,waitbar_master); bonfire_other_write(T_B_num,directory_root,condition_name,cell_list);
    
    close(waitbar_master);
    
    clear sholl_cell_list sholl_Sc1_list sholl_Sc2_list sholl_Sc3_list;
    clear lengths_Sc1_list lengths_Sc2_list lengths_Sc3_list;
    clear T_B_num;
end
close(waitbar_master);