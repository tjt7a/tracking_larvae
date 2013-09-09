function [nh] = get8objneighbors(querypixel, objpixels, siz)
%GET8OBJNEIGHBORS returns a representation of pixels around querypixel
%   Input variables:
%       querypixel = linear index of the query pixel
%       objpixels = vector of linear indices of the pixels in the object
%       siz = dimensions of the image [rows, columns]
%   Output variable:
%       nh = matrix representing a window around the query pixel
%            the elements of which can take on two values:
%               linearindex (in siz) if pixel is in the object
%               0 if pixel is not in the object
%   This function can be used to identify what pixels, if any,
%   are both neighbors of the query pixel and elements of the object
%   
%   Example - identify :
%   I = [1 1 1; 1 1 0; 0 0 0];
%   onh = get8objneighbors(7, op = [1 2 4 5 7], size(I))
%   onh =
%        4     7
%        5     0
%   onh(onh > 0)
%   ans =
%        4
%        5
%        7


% first, get potential neighborhood of the query pixel
[row, col] = ind2sub(siz, querypixel);    
rowvals = [row-1, row, row+1];
colvals = [col-1, col, col+1];

% check for boundary conditions
if row == 1
    rowvals = rowvals(2:3);
elseif row == siz(1)
    rowvals = rowvals(1:2);
end
if col == 1
    colvals = colvals(2:3);
elseif col == siz(2)
    colvals = colvals(1:2);
end

nrows = length(rowvals);
ncols = length(colvals);
neighborhood = zeros(nrows, ncols);
for ii = 1:nrows
    for jj = 1:ncols
        neighbor = sub2ind(siz, rowvals(ii), colvals(jj));
        if ismember(neighbor, objpixels)
            neighborhood(ii,jj) = neighbor;
        end           
    end
end
nh = neighborhood;
