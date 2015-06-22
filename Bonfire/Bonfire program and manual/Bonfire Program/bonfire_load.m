function bonfire_load

% Description: STEP 1 of bonfire analysis, used to create appropriate folder organization from data files exported from NeuronJ.  See instructions for
% a description of the appropriate starting file structure and required files.
% 
% Inputs: Prompts user to identify target folder containing appropriate files and information (see instructions).
% 
% Outputs: Organizes files in the target folder into appropriate sub-folders for analysis by subsequent portions of bonfire code.
% 

% Initializes required arrays for error tracking and building the list of cells, as well as prompting user to identify the target directory
cell_list = [];
error_list = [];
cell_error = [];
qq = 0;
directory_root = uigetdir;
waitbar_master = waitbar(0,'BONFIRE-LOAD - REORGANIZING DIRECTORIES');

% Build cell_list Builds a list of the cells it expects to see, based on all the files in the folder that end with a '.tif' extension.  Image file
% names can be any string of alphanumeric characters.
A = dir(directory_root);
for ii = 3:size(A,1);
    file_name = getfield(A,{ii,1},'name');
    if strcmp(file_name(1,max(find(file_name == '.')):end), '.tif');
        qq = qq + 1;
        if ischar(getfield(A,{ii,1},'name'));
            new_name = getfield(A,{ii,1},'name');
            cell_list{qq} = new_name(1:max(find(new_name == '.'))-1);
        else
            new_name = num2str(getfield(A,{ii,1},'name'));
            cell_list{qq} = new_name(1:max(find(new_name == '.'))-1);
        end
    else
    end
end

% For each of the identified cells
for ii = 1:length(cell_list);
    waitbar((ii/length(cell_list)),waitbar_master);
    if exist([directory_root,'\',cell_list{ii},'.tif']) & exist([directory_root,'\',cell_list{ii},'.ndf']) & exist([directory_root,'\',cell_list{ii},'_info']);
        
        S = importdata([directory_root,'\',cell_list{ii},'_info'],'\t');
        B = getfield(S,'textdata');
        N = size(B,1);
        types = strvcat(B(:,4));
        names = strvcat(B(:,2));
        
%         Check to see that there is a trace labeled as being the cell body
        cell_body_ind = 0;
        for iii = 1:1:N-1;
            if types(iii+1,1:3) == 'Cel' | types(iii+1,1:3) == 'Typ' | types(iii+1,1:3) == 'Som';
                cell_body_ind = 1;
            else
            end
        end
        
        waitbar_slave = waitbar(0,'BONFIRE-LOAD - REORGANIZING FILES');
        
        if cell_body_ind == 1;
            
%             Creates the new sub-folders for each cell, and the folders for the processes traces and cell body trace within that folder.  It also
%             begins moving the data files to the correct locations within this new folder structure.
            mkdir(directory_root,cell_list{ii});
            movefile([directory_root,'\',cell_list{ii},'.tif'],[directory_root,'\',cell_list{ii},'\',cell_list{ii},'.tif']);
            movefile([directory_root,'\',cell_list{ii},'.ndf'],[directory_root,'\',cell_list{ii},'\',cell_list{ii},'.ndf']);
            movefile([directory_root,'\',cell_list{ii},'_info'],[directory_root,'\',cell_list{ii},'\',cell_list{ii},'_info']);
            movefile([directory_root,'\',cell_list{ii},'.txt'],[directory_root,'\',cell_list{ii},'\',cell_list{ii},'.txt']);

            mkdir([directory_root,'\',cell_list{ii}],'Cell Body');
            mkdir([directory_root,'\',cell_list{ii}],'Processes');

%             Some of this is grandfathered in from past versions of the program.  Currently, everything is routed to either a "Process" folder or a
%             "Cell Body" folder.  The information about what "Type" each process is provides the information about where to direct each file.
            for iii = 1:1:N-1;
                waitbar((iii/(N-1)),waitbar_slave);
                
%               Traces labeled as "Primary" go to the "Processes" Folder
                if types(iii+1,1:2) == 'Pr';
                    file_name = [cell_list{ii},'.',strcat(names(iii+1,:)),'.txt'];
                    movefile([directory_root,'\',file_name],[directory_root,'\',cell_list{ii},'\','Processes','\',file_name]);
                    
%               Traces labeled as "Secondary" go to the "Processes" Folder
                elseif types(iii+1,1:2) == 'Se';
                    file_name = [cell_list{ii},'.',strcat(names(iii+1,:)),'.txt'];
                    movefile([directory_root,'\',file_name],[directory_root,'\',cell_list{ii},'\','Processes','\',file_name]);
                    
%               Traces labeled as "Tertiary" or "Default" go to the "Processes" Folder
                elseif types(iii+1,1:2) == 'Te' | types(iii+1,1:2) == 'De';
                    file_name = [cell_list{ii},'.',strcat(names(iii+1,:)),'.txt'];
                    movefile([directory_root,'\',file_name],[directory_root,'\',cell_list{ii},'\','Processes','\',file_name]);
                    
%               Traces labeled as "Cell Body," "Type 06," or "Soma" go to the "Cell Body" folder
                elseif types(iii+1,1:2) == 'Ce' | types(iii+1,1:2) == 'Ty' | types(iii+1,1:2) == 'So';
                    file_name = [cell_list{ii},'.',strcat(names(iii+1,:)),'.txt'];
                    movefile([directory_root,'\',file_name],[directory_root,'\',cell_list{ii},'\','Cell Body','\',file_name]);
                end
            end
        else
            cell_error = ['The cell labeled "',cell_list{ii},'" contains no "Cell Body" trace.'];
        end
        close(waitbar_slave);
    else
       cell_error = ['The cell labeled "',cell_list{ii},'" is missing the either the .tif image file, the .ndf file, or the correctly formatted _info file.'];
    end
    error_list = strvcat(error_list,cell_error);
end

% Error reporting to help users trouble shoot.  Points out missing cell body traces, missing files, or extra files.
close(waitbar_master);
if isempty(error_list);
    error_list = 'No Errors Detected';
    disp(error_list);
    A_check = dir(directory_root);
    for ii = 1:length(A_check);
        if A_check(ii).isdir;
        else
            disp(['WARNING...UNIDENTIFIED FILE LABELED "',A_check(ii).name,'" IN EXPERIMENTAL FOLDERS. DATA FROM NEURONJ MAY HAVE BEEN EXPORTED INCORRECTLY!)']);
        end
    end
else
    disp(error_list);
    error('ERRORS IN FILE STRUCTURE FOUND - SEE ABOVE');
end
