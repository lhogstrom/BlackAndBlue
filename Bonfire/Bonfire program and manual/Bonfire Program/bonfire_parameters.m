function [N ring_start r_inc pix_conv scale_factor vect] = bonfire_parameters

% Description:
%   Called by many functions to retreive the master list of parameters (specific to each laboratory's imaging hardware) used in bonfire analysis
% 
% Input:
%   User hard-coded values
% 
% Output:
%   N -             the number of Sholl rings to use
%   ring_start -    the distance from the outside of the soma to start
%                    drawing concentric Sholl rings
%   r_inc -         the increment (in pixels) between Sholl rings
%   pix_conv -      the number of micrometers per pixel
%   scale_factor -  used to adjust SWC format for linking purposes in NeuronStudio
%   vect -          a B x E matrix defining the boundaries of the three order-specifc groups information is sorted into for the purposes of all
%                   order-specific analysis, where B is a number 1-3 indicating which labeling scheme the boundary values apply to, and E indicating
%                   the non-inclusive upper boundary of the first group (E=1) and the non-inclusive upper boundary of the second group (E=2).
% 

N = 89;         
ring_start = 0; %in pixels; can start concentric circles higher if needed
r_inc = 9;  % 9 pixels = 6 um for 20x pictures; rings will be 6um apart   
pix_conv = 1/(1.5);  % change this for different zoom settings; in our case,
                     % 1 um = 1.5 pixels
scale_factor = 10;
vect = [2 3; 2 3; 2 3];