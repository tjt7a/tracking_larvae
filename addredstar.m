function [ outputI ] = addredstar( inputI, x, y )
%ADDREDSTAR adds a red star at a specified position in an image
%   Input variable:
%       inputI = image to which to add star 
%           (2-d or 3-d, but must be uint8)
%       pos = x,y coordinates at which to add star
%   Output variable:
%       outputI = image with star added
%           (3-d, also uint8)
%   The default "star" is just a cross shape ("+"),
%   but by uncommenting the section below

% deal with input images
[H, W, T] = size(inputI);
if T==1
    outputI = uint8(zeros(H, W, 3));
    outputI(:,:,1) = inputI;
    outputI(:,:,2) = inputI;
    outputI(:,:,3) = inputI;
else
    outputI = inputI;
end

% specify constants:
k = 15; % halflength
t = 1; % halfthickness

% make diagonal lines by uncommenting the block:
%{
for ii = 5:(2*k-4)
    for jj = 5:(2*k-4)
        if (ii == jj)
            dummy1(ii,jj) = 1;
            dummy1(ii+1,jj) = 1;
            dummy1(ii,jj+1) = 1;
        end
    end
end
dummy1(2*k-3, 2*k-3) = 1;
%}
dummy1 = zeros(2*k+1, 2*k+1);
dummy2 = dummy1(:, end:-1:1);
starmask = logical(dummy1 + dummy2);

% add vertical, horizontal lines
starmask(k+1-t:k+1+t,:) = 1;
starmask(:,k+1-t:k+1+t) = 1;

% specify overlap ranges in mask
% DO NOT CHANGE THESE LINES !!!!!
mask_x = max(1,k+2-x):min(k+1+W-x,2*k+1);
mask_y = max(1,k+2-y):min(k+1+H-y,2*k+1);

% specify overlap ranges in image cutout
% DO NOT CHANGE THESE LINES !!!!!
cutout_x = max(x-k,1):min(x+k,W);
cutout_y = max(y-k,1):min(y+k,H);

% check overlap size consistency"
check_x = (length(cutout_x) == length(mask_x));
check_y = (length(cutout_y) == length(mask_y));
if ~(check_x && check_y)
    disp('ERROR: something wrong with overlap')
else

    % get the cutout and trim the star mask:
    cutout = inputI(cutout_y,cutout_x,:);
    starmask = logical(starmask(mask_y, mask_x));

    % specify masks to set img to 0 or 255
    % erase mask has star mask on 2nd & 3rd layers
    [mH, mW, ~] = size(starmask);
    erase_mask = false(mH, mW, 3);
    erase_mask(:,:,2) = starmask;
    erase_mask(:,:,3) = starmask;

    % the draw mask has star mask on 1st layer
    draw_mask = false(mH, mW, 3);
    draw_mask(:,:,1) = starmask;

    % set appropriate values in the cutout
    cutout(erase_mask) = 0;
    cutout(draw_mask) = 255;

    % reassign the cutout to the output image
    outputI(cutout_y, cutout_x, :) = cutout;    

end
end

