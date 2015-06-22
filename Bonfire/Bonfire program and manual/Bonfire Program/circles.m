function circles(x0,y0,N,r_start,r_inc,c)

% Description:
%   Draws concentric circles at the locations of the Sholl rings for the sake of visualizing Scholl analysis

for nn = 1:1:N;
    theta = 0:.01:2*pi;
    y(nn,:) = (r_start + (nn-1)*r_inc) * sin(theta) + x0;
    x(nn,:) = (r_start + (nn-1)*r_inc) * cos(theta) + y0;
end
    
%Plot concentric circles

for nn = 1:1:N;
    plot(y(nn,:),x(nn,:),c);
end