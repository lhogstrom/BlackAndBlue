function [p_SWC] = p_path_length_gen(p_SWC)

% Description:
%   Called by swc_pgen.  Modifies the existing p_SWC matrix to include the path length of each process (the length from the tip of that process back
%   to the soma).
% 
% Input:
%   p_SWC -     
% 
% Output:
%   p_SWC -     Modified so that column 10 contains the pathlength information.
% 

% For each process in p_SWC, it builds pathway back from that process to the soma (in the form of a list of p_SWC indexes).  It then sums up the
% length of all processes listed in this index list, and adds it as column 10 in p_SWC.
n = size(p_SWC,1);
for ii = 1:n;
    path_inds = ii;
    parent_ind = 1;
    while parent_ind > 0;
        parent_ind = p_SWC(path_inds(end),3);
        if parent_ind == 0;
        else
            path_inds = [path_inds ; parent_ind];
        end
    end
    path_length(ii) = sum(p_SWC(path_inds,8));
end

p_SWC(:,10) = path_length;