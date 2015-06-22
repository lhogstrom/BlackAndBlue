function [p_length] = proc_length(D)

% Description:
% Called by swc_pgen.  Calculates the lenght of a string of nodes based on the X and Y coordinates of each node in the string
% 
% Input:
%   D - an N x 2 matrix, where N is the number of nodes in the string.  The first column is X coordinates the second column is Y coordinates (in pixel
%   position, not in micrometers)
% 
% Output:
%   p_length -  the length (in micrometers) of the string of nodes
% 

% Initialize required global and housekeeping variables and arrays
[N ring_start r_inc pix_conv scale_factor vect] = bonfire_parameters;
p_length = 0;
m = size(D,1);

% Calculates distance between each node and the preceeding node using pythagorean theorem, and adds it to the total distance from the preceeding
% iteration
for pp = 2:1:m;
    p_length = p_length + sqrt( (D(pp,1)-D(pp-1,1))^2 + (D(pp,2)-D(pp-1,2))^2);
end

% Converts results to micrometers from pixels
p_length = p_length * pix_conv;
