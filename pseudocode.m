% This script is pseudo-code for the overall task of tracking larvae
% any line that refers to non-existent functions  marked with ***TODO***

%% (1) manage input
vidfilename = 'larvae1.avi';
obtainframes(vidfilename)
% output message to clarify where/how files are being saved? 

%% (2) identify potential initial larvae
initialframe = getinitialframe(); % ***TODO*** 
larvae_coords = findlarvae(initialframe);

%% (3) iteratively track larvae and eliminate false positives 
% not really sure how to combine existing code for this part

%% (4) generate/analyze heat map 
getheatmap() % ***TODO***

