% Class definition for the tracker state machine
classdef tracker
    
    %Definitions of state machine
    properties(GetAccess = public, SetAccess = public)
        count  = 0; % Number of larvae
        larvae %= [larva([])]; % Array of larvae
    end
    
    %Methods of state machine
    methods
        %Constructor for the tracker class; initializes count to 0
        function obj=tracker()
            obj.count = 0;
        end
        
        function obj = set_count(obj, count)
            obj.count = count;
        end

        %Creates a new larvae at location <location> and adds it to the larvae array
        function obj = add_larva(obj, location)
            obj.count = 10;
            %obj.larvae(obj.count) = larva(location);
        end
    end
end
