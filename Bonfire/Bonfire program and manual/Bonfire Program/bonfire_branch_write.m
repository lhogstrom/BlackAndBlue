function bonfire_branch_write(lengths_scheme_list,scheme_name,directory_root,condition_name,cell_list,vect)

% lengths_scheme_list = lengths_Sc1_list;
% scheme_name = 'Center-Out';
% directory_root = directory_root;
% condition_name = condition_name;
% cell_list = cell_list;
% vect = vect(1,:);

% Description:
%   Called by bonfire_export.  Writes the segmental length and number information to the order-specific workbooks.
% 
% Input:
%   lengths_scheme_list -   an N x Q x G matrix for each of the ordering schemes, where N is the number of Sholl rings, Q is the cell number, and G is
%                           a number 1-3 indicating group number for the purposes of order-specific analysis.  One such matrix is created for each
%                           labeling scheme. 
%   scheme_name -           a string declaring the name of the labeling scheme used
%   directory_root -        the path to the target directory identified by the user
%   condition_name -        the name of the target directory
%   cell_list -             an array containing the names of all cells included in the target folder
%   vect -                  a vector identifying the order boundaries for created the groups in order-specific analysese
% 
% Output:
%   Excel Workbooks -   3 excel workbooks (for each of the three different labeling schemes) containing aggregate data for the condition as well as
%                       data for each cell.
% 

summary = [];
group_1_xls = {};
group_2_xls = {};
group_3_xls = {};
total_lengths_list = {};

for qq = 1:size(cell_list,1);
    
    group_1_xls{1,qq} = cell_list(qq,:);
    for jj = 1:length(lengths_scheme_list{qq}{:,1,1});
        group_1_xls{jj+1,qq} = lengths_scheme_list{qq}{:,:,1}(jj);
    end
    
    group_2_xls{1,qq} = cell_list(qq,:);
    for jj = 1:length(lengths_scheme_list{qq}{:,1,2});
        group_2_xls{jj+1,qq} = lengths_scheme_list{qq}{:,:,2}(jj);
    end
    
    group_3_xls{1,qq} = cell_list(qq,:);
    for jj = 1:length(lengths_scheme_list{qq}{:,1,3});
        group_3_xls{jj+1,qq} = lengths_scheme_list{qq}{:,:,3}(jj);
    end

    total_list_xls{1,qq} = cell_list(qq,:);
    total_lengths_list{qq} = [lengths_scheme_list{qq}{:,1,1} ; lengths_scheme_list{qq}{:,1,2} ; lengths_scheme_list{qq}{:,1,3}];
    for jj = 1:length(total_lengths_list{qq});
        total_list_xls{jj+1,qq} = total_lengths_list{qq}(jj);
    end
end

summary = {'Cell Name';['Number of Segs.; Order < ' num2str(vect(1))];['Number of Segs.; ' num2str(vect(1)) ' =< Order < ' num2str(vect(2))];['Number of Segs.; Order >= ' num2str(vect(2))];'';'Number of Segs.; Total'};
for ii = 1:size(cell_list,1);
    summary{1,ii+1} = cell_list(ii,:);
    summary{2,ii+1} = length(lengths_scheme_list{ii}{:,:,1});
    summary{3,ii+1} = length(lengths_scheme_list{ii}{:,:,2});
    summary{4,ii+1} = length(lengths_scheme_list{ii}{:,:,3});
    summary{5,ii+1} = '';
    summary{6,ii+1} = length(total_lengths_list{ii});
end

xlswrite([directory_root '\' condition_name '_' scheme_name '.xls'],summary,'Seg. Lengths Summary');
xlswrite([directory_root '\' condition_name '_' scheme_name '.xls'],total_list_xls,'Seg. Lengths Total');
xlswrite([directory_root '\' condition_name '_' scheme_name '.xls'],group_1_xls,['Seg.Lengths; Order < ' num2str(vect(1))]);
xlswrite([directory_root '\' condition_name '_' scheme_name '.xls'],group_2_xls,['Seg.Lengths; ' num2str(vect(1)) ' =< Order < ' num2str(vect(2))]);
xlswrite([directory_root '\' condition_name '_' scheme_name '.xls'],group_3_xls,['Seg.Lengths; Order >= ' num2str(vect(2))]);