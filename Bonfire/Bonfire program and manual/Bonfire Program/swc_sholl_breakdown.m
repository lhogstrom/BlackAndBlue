function [grouped_sholl] = swc_sholl_breakdown(sholl_num,vect)

% Description:
%   Called by bonfire_loadresults.  Generates order-specific sholl information.  
% 
% Input:
%   sholl_num - an N x O+1 matrix where N is the number of Sholl rings, the first column is the total Sholl curve for the cells, and each column
%               after that is the Sholl curve for that order number
%   vect -  a 1 x 2 matrix where all orders less than the digit in the first position are in the first bucket, all orders greater than or equal to the
%           first number and less than the second number are in the second bucket, and all orders greater than or equal to the second number are in
%           the third bucket.
% 
% Output:
%   grouped_sholl - an N x 1 x 3 matrix, where the first dimension is N, the number of Sholl rings, the second dimension is 1, and the third dimension
%                   is 3, corresponding the the three groups of orders specified by vect
% 

% Initialize the arrays that are eventually lumped into the output
group_1 = zeros(size(sholl_num,1),1);
group_2 = zeros(size(sholl_num,1),1);
group_3 = zeros(size(sholl_num,1),1);

% Eliminate the first column, which is the total Sholl information, changing the N x O+1 matrix sholl_num into an N x O matrix, where O is the maximum
% number of orders for this cell and labeling scheme
sholl_num = sholl_num(:,2:end);

% Group the N x O matrix sholl_num into 3 groups, based on order.  This will allow the information from all cells to be collated into one large matrix
% in bonfire_loadresults
for ii = 1:size(sholl_num,2);
    if ii < vect(1);
        group_1 = [group_1 + sholl_num(:,ii)];
    elseif ii < vect(2);
        group_2 = [group_2 + sholl_num(:,ii)];
    elseif ii >= vect(2);
        group_3 = [group_3 + sholl_num(:,ii)];
    end
end

% Lump each group into the final output matrix, grouped_sholl
grouped_sholl(:,1,1) = group_1;
grouped_sholl(:,1,2) = group_2;
grouped_sholl(:,1,3) = group_3;