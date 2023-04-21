function weight = WeightFunctionRange0_255(z, weightingFcn) % precondition: z belongs to the range [zmin, zmax]
    weight = 0;
    switch weightingFcn
        case 1 
            if 10 <= z && z <= 245
                weight = 1; % uniform [10, 245]
            end
        case 2
            weight = min(z, 1-z); % tent
        case 3
            weight = (exp(-4*((z-127)^2)/(127)^2)); % gaussian
        case 4
            weight = 1; % photon
    end
end