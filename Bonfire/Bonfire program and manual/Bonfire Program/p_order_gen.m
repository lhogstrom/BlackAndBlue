function [p_SWC] = p_order_gen(p_SWC)

% Description:
%   Called by swc_pgen.  Modifies the existing p_SWC matrix to include the "order" of each process (based on 1 of three ordering schemes discussed in
%   the instructions).
% 
% Input:
%   p_SWC -     
% 
% Output:
%   p_SWC -     Modified so that columns 4, 5, and 6 include the order information for the three labeling schemes as discussed
% 

order_1 = 0;
order_2 = 0;
order_3 = 0;
order_4 = 0;
returned_ind = [];
m = size(p_SWC,1);

% Setting up order_1 - centrifugal order ("inside-out" labeling scheme)
for ii = 1:m;
    order_1 = 1;
    returned_ind = p_SWC(ii,3);
    while returned_ind ~= 0;
        order_1 = order_1 + 1;
        returned_ind = p_SWC(returned_ind,3);
    end
    p_SWC(ii,4) = order_1;
end

% Setting up order_2 - root, intermediate, terminal order ("RIT" labeling scheme)
for ii = 1:m;
    if p_SWC(ii,3) == 0;
        order_2 = 1;
    elseif p_SWC(ii,2) == 0;
        order_2 = 2;
    elseif p_SWC(ii,2) == 1;
        order_2 = 3;
    else
    end
    p_SWC(ii,5) = order_2;
end

% Setting up order_3 - Centripetal order ("tips-in" labeling scheme)
t_ind = find(p_SWC(:,2));
p_SWC(t_ind,6) = 1;

max_order = max(p_SWC(:,4));
for ii = 1:max_order;
    kk = max_order + 1 - ii;
    ind = find(p_SWC(:,4) == kk);
    n = size(ind,1);
    for iii = 1:n;
        daughter_ind = ind(iii);
        parent_ind = p_SWC(daughter_ind,3);
        if parent_ind == 0;
        else
            daughter_ind = find(p_SWC(:,3) == parent_ind);
            d1_ind = daughter_ind(1,1);
            d2_ind = daughter_ind(2,1);
            d1_order_3 = p_SWC(d1_ind,6);
            d2_order_3 = p_SWC(d2_ind,6);
            if d1_order_3 == d2_order_3;
                p_SWC(parent_ind,6) = d1_order_3 + 1;
            else
                p_SWC(parent_ind,6) = max([d1_order_3 d2_order_3]);
            end
        end
    end
end        