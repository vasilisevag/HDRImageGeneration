function radianceMap = mergeLDRStack(imgStack, exposureTimes, weightingFcn)
    radianceMapHeight = size(imgStack, 2);               
    radianceMapWidth = size(imgStack, 3);
    logRadianceMap = zeros(radianceMapHeight, radianceMapWidth);
    
    imagesTotal = size(imgStack, 1);
    for heightIdx = 1 : radianceMapHeight
        for widthIdx = 1 : radianceMapWidth
            
            logRadianceMapNominator = 0;
            logRadianceMapDenominator = 0;
            for imageIdx = 1 : imagesTotal  % calculate the result of equation 3 iteratively
                if 0.01 <= imgStack(imageIdx, heightIdx, widthIdx) && imgStack(imageIdx, heightIdx, widthIdx) <= 0.99
                    logRadianceMapNominator = logRadianceMapNominator + WeightFunction(imgStack(imageIdx, heightIdx, widthIdx), exposureTimes(imageIdx), weightingFcn)*(log(imgStack(imageIdx, heightIdx, widthIdx))-log(exposureTimes(imageIdx)));
                    logRadianceMapDenominator = logRadianceMapDenominator + WeightFunction(imgStack(imageIdx, heightIdx, widthIdx), exposureTimes(imageIdx), weightingFcn);
                end
            end
            
            if logRadianceMapDenominator == 0 % for pixels that weren't exposed correctly in any picture, assign the NaN value
                logRadianceMap(heightIdx, widthIdx) = NaN;
            else
                logRadianceMap(heightIdx, widthIdx) = logRadianceMapNominator / logRadianceMapDenominator;
            end
            
        end
    end
    
    logRadianceMapMinValue = min(min(logRadianceMap)); % handle erroneously exposed pixels
    logRadianceMap(isnan(logRadianceMap)) = logRadianceMapMinValue; % by setting their values to the minimum valid value
    radianceMap = exp(logRadianceMap); % get the radiance map by exponentiating its logarithm
end