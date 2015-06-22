function [sholl_total] = swc_sholl(SWC,p_SWC,order_type)

% Description: 
%   Called by swc_pgen.  Performs order based sholl analysis on the neuronal morphology files using the SWC and p_SWC matrices as information.
% 
% Input:
%   SWC - 
%   p_SWC - 
%   order_type -    a number (currently 4-7) which designates the process labeling scheme by which the processes are to be ordered for
%                   the purposes of the order-specific Sholl analysis.
% 
% Output:
%   sholl_total -   an N x O+1 matrix, where N is the number of Sholl rings used and O is the maximum process order for this cell and labeling scheme,
%                   containing the number of order-specific Sholl intersections for this cell and order type.  Column 1 is the total number of
%                   intersections.  Column 2 - O+1 are the sholl intersections for processes with order 1 - O.
% 

% Initialize the required global variables and the output variables
[N ring_start r_inc pix_conv scale_factor vect] = bonfire_parameters;
r_start = SWC(1,6);
x0 = SWC(1,3);
y0 = SWC(1,4);
sholl_total = [];
M = size(SWC,1);

% For order 1 through the highest order process in the labeling scheme that has been selected...
for ii = 1:max(p_SWC(:,order_type));
    ind_list = [];
    sholl_sumation = zeros(N,1);
    
%     Build a list of all points in that order as indexed in the SWC file, called ind_list
    for iii = 2:M;
    order_num = p_SWC(SWC(iii,8),order_type);
    if order_num == ii;
        ind_list = [ind_list ; iii];
    else
    end
    end
    
%     For each of the Sholl rings, walk though every node in the order and check whether the line between that node and its parent node crosses the
%     ring.  This is done by comparing the radius of the test circle with the radial distance from the soma center to the test node and its parent
%     node
    for nn = 1:1:N;
        rr(nn) = r_start + (nn-1)*r_inc;
        for pp = 1:size(ind_list,1);
            x2 = SWC(ind_list(pp),3);
            y2 = SWC(ind_list(pp),4);
            parent_ind = SWC(ind_list(pp),7);
            x1 = SWC(parent_ind,3);
            y1 = SWC(parent_ind,4);
            d1(pp) = sqrt( (x1-x0)^2 + (y1-y0)^2 );
            d2(pp) = sqrt( (x2-x0)^2 + (y2-y0)^2 );

            if (d2(pp) >= rr(nn) && d1(pp) < rr(nn)) || (d2(pp) <= rr(nn) && d1(pp) > rr(nn));
                sholl_sumation(nn) = sholl_sumation(nn) + 1;
            else
            end
        end
    end
    
    sholl_total(:,ii) = sholl_sumation;
end

sholl_total = [sum(sholl_total,2) sholl_total];
    

