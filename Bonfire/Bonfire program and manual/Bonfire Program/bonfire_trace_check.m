function bonfire_trace_check

% Description: 
%   STEP 3 in bonfire analysis.  Performed after you have linked all processes of a single cell into their correct pattern of connectivity.
%   Checks the resulting SWC file for unlinked or erroneously linked (i.e., multifurcations) processes.  
% 
% Input: 
%   Works on the SWC file you saved after linking processes in NeuronStudio 
% 
% Output: 
%   *_final.swc - Creates a new SWC file named *_final.swc, which is later read by the bonfire script directly 
%   Graphical -   Plots a figure of neuron and SWC trace in which incorrect nodes are denoted in RED
% 

% Initialize necessary counters and housekeeping arrays
[N ring_start r_inc pix_conv scale_factor vect] = bonfire_parameters;
cell_list = [];
qq = 0;
waitbar_master = waitbar(0,'SWC ERROR CHECKING');

% Prompt user to identify target directory
directory_root = uigetdir;
A = dir(directory_root);

% Build cell_list
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
    error_pts = [];
    soma_toggle = 0;
    waitbar((ii/length(cell_list)),waitbar_master);

    %Load and shape data
    pic = imread([directory_root,'\',cell_list{ii},'\',cell_list{ii},'.tif']);
    [m,n] = size(pic);
    SWC_struct = importdata([directory_root,'\',cell_list{ii},'\',cell_list{ii},'.swc'],' ',15);
    SWC = getfield(SWC_struct,'data');
    SWC(:,3) = SWC(:,3)*scale_factor;
    SWC(:,4) = SWC(:,4)*scale_factor;
    SWC(:,6) = SWC(:,6)*scale_factor;

    for qq = 1:size(SWC,1);

        % Check for triple branch points
        daughter_ind = find(SWC(:,7) == qq);
        if SWC(qq,2) ~= 1;
            if size(daughter_ind,1) > 2;
                error_pts = [error_pts; SWC(qq,3) SWC(qq,4)];
            elseif size(daughter_ind,1) == 2;
                SWC(qq,2) = 5;
            elseif isempty(daughter_ind);
                SWC(qq,2) = 6;
            else
            end
        else
        end

        % Check for additional cell bodies
        if (SWC(qq,2) == 1) && (soma_toggle >= 1);
            error_pts = [error_pts; SWC(qq,3) SWC(qq,4)];
        elseif (SWC(qq,2) == 1) && (soma_toggle == 0);
            soma_toggle = soma_toggle + 1;
        else
        end

    end

%     Plot the error points in red for easy identification
    if isempty(error_pts);
    else
        figure(ii); clf; hold on;
        imagesc(pic);
        colormap('gray');
        axis([0 n 0 m]);
        scatter(SWC(:,3),SWC(:,4),1.5*pi*SWC(:,6).^2,'b','filled');
        scatter(SWC(1,3),SWC(1,4),1.5*pi*SWC(1,6).^2,'b','filled');
        scatter(error_pts(:,1),error_pts(:,2),90,'r','filled');
        title(['Cell Name:  ' cell_list{ii}]);
    end
    
%     Rescale the SWC coordinates, and write the *_final.swc file in the cell analysis folder
    SWC_rewrite = SWC;
    SWC_rewrite(:,3) = SWC(:,3)/scale_factor;
    SWC_rewrite(:,4) = SWC(:,4)/scale_factor;
    SWC_rewrite(:,6) = SWC(:,6)/scale_factor;
    dlmwrite([cell_list{ii} '_final.swc'],SWC_rewrite,' ');
    movefile([cell_list{ii} '_final.swc'],[directory_root,'\',cell_list{ii}]);
end
close(waitbar_master);
disp(['No errors found in folder ', directory_root])