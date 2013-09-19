
%Definitions of state machine
count  = 0; % Number of larvae
larvae = []; % Array of larvae for for first 10 frames

%Obtain first 10 frames
obtaining_frames

for i = 1 : 10
    file_location = sprintf('individualframes/%3.3d.png', i);
    I = imread(file_location);
    track(I); %What is this doing?
    
    %larvae[i] = findlarvae(I); %This should theoretically grab larvae values 
    
    fakelarva = [100 100];
    %Iterate through larvae and put a '*' on them
    rectangle('Position',[(fakelarva(1)-12) (fakelarva(2)-12) 24 24], 'EdgeColor','g');
    text(fakelarva(1),fakelarva(2),'*','FontSize',50, 'Color', 'r')
    
    %The next step is to 
end