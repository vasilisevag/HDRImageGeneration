function Demo1()
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
    
    functionsTotal = 4; % for each color channel
    for colorIdx = 1 : imagesChannelsTotal % and for each weight function
        for functionIdx = 1 : functionsTotal % calculate the radiance map
            radianceMap = log(mergeLDRStack(imgStack(:,:,:, colorIdx), exposureTimes, functionIdx));
            figure((colorIdx-1)*functionsTotal + functionIdx); % and plot it with the corresponding histogram
            if functionIdx == 1 
                sgtitle(sprintf("Radiance Map for color channel %d and weight function uniform", colorIdx)); 
            end 
            if functionIdx == 2 
                sgtitle(sprintf("Radiance Map for color channel %d and weight function tent", colorIdx)); 
            end
            if functionIdx == 3 
                sgtitle(sprintf("Radiance Map for color channel %d and weight function gaussian", colorIdx)); 
            end
            if functionIdx == 4 
                sgtitle(sprintf("Radiance Map for color channel %d and weight function photon", colorIdx)); 
            end
            subplot(1, 2, 1);
            imagesc(radianceMap);
            colorbar;
            subplot(1, 2, 2);
            hist(radianceMap(:), 200); % convert matrix to a vector in order to use the hist function
        end
    end
end