function Demo2()
    imagesTotal = 16;
    imagesHeight = 1400;
    imagesWidth = 2100;
    imagesChannelsTotal = 3;
    exposureTimes = [1/2500 1/1000 1/500 1/250 1/125 1/60 1/30 1/15 1/8 1/4 1/2 1 2 4 8 15];
    
    imgStack = zeros(imagesTotal, imagesHeight, imagesWidth, imagesChannelsTotal);
    for imageIdx = 1 : imagesTotal % load images and normalize them to range [0, 1]
        imgStack(imageIdx,:,:,:) = imread(sprintf('Image1/exposure%d.jpg',imageIdx));
        imgStack(imageIdx,:,:,:) = imgStack(imageIdx,:,:,:) / 255;
    end
    
    gamma = 0.2;
    weightFunctionIdx = 4;
    rgbImage = zeros(imagesHeight, imagesWidth, imagesChannelsTotal, 'uint8');
    for colorIdx = 1 : imagesChannelsTotal % for each color channel
        radianceMap = mergeLDRStack(imgStack(:,:,:, colorIdx), exposureTimes, weightFunctionIdx); % calculate radiance map
        radianceMap = radianceMap - min((min(radianceMap))); % normalize radiance map to range [0, 1]
        radianceMap = radianceMap / max(max(radianceMap));
        rgbImage(:,:, colorIdx) = toneMapping(radianceMap, gamma); % calculate image's color channel
    end
    
    imshow(rgbImage); % show image
end