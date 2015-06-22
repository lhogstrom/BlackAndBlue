function [p_SWC] = p_degree_gen(p_SWC)

% Description:
%   Called by swc_pgen.  Modifies the p_SWC matrix to include the "degree" of each process (the eventual number of terminal tips associated with that
%   process)
% 
% Input:
%   p_SWC -     
% 
% Output:
%   p_SWC -     p_SWC matrix as before, including column 9 as the degree of each process
% 

% Identifies all tips that need to be accounted for and initializes housekeeping matrices and arrays
terminal_ind_list = find(p_SWC(:,2) == 1);
m = size(terminal_ind_list,1);
returned_ind = [];

% For each tip, traces back along the processes from the tip to the soma, adding 1 to the degree of each process it moves through along the way
for ii = 1:m;
    p_SWC(terminal_ind_list(ii),9) = 1;
    returned_ind = p_SWC(terminal_ind_list(ii),3);
    while returned_ind ~= 0;
        p_SWC(returned_ind,9) = p_SWC(returned_ind,9) + 1;
        returned_ind = p_SWC(returned_ind,3);
    end
end

