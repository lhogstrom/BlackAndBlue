function [grouped_lengths] = swc_lengths_breakdown(p_SWC,order_type,vect)

% Description:
%   Called by bonfire_loadresults.  Generates order-specific sholl information.  
% 
% Input:
%   p_SWC - the p_SWC file for a cell
%   order_type -    a number defining which column of the p_SWC matrix to find order information one (column 4 = ordering scheme 1, column 5 =
%                   ordering scheme 2, column 6 = ordering scheme 3).
%   vect -  a 1 x 2 matrix where all orders less than the digit in the first position are in the first bucket, all orders greater than or equal to the
%           first number and less than the second number are in the second bucket, and all orders greater than or equal to the second number are in
%           the third bucket.
% 
% Output:
%   grouped_lengths -   an X? x 1 x 3 array, where the first dimension is X?, the number of processes in that group, the second dimension is 1, and
%                       the third dimension is 3, corresponding the the three groups of orders specified by vect

% Retreive all length information from the p_SWC folder and initialize the output groups
lengths = p_SWC(:,8);
group_1 = [];
group_2 = [];
group_3 = [];

% Group processes length information together based on order number.  
for ii = 1:size(p_SWC,1);
    if p_SWC(ii,order_type) < vect(1);
        group_1 = [group_1 ; lengths(ii)];
    elseif p_SWC(ii,order_type) < vect(2);
        group_2 = [group_2 ; lengths(ii)];
    elseif p_SWC(ii,order_type) >= vect(2);
        group_3 = [group_3 ; lengths(ii)];
    end
end

% The groups are matrixes, but because they can each be of different lengths they must be grouped together in an array rather than in a matrix
grouped_lengths{:,1,1} = group_1;
grouped_lengths{:,1,2} = group_2;
grouped_lengths{:,1,3} = group_3;