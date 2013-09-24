function [  ] = trackbywindow( xy, nimages)
%TRACKBYWINDOW tracks larvae 
%   xy is an n-by-2 matrix of x-y coordinates of potential larvae
%   where n is the number of points started with 

% functional pseudocode:
% set min_integral
% for each frame:
%   for each potential larva:
%       define window around larva
%       perform difference integration on window 
%       if integral < min_integral
%           discard larvae
%       else
%           update position 

% define constants:
min_integral = 1.7;
max_static_cnt = 15;

% define vector of static 
[nlarvae, ~] = size(xy);
static = zeros(nlarvae,1);

% set up coloring:
cmap = colormap('HSV');
[ncolors, ~] = size(cmap);
shuffledcols = cmap(randperm(ncolors),:);
colors = shuffledcols(1:nlarvae, :);


corners = getcorners(25, 5);
star = getstar(15, 1);
for ii = 2:nimages
    % get images:
    newimgname = sprintf('FRAMES\\%03.0f.png', ii);    
    oldimgname = sprintf('FRAMES\\%03.0f.png', ii-1);
    newimg = imread(newimgname);
    oldimg = imread(oldimgname);
    [nlarvae, ~] = size(xy);

    diffimg = newimg(:,:,1) - oldimg(:,:,1);
    % loop through possible larvae and check for movement:
    for jj = 1:nlarvae
        % define difference window:
        x = xy(jj,1); y = xy(jj,2); 
        k = 25;
        [H, W, ~] = size(diffimg);
        window_x = max(1,x-k):min(W,x+k);
        window_y = max(1,y-k):min(H,y+k);
        window = diffimg(window_y, window_x);
        [wH, wW, ~] = size(window);
        normintegral = sum(sum(window))/(wH*wW);
        if normintegral < min_integral
            static(jj) = static(jj) + 1;
        else
            % if movement did take place,update location
            static(jj) = 0;
            [newx, newy] = getnewloc(diffimg, x, y);
            xy(jj, 1) = newx;
            xy(jj, 2) = newy;
        end
    end
    
    % eliminate any possibilities that have been static for too long 
    xy = xy(static < max_static_cnt, :);
    colors = colors(static < max_static_cnt, :);
    static = static(static < max_static_cnt);
    
    [nlarvae, ~] = size(xy);
    %disp(nlarvae)
    if (nlarvae == 0)
        disp('ERROR: all larvae eliminated');
        break
    end
    tracked = newimg;
    for kk = 1:nlarvae
        col = colors(kk,:);
        x = xy(kk,1); y = xy(kk,2);
        tracked = addshape(corners,tracked, x, y, col);
        tracked = addshape(star,tracked, x, y, col);
    end
    imshow(tracked)
    drawnow;
    disp('press any key to continue ...')
    pause

end

end

