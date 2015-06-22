function [coordinatesX, coordinatesY] = loadNJ(pic_path,process)

% Description:
%   Called by bonfire_ndf2swc.  Laods the trace X and Y corodinate data which is exported from NeuronJ in the form of .txt files, and stored in the
%   appropriate folders as set up by bonfire_load. 
% 
% Inputs:
%   pic_path - the directory path for the [Cell Name] folder process - the process name of the [Process Type] folder
% 
% Outputs:
%   X - an N X L matrix containing the X coordinates for process nodes where N is the number of processes, and L is the length of the longest process
%   Y - an N X L matrix containing the Y coordinates for process nodes where N is the number of processes, and L is the length of the longest process

directoryname = [pic_path, process];
D = dir(directoryname);
file_num = size(D,1);
names = [];

%Populates the array <names> with the names of the files by pulling each one from the structured array and concatinating it with the ones previously
%(this automatically zero pads the growing array where necessary).
for ii = 3:1:file_num;    %The first two entries are ignored(not filenames)
    new_name = getfield(D,{ii,1},'name');
    names = strvcat(names, new_name);
end

%Initializes the output arrays which will contain X and Y node coordinates. NOTE:  If the trace contains more than 300 points, or if there are more
%than 300 traces this will return an error.  This should be made more robust in future versions of the program (i.e., determine the largest trace and
%use those dimensions, or use a function that automatically zeropads the columns as they are added).
coordinatesX = zeros(300,300);
coordinatesY = zeros(300,300);

%Iteratively reads each file in, and parses it into X and Y vectors. Vectors are then zero padded to fit into the arrays initialized above before they
%are added to the array.
for ii = 1:1:file_num-2;
    IN = dlmread(strcat(directoryname,'\',names(ii,:)));
    X = IN(:,1);
    Y = IN(:,2);
    
    %Generating the X matrix
    [M_x N_x] = size(X);
    [M_xn N_xn] = size(coordinatesX);
    
    %Zero pad the incoming X vector and add to output
    filler_x = zeros(M_xn - M_x,1);
    X = [X ; filler_x];
    coordinatesX(:,ii) = X;
    
    %Generating the Y matrix
    [M_y N_y] = size(Y);
    [M_yn N_yn] = size(coordinatesY);
    
    %Zero pad the incoming Y vector and add to output
    filler_y = zeros(M_yn - M_y,1);
    Y = [Y ; filler_y];
    coordinatesY(:,ii) = Y;
end

%Shape the final output matrices (originally initialized as above) to their minimum possible size by triming off all regions that are all zeros. The
%final product is two rectangular matrices of the X and Y coordinates for all files that were in the directory probed initially, where traces
%containing fewer than the maximum number of nodes have been zero padded to allow them all to be included in the same matrix.
[mmx,nnx] = find(coordinatesX);
coordinatesX = coordinatesX(1:max(mmx),1:max(nnx));
[mmy,nny] = find(coordinatesY);
coordinatesY = coordinatesY(1:max(mmy),1:max(nny));