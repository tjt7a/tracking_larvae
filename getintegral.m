function [ normintegral ] = getintegral( img1, img2, x, y)
%GETNORMINTEGRAL calculates the difference integral between two images
%   over a domain centered at x,y with half-width k
%   and normalized by the total area (number of pixels)

% establish window;
k = 25;
[H, W, ~] = size(img1);
xrange = max(1,x-k):min(W,x+k);
yrange = max(1,y-k):min(H,y+k);
npixels = length(xrange)*length(yrange);

% perform integration:
diffintegral = 0;
for kk = xrange
    for ll = yrange
        % perform difference:
        thisdiff = double(abs(img1(ll,kk) - img2(ll,kk)));
        % add to sum:
        diffintegral = diffintegral + thisdiff;
    end
end
normintegral = diffintegral/npixels;
end

