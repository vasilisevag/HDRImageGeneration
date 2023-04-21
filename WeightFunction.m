function weight = WeightFunction(z, t, weightingFcn) % precondition: z belongs to the range [zmin, zmax]
    weight = 0;
    switch weightingFcn
        case 1 
            weight = 1; % uniform
        case 2
            weight = min(z, 1-z); % tent
        case 3
            weight = (exp(-4*((z-0.5)^2)/(0.5)^2)); % gaussian
        case 4
            weight = t; % photon
    end
end