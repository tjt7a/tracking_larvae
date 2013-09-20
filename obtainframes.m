function[]=obtainframes(vid)
%This function obtains frames from a video file saves it in a new folder
%FRAMES. You need to define variable in the format of vid='whatever.avi'. function
%and video has to be in the same folder with function. for the first 10 frames
 
mov = mmreader(vid);


% Creating Output folder
outputFolder = fullfile(cd, 'FRAMES');
if ~exist(outputFolder, 'dir')
mkdir(outputFolder);
end

% Getting # of frames
numberOfFrames = mov.NumberOfFrames;
numberOfFramesWritten = 0;

for frame = 1 : numberOfFrames
thisFrame = read(mov, frame);
I=rgb2gray(thisFrame);
outBaseFileName = sprintf('%3.3d.png', frame);  %
outFullFileName = fullfile(outputFolder, outBaseFileName);%
imwrite(I, outFullFileName, 'png');
 numberOfFramesWritten = numberOfFramesWritten + 1;

end

progressIndication = sprintf('Wrote %d frames to folder "%s in .png format"',numberOfFramesWritten, outputFolder);
disp(progressIndication);
