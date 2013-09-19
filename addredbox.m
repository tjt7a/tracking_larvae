function [ outputI ] = addredbox( inputI, pos )
%ADDMARKER adds a shape at a specified position in an image
%   Input variable:
%       inputI = image to which to add marker 
%           (can be 2-d or 3-d, any  bit depth)
%       pos = x,y coordinates at which to add marker
%   Output variable:
%       outputI = image with marker added
%           (3-d, same bit depth as input image)

% define constants:
x = pos(1); y = pos(2);
k = 25; % halfwidth
t = 5; % thickness

% define outside and inside of box:
x_out = x-k:x+k;
y_out = y-k:y+k;
x_in  = x-k+t:x+k-t;
y_in  = y-k+t:y+k-t;

% if image is 2-d, duplicate to form third dimension:
[H, W, T] = size(inputI);
if T==1
    outputI = zeros(H, W, 3);
    outputI(:,:,1) = inputI;
    outputI(:,:,2) = inputI;
    outputI(:,:,2) = inputI;
else
    outputI = inputI;
end

% define mask to erase bits within box:
erase_mask = false(H,W,3);
erase_mask(x_out,y_out,:) = true;
erase_mask(x_in,y_in,:) = false;

% define mask to set layer 1 (red) to 1:
draw_mask = false(H,W,3);
draw_mask(x_out,y_out,1) = true;
draw_mask(x_in,y_in,1) = false;

% because the input could have any depth, just set layer 1 of the box
% to the highest value anywhere in the image
maxintensity = max(max(max(inputI)));
outputI(erase_mask) = 0;
outputI(draw_mask) = maxintensity;

end

