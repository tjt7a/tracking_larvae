function [objxy] = findlarvae(I)
% FINDLARVAE returns x-y coordinates of potential larvae
%   Input variable:
%       I = the still image in which to find the larvae
%   Output variable:
%       objxy = matrix with 
%           columns ~ x,y -> 1st,2nd column  
%           rows ~ larvae (objects)

%% Begin 
% I = imread('larvae1.avi 2013.09.05 01.33.17.642.png');
Ibw = im2bw(rgb2gray(I),0.85);
imshow(Ibw);

%% Filter objects by size
ub = 150;
lb = 75;
cc = bwconncomp(Ibw);
check_area = false(cc.NumObjects,1); cnt = 0;
for ii = 1:cc.NumObjects
    npixels = length(cc.PixelIdxList{ii});
    if (npixels < ub) && (npixels > lb)
        check_area(ii) = true;
    end
end
objs_area = cc.PixelIdxList(check_area)';
allobjs = vertcat(objs_area{:});
newimage = zeros(size(Ibw));
newimage(allobjs) = 1;
imshow(newimage);

%% Filter objects by bounding box
% loop through objs (cell array of vectors)
diagonalmax = 30;
check_box = false(length(objs_area),1);
for jj = 1:length(objs_area)
    % convert linear indexes to subscript indexes
    minrow = inf; maxrow = -inf;
    mincol = inf; maxcol = -inf;
    for linearindex = objs_area{jj}'
        [row, col] = ind2sub(size(I),linearindex);
        minrow = min(minrow, row);
        maxrow = max(maxrow, row);
        mincol = min(mincol, col);
        maxcol = max(maxcol, col);
    end
    rows = maxrow-minrow;
    cols = maxcol-mincol;
    diagonal = sqrt(rows^2 + cols^2);
    check_box(jj) = diagonal <= diagonalmax;
end
objs_box = objs_area(check_box);
allobjs = vertcat(objs_box{:});
newimage = zeros(size(I));
newimage(allobjs) = 1;
imshow(newimage);

%% Filter objects by "girth"

% erode objects
n_erosions = 1;
objs_eroded = objs_box;
% loop through objects and perforn n erosions:
for kk = 1:n_erosions
    % apply erosion at each object:
    for ll = 1:length(objs_eroded)
        currentobj = objs_eroded{ll};
        keep_pixels = zeros(length(currentobj),1);
        % apply erosion at each object pixel:
        for mm = 1:length(currentobj)
            index = currentobj(mm);
            on = get8objneighbors(index, currentobj, size(I));
            % condition for any non-object neighbors:
            if ~ismember(0,on)
                keep_pixels(mm) = true;
            end
        end
        % remove eroded pixels:
        objs_eroded{ll} = currentobj(logical(keep_pixels));
    end
end

% check whether or not objects are still connected
check_width = false(length(objs_eroded),1);
% loop through objects:
for nn = 1:length(objs_eroded)
    currentobj = objs_eroded{nn};
    if isempty(currentobj)
        break
    end
    conn_pixels = zeros(length(currentobj),1);
    % start at random pixel within the object
    conn_pixels(1) = currentobj(1);
    % continue expanding object until all connected pixels are found 
    pixels_added = true;
    while pixels_added == true
        start_cnt = length(conn_pixels(conn_pixels > 0));
        for qq = conn_pixels(conn_pixels > 0)'
            on = get8objneighbors(qq, currentobj, size(I));
            conn_pixels = unique([conn_pixels; (on(on > 0))]);
        end
        end_cnt = length(conn_pixels(conn_pixels > 0));
        pixels_added = end_cnt > start_cnt;
    end
    % set condition for whether the eroded object is still connected 
    check_width(nn) = end_cnt == length(currentobj);
end

objs_width = objs_box(check_width);
allobjs = vertcat(objs_width{:});
newimage = zeros(size(I));
newimage(allobjs) = 1;
imshow(newimage);

%% generate coordinates
objxy = zeros(length(objs_width),2);
for rr = 1:length(objs_width);
    currentobj = objs_width{rr};
    pixelxy = zeros(length(currentobj),2);
    for ss = 1:length(currentobj)
        pixelxy(ss,:) = ind2sub(size(I), currentobj(ss));
    end
    xavg = mean(pixelxy(:,1));
    yavg = mean(pixelxy(:,2));
    objxy(rr,:) = [xavg, yavg];
end

