clc;
close all;
if ismac
    filename = './videos/larvae1.avi';
else
    filename = '.\larvae1.avi';
end
mov = mmreader(filename);

% Creating Output folder
outputFolder = fullfile(cd, 'individualframes');
if ~exist(outputFolder, 'dir')
mkdir(outputFolder);
end

% Getting # of frames
numberOfFrames = mov.NumberOfFrames;
numberOfFramesWritten = 0;

%Here, I construct a for loop to read, convert binary and save as 'png'
for frame = 1 : numberOfFrames
thisFrame = read(mov, frame);
I=rgb2gray(thisFrame);
outputBaseFileName = sprintf('%3.3d.png', frame);  %
outputFullFileName = fullfile(outputFolder, outputBaseFileName);
imwrite(I, outputFullFileName, 'png');
progressIndication = sprintf('Processing Hold on... %4d of %d.', frame,numberOfFrames);%
disp(progressIndication);
numberOfFramesWritten = numberOfFramesWritten + 1;
end
progressIndication = sprintf('Wrote %d frames to folder "%s"',numberOfFramesWritten, outputFolder);
disp(progressIndication);
