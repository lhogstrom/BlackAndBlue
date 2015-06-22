function bonfire_sholl_write(ring_dist,sholl_cell_list,sholl_scheme_list,scheme_name,directory_root,condition_name,cell_list,vect)

% Description:
%   Called by bonfire_export.  Writes the Sholl information to the order-specific workbooks.
% 
% Input:
%   ring_dist -             a vecotr containing the radii for the Sholl circles
%   sholl_cell_list -       a N x Q vector containing the number of total Sholl intersection (non-order-specific) for each cell, where N is the number
%                           of Sholl rings, and Q is the number of cells
%   scholl_scheme_list -    a N x Q x G matrix where N is the number of Sholl rings, Q is the cell number, and G is a number 1-3 indicating group
%                           number for the purposes of order-specific analysis.  
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

total = [ring_dist' sholl_cell_list(:,:)];
group_1 = [ring_dist' sholl_scheme_list(:,:,1)];
group_2 = [ring_dist' sholl_scheme_list(:,:,2)];
group_3 = [ring_dist' sholl_scheme_list(:,:,3)];

scaffold{1} = 'Distance From Soma';
for ii = 1:size(cell_list,1);
    scaffold{ii+1} = cell_list(ii,:);
end

for qq = 1:size(cell_list,1)+1;
    total_xls{1,qq} = scaffold{qq};
    for jj = 1:size(total,1);
        total_xls{jj+1,qq} = total(jj,qq);
    end
    
    group_1_xls{1,qq} = scaffold{qq};
    for jj = 1:size(total,1);
        group_1_xls{jj+1,qq} = group_1(jj,qq);
    end
    
    group_2_xls{1,qq} = scaffold{qq};
    for jj = 1:size(total,1);
        group_2_xls{jj+1,qq} = group_2(jj,qq);
    end
    
    group_3_xls{1,qq} = scaffold{qq};
    for jj = 1:size(total,1);
        group_3_xls{jj+1,qq} = group_3(jj,qq);
    end
end

xlswrite([directory_root '\' condition_name '_' scheme_name '.xls'],total_xls,'Sholl Ints.; Total','A1');
xlswrite([directory_root '\' condition_name '_' scheme_name '.xls'],group_1_xls,['Sholl Ints.; Order < ' num2str(vect(1))],'A1');
xlswrite([directory_root '\' condition_name '_' scheme_name '.xls'],group_2_xls,['Sholl Ints.; ' num2str(vect(1)) ' =< Order < ' num2str(vect(2))],'A1');
xlswrite([directory_root '\' condition_name '_' scheme_name '.xls'],group_3_xls,['Sholl Ints.; Order >= ' num2str(vect(2))],'A1');