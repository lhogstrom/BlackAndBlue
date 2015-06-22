function swc_sholl_summary(ring_dist,sholl_detail,scheme,vect)

% Description:
%   Called by bonfire_results.  Generates the order-specific 
% 
% Input:
%   ring_dist -     a vector indicating the radii at which the Sholl rings are located
%   sholl_detail -  The sholl_detail matrix is an N x C x G x D x S matrix, where N is the number of Sholl rings, C is the number of conditions, G is
%                   the oder-group (buckets 1-3 as defined by vect), D is either the data (D=1) or the STE of the data (D=2), and S is the labeling
%                   scheme. 
%   scheme -        a number 1-3 indicating which labeling scheme to use
%   vect -          a vector indicating what ranges of orders are sorted into which groups
% 
% Output:
%   Graphical - displays the order-specific sholl curves for all conditions selected, and for the labeling scheme selected
% 

% Maintain and colorize the figure
clf; hold on;
colors = gray_cl(size(sholl_detail,2));

for ii = 1:size(sholl_detail,2);
    subplot(3,1,1); hold on; errorbar(ring_dist,sholl_detail(:,ii,1,1,scheme),sholl_detail(:,ii,1,2,scheme),'-','color',colors(ii,:)); axis tight; ylabel(['Int.# Order < ' num2str(vect(1))]);
    if scheme == 1; title('Sholl Analysis Broken Down By Order - Centrifugal (Inside-Out) Labeling Scheme');
    elseif scheme == 2; title('Sholl Analysis Broken Down By Order - Root, Intermediate, Terminal (RIT) Labeling Scheme');
    elseif scheme == 3; title('Sholl Analysis Broken Down By Order - Centripetal (Tips-In) Labeling Scheme');
    end
    subplot(3,1,2); hold on; errorbar(ring_dist,sholl_detail(:,ii,2,1,scheme),sholl_detail(:,ii,2,2,scheme),'-','color',colors(ii,:)); axis tight; ylabel(['Int.#: ' num2str(vect(1)) ' =< Order < ' num2str(vect(2))]);
    subplot(3,1,3); hold on; errorbar(ring_dist,sholl_detail(:,ii,3,1,scheme),sholl_detail(:,ii,3,2,scheme),'-','color',colors(ii,:)); axis tight; ylabel(['Int.#: Order >= ' num2str(vect(2))]);
    xlabel('Ring Distance (um)')
end

