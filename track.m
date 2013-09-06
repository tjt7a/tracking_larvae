%load avi file
vid=VideoReader('./videos/larvae1.avi');

number_frames=vid.NumberOfFrames;

for i = 10 : 10
    frame = rgb2gray(read(vid, i));
    imshow(frame);
    [pixelCount grayLevels] = imhist(frame);
    bar(pixelCount); title('Histogram of original image');
    xlim([0 grayLevels(end)]);
    
    %What to use as threshold?; lets try 200
    threshold = 200;
    binary_frame = frame > threshold;
    imshow(binary_frame);
end

    