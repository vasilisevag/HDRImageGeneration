function tonedImage = toneMapping (radianceMap , gamma) % precondition: radiance map values belong to the range [0, 1]
    imageHeight = size(radianceMap, 1);
    imageWidth = size(radianceMap, 2);
    tonedImage = zeros(imageHeight, imageWidth, 'uint8'); % initialize output image
    
    for heightIdx = 1 : imageHeight 
        for widthIdx = 1 : imageWidth
            tonedImage(heightIdx, widthIdx) = 256*(radianceMap(heightIdx, widthIdx)^gamma); % gamma correction
        end
    end
end