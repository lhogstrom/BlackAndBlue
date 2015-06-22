function bonfire_ndf2swc

% Description: STEP 2 in bonfire analysis.  This script is called by the user following the successful completion of bonfire_load.
% 
% Input: Prompts the user to identify the target directory, which contains a folder/data structure as described in the instructions
% 
% Output: Generates a new .swc file from the existing .txt and _info files from NeuronJ.  The .swc file can then be opened in NeuronStudio for editing

% Initialize required arrays and prompt user for target folder.
[N ring_start r_inc pix_conv scale_factor vect] = bonfire_parameters;
cell_list = [];
qq = 0;
waitbar_master = waitbar(0,'BONFIRE-NDF2SWC - GENERATING SWC FILES');
directory_root = uigetdir;
A = dir(directory_root);

% Build cell_list (the list of folders containing cell information)
for ii = 3:size(A,1);
    if getfield(A,{ii,1},'isdir') == 1;
        qq = qq + 1;
        if ischar(getfield(A,{ii,1},'name'));
            cell_list{qq} = getfield(A,{ii,1},'name');
        else
            cell_list{qq} = num2str(getfield(A,{ii,1},'name'));
        end
    else
    end
end


for ii = 1:length(cell_list);
    cell_body = [];
    waitbar((ii/length(cell_list)),waitbar_master);
 
%     Create a matrix containing X and Y coordinates for the cell body, and another containing the X coordinates for all the processes, and a third
%     containing the Y coordinates for all the processes
    [cell_bodyX , cell_bodyY] = loadNJ([directory_root,'\',cell_list{ii},'\'],'Cell Body');
    [ProcessesX , ProcessesY] = loadNJ([directory_root,'\',cell_list{ii},'\'],'Processes');
    
%     Establishing the center point for the soma, and the radius for the circular cell body 
    x0 = mean(cell_bodyX(1:max(find(cell_bodyX(:,1))),1));
    y0 = mean(cell_bodyY(1:max(find(cell_bodyY(:,1))),1));
    r_start = mean([range(cell_bodyX(1:max(find(cell_bodyX(:,1))),1)) range(cell_bodyY(1:max(find(cell_bodyY(:,1))),1))])/2;

    cell_body(:,:,1) = cell_bodyX;
    cell_body(:,:,2) = cell_bodyY;

    [Lp Np] = size(ProcessesX);
    processes = zeros(Lp,Np,2);
    processes(:,:,1) = ProcessesX;
    processes(:,:,2) = ProcessesY;

%     Generate SWC, relabel T/B points, connect obvious branches, and relabel T/B points again
    SWC = ndf2swc(processes,cell_body,scale_factor);
    SWC = swc_correct(SWC);
    SWC = swc_connect(SWC);
    SWC = swc_correct(SWC);

    dlmwrite([cell_list{ii} '_prelim.swc'],SWC,' ');
    movefile([cell_list{ii} '_prelim.swc'],[directory_root,'\',cell_list{ii}]);
end
close(waitbar_master);
