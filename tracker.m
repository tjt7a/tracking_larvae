% Class definition for the tracker state machine
classdef tracker
    
    %Definitions of state machine
    properties
        count   % Number of larvae
        larvae = []; % Array of larvae
    end
    
    %Methods of state machine
    methods
        function add_larvae(location)
            temp = larvae(location);
            larvae
        end
    end
end
