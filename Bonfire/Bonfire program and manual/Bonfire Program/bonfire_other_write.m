function bonfire_other_write(T_B_num,directory_root,condition_name,cell_list)

% Description:
%   Called by bonfire_export.  Writes the non-order-specific morphological information to an excel workbook.
% 

summary = {'Cell Name';'Number of Branch Points';'Number of Terminal Points'};
    
for ii = 1:size(T_B_num,2);
    summary{1,ii+1} = cell_list(ii,:);
    summary{2,ii+1} = T_B_num(1,ii);
    summary{3,ii+1} = T_B_num(2,ii);
end

xlswrite([directory_root '\' condition_name '_Scheme-Independent.xls'],summary,'Terminal & Branch Point Count');