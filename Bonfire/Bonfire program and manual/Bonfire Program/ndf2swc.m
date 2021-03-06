function [SWC] = ndf2swc(processes,cell_body,scale_factor)

% Description: Called by bonfire_ndf2swc.  Takes the cell body information and process information and transforms them into one matrix defining the
% cell morphology in .swc format.
% 
% Input:
%   processes - an X x N x P matrix where X is the length of the longes process, N is the number of processes, and P = 2 (page 1 is the X coordinates
%               of each node, and page 2 is the Y coordinates) 
%   Cell_body - same as processes, but because it consists of only 1 trace the dimensions are X x 1 x 2
%   scale_factor -  a factor to make up for the fact that NeuronStudio and NeuronJ account for linear space differently
% 
% Output:
%   SWC -   the digitized neuron morphology information as encoded by .swc
%           format
% 

% n is the counter for node number
n = 1;

% R is the radius of the points...we don't track this info, so it is set to a constant
R = .15;

% Calculate the center point and radius of the soma.
cell_bodyX = cell_body(:,:,1);
cell_bodyY = cell_body(:,:,2);
x0 = mean(cell_bodyX(1:max(find(cell_bodyX(:,1))),1));
y0 = mean(cell_bodyY(1:max(find(cell_bodyY(:,1))),1));
r_start = mean([range(cell_bodyX(1:max(find(cell_bodyX(:,1))),1)) range(cell_bodyY(1:max(find(cell_bodyY(:,1))),1))])/2;

% Initialize the SWC matrix
SWC = zeros(1,7);
make_origin = 0;

% Place the soma as the first point in the SWC matrix
SWC(1,:) = [1 1 x0/scale_factor y0/scale_factor 0 r_start/scale_factor -1];

% The algorithms iteratively walks through each of the processes and builds a line entry to be added to SWC in .swc format
for ii = 1:size(processes,2);
    
%     Finds the number of points in that process (eliminate the zero padding)
    p_num = find(processes(:,ii,1),1,'last');

    for jj = 1:p_num;
        same_spot = 0;
        
%         Identify X and Y coordinates for the node
        x = processes(jj,ii,1)/scale_factor;
        y = processes(jj,ii,2)/scale_factor;
        
%         Check that this point does not have the same coordinates as any other point
        for kk = 1:size(SWC,1);
            if x == SWC(kk,3) && y == SWC(kk,4);
                same_spot = 1;
                make_origin = 1;
            else
            end
        end

%         If it is in the same exact spot, the point is skipped, otherwise it is added to the SWC matrix
        if same_spot == 1;
        else
            n = n+1;
            T = 3;

%             Asign each node the appropriate parent node, based on wheather it needs to be an origin (either by position or by it's being the first
%             node in a trace), or by assigning the preceeding node in the trace as the parent node.
            if make_origin == 1;
                P = -1;
                T = 1;
                make_origin = 0;
            elseif jj == 1;
                P = -1;
                T = 1;
            else
                P = n-1;
            end
            
%             Build the complete new SWC line and add it it to the SWC matrix
            SWC_newline = [n T x y 0 R P];
            SWC = [SWC ; SWC_newline];
        end
    end
end
