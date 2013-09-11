% Object Class definition for a larva
classdef larva
    properties
        % Previous location of the larva (2-d location)
        previous_location
    end
    methods
        function obj=larva(location)
            obj.previous_location = location;
        end
    end
end
