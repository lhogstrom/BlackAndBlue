function [lengths_summary num_proc_summary] = branch_condition_summary_gen(lengths_scheme_list,cell_list)

% Description:
%   Called by bonfire_loadresults.  Creates an order-specific summary of the lengths and number of neuritic segments for all neurons in a condition.
% 
% Inputs:
%   lengths_scheme_list -   an K x Q x G array containing the lengths of neuritic segments, where Q is the cell number, G is the order-group, and K is
%                           the number of processes in that group
%   cell_list -             the list of all cells in this condition
% 
% Outputs:
%   lengths_summary -   a G x 1 x D array containing the summary of process length, where G is the order-specific group, and D is an identifier of
%                       data (D=1) vs. STE of data (D=2) 
%   num_proc_summary -  a G x 1 x D array containing the summary of process number, where G is the order-specific group, and D is an identifier of
%                       data (D=1) vs. STE of data (D=2)
% 

% Initialize the output matrixes.
group_1_lengths = [];
group_2_lengths = [];
group_3_lengths = [];
for kk = 1:size(cell_list,1);
    group_1_lengths = [group_1_lengths ; lengths_scheme_list{:,kk}{1}];
    group_2_lengths = [group_2_lengths ; lengths_scheme_list{:,kk}{2}];
    group_3_lengths = [group_3_lengths ; lengths_scheme_list{:,kk}{3}];

    group_1_number(kk) = length(lengths_scheme_list{:,kk}{1});
    group_2_number(kk) = length(lengths_scheme_list{:,kk}{2});
    group_3_number(kk) = length(lengths_scheme_list{:,kk}{3});
end

condition_avg_lengths = [sum(group_1_lengths)/length(group_1_lengths) ; sum(group_2_lengths)/length(group_2_lengths) ; sum(group_3_lengths)/length(group_3_lengths)];
condition_avg_lengths_ste = [std(group_1_lengths)/sqrt(length(group_1_lengths)) ; std(group_2_lengths)/sqrt(length(group_2_lengths)) ; std(group_3_lengths)/sqrt(length(group_3_lengths))];

condition_avg_num_proc = [mean(group_1_number) ; mean(group_2_number) ; mean(group_3_number)];
condition_avg_num_proc_ste = [std(group_1_number)/sqrt(length(group_1_number)) ; std(group_2_number)/sqrt(length(group_2_number)) ; std(group_3_number)/sqrt(length(group_3_number))];

lengths_summary(:,1,1) = condition_avg_lengths;
lengths_summary(:,1,2) = condition_avg_lengths_ste;

num_proc_summary(:,1,1) = condition_avg_num_proc;
num_proc_summary(:,1,2) = condition_avg_num_proc_ste;