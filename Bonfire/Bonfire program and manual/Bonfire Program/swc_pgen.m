function [SWC, p_SWC] = swc_pgen(SWC)

% Description: Called by <bonfire>.  Generates the p_SWC (or Process_SWC matrix), which is layed out in similar format to the SWC format.  Where the
% SWC format is node-based (each line entry identifies a single node), the p_SWC matrix is process-based (each line entry identifies a segment).
% 
% Input:
%   SWC -   This is the SWC matrix identifying the neuron
% 
% Output:
%   SWC -   A modified version of the original SWC matrix containing an
%           additional column, describing which process in the p_SWC matrix each node belongs to.
%   p_SWC - A matrix similar to the standard SWC matrix, but in which each
%           line entry corresponds to a process rather than a single node within a process.  This matrix contains identifying information about each
%           process, such as if it branches or terminates, and what order it is within one of a number of possible ordering schemes.

% Initialize required matrices and arrays so they can be added to in the algorithm below
ind_list = [];
daughter_ind = [];
P = 0;
qq = 0;
order_1 = 0;
order_2 = 0;
order_3 = 0;
order_4 = 0;
t_degree = 0;
path_length = 0;
SWC = [SWC zeros(size(SWC,1),1)];

% Find all "origin nodes" (the first nodes in a process) of lowest order. In this case, these are the nodes connected to the soma. 
origin_ind = find(SWC(:,7) == 1);
n = size(origin_ind,1);

% Set up the parent matrix.  Each process will have exactly one parent. The SWC index of the origin node of the process goes in the left column, the
% p_SWC index of the parent goes in the right column.
parent_matrix = [origin_ind zeros(n,1)];

% Walks through each of the processes connected to the soma and performs the following...
while size(origin_ind,1) > qq;
    
%     qq is a counter for processes (it is the p_SWC index)
    qq = qq + 1;
    
%     qqq is a counter that opperates within each of the processes connected to the soma
    qqq = 0;
    
%     Initialize a way of counting whether the process terminates or branches
    B_T = [];
    
%     D is the position of the origin point of the process
    D = [SWC(origin_ind(qq),3) SWC(origin_ind(qq),4)];
    
%     the index list is currently the origin of the process being examined
    ind_list = origin_ind(qq);
    
%     Walks down each node in process qq and finds the parent and the number of daughters.  The parent of the first node in the process is determined
%     to be the parent for the whole process
    while size(ind_list,1) > qqq;
        qqq = qqq + 1;
        
%         Making the parent of the first node in the process the parent of the whole process, and recording it's position in the position matrix (D)
        if qqq == 1;
            P = parent_matrix(find(parent_matrix(:,1) == ind_list(qqq)),2);
            parent_ind = SWC(ind_list(qqq),7);
            D_parent = [SWC(parent_ind,3) SWC(parent_ind,4)];
            D = [D_parent ; D];
        else
        end
        
%         Find the number of daughter nodes for node qqq in process qq
        daughter_ind = find(SWC(:,7) == ind_list(qqq));

%         If node qqq has only 1 daughter, add its index to the list of nodes that comprise this process, add its coordinates the the list of
%         positions (D)
        if size(daughter_ind) == 1;
            ind_list = [ind_list ; daughter_ind];
            D_new = [SWC(daughter_ind,3) SWC(daughter_ind,4)];
            D = [D ; D_new];

%         If node qqq has 2 daughters, the B_T counter is set to 0 (branch point) the daughters are added to the parent_matrix along with their parent
%         processes, and they are added to the origin_ind so that the processes they start are eventually also analyzed in this fashion 
        elseif size(daughter_ind,1) == 2;
            B_T = 0;
            parent_matrix_new = [daughter_ind qq*ones(size(daughter_ind,1),1)];
            parent_matrix = [parent_matrix ; parent_matrix_new];
            origin_ind = [origin_ind ; daughter_ind];

%         If node qqq has 0 daughters, it is declared a terminal point
        elseif isempty(daughter_ind);
            B_T = 1;

        else
        end
        
    end
        
%     Calculate the length of the process based on the string of nodes that comprise it (starting from the parent point for the origin node of the
%     process...if this weren't included the space between the two would never be counted anywhere).
    Length = proc_length(D);
    
%     Record the new line item for this process in the p_SWC matrix
    ind = qq;
    p_SWC(qq,:) = [ind B_T P order_1 order_2 order_3 order_4 Length t_degree path_length];
    
%     For all nodes in a process, record the process index they belong to
    SWC(ind_list,8) = ind;
end

p_SWC = p_degree_gen(p_SWC);
p_SWC = p_order_gen(p_SWC);
p_SWC = p_path_length_gen(p_SWC);
    