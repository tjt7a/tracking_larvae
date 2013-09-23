function [ outputI ] = addredbox( inputI, x, y )
%ADDREDBOX adds a red box at a specified position in an image
%   Input variable:
%       inputI = image to which to add box 
%           (can be 2-d or 3-d, but must be uint8)
%       pos = x,y coordinates at which to add box
%   Output variable:
%       outputI = image with box added
%           (3-d, also uint8)

% define constants:
k = 25; % halfwidth
t = 5; % thickness

% define outside and inside of box:
[H, W, ~] = size(inputI);
x_out = max(1, x-k):min(W, x+k);
y_out = max(1, y-k):min(H, y+k);
x_in  = max(1, x-k+t):min(W, x+k-t);
y_in  = max(1, y-k+t):min(H, y+k-t);

% if image is 2-d, duplicate to form third dimension:
[H, W, T] = size(inputI);
if T==1
    outputI = uint8(zeros(H, W, 3));
    outputI(:,:,1) = inputI;
    outputI(:,:,2) = inputI;
    outputI(:,:,3) = inputI;
else
    outputI = inputI;
end

% define mask to erase bits within box:
erase_mask = false(H,W,3);
erase_mask(y_out,x_out,:) = true;
erase_mask(y_in,x_in,:) = false;

% define mask to set layer 1 (red) to 1:
draw_mask = false(H,W,3);
draw_mask(y_out,x_out,1) = true;
draw_mask(y_in,x_in,1) = false;

% to the highest value anywhere in the image
maxintensity = 255;
outputI(erase_mask) = 0;
outputI(draw_mask) = 255;

end

