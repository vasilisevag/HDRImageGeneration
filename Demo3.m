function Demo3()
    firstImageSetTotal = 16; % first image set
    firstImageSetHeight = 1400;
    firstImageSetWidth = 2100;
    firstImageSetChannelsTotal = 3;
    firstImageSetExposureTimes = [1/2500 1/1000 1/500 1/250 1/125 1/60 1/30 1/15 1/8 1/4 1/2 1 2 4 8 15];
    
    firstImgSet = zeros(firstImageSetTotal, firstImageSetHeight, firstImageSetWidth, firstImageSetChannelsTotal);
    for imageIdx = 1 : firstImageSetTotal % load first image set
        firstImgSet(imageIdx,:,:,:) = imread(sprintf('Image1/exposure%d.jpg',imageIdx));
    end
    
    weightFunctionIdx = 3;
    smoothingFactor = 2;
    gammaFactor = 0.2;
    firstSetRgbImage = zeros(firstImageSetHeight, firstImageSetWidth, firstImageSetChannelsTotal, 'uint8');
    for colorIdx = 1 : firstImageSetChannelsTotal % for each color channel estimate the response curve
        responseCurve = estimateResponseCurve(firstImgSet(:,5:505 ,2000, colorIdx)', firstImageSetExposureTimes, smoothingFactor, weightFunctionIdx);
        figure(colorIdx);
        plot(responseCurve, 1:1:256);
        xlabel("exposure time");
        ylabel("pixel value");
        title("response curve");
        for imageIdx = 1 : firstImageSetTotal
            for heightIdx = 1 : firstImageSetHeight
                for widthIdx = 1 : firstImageSetWidth % then callibrate the image pixels using the response curve
                    firstImgSet(imageIdx, heightIdx, widthIdx, colorIdx) = exp(responseCurve(firstImgSet(imageIdx, heightIdx, widthIdx, colorIdx) + 1));
                end
            end
        end % calculate the radiance map with the callibrated images as input
        firstImgSet(:,:,:, colorIdx) = firstImgSet(:,:,:, colorIdx) / max(max(max(firstImgSet(:,:,:, colorIdx))));
        radianceMap = mergeLDRStack(firstImgSet(:,:,:,colorIdx), firstImageSetExposureTimes, weightFunctionIdx); 
        radianceMap = radianceMap - min((min(radianceMap))); % normalize radiance map so that
        radianceMap = radianceMap ./ max(max(radianceMap)); % toneMapping precondition holds true
        firstSetRgbImage(:,:,colorIdx) = toneMapping(radianceMap, gammaFactor); % calculate image's color channel
    end
    figure(4);
    imshow(firstSetRgbImage); % show image
    
    %-----------------------------------------------%
    secondImageSetTotal = 7; % second image set
    secondImageSetHeight = 723;
    secondImageSetWidth = 1087;
    secondImageSetChannelsTotal = 3;
    secondImageSetExposureTimes = [1/400, 1/250, 1/100, 1/40, 1/25, 1/8, 1/3];
    
    secondImgSet = zeros(secondImageSetTotal, secondImageSetHeight, secondImageSetWidth, secondImageSetChannelsTotal);
    for imageIdx = 0 : secondImageSetTotal-1 % load second image set
        secondImgSet(imageIdx + 1,:,:,:) = imread(sprintf('Image2/sample2-0%d.jpg',imageIdx));
    end
    
    weightFunctionIdx = 3;
    smoothingFactor = 20;
    gammaFactor = 0.2;
    secondSetRgbImage = zeros(secondImageSetHeight, secondImageSetWidth, secondImageSetChannelsTotal, 'uint8');
    for colorIdx = 1 : secondImageSetChannelsTotal % for each color channel estimate the response curve
        responseCurve = estimateResponseCurve(secondImgSet(:, 5:550, 300, colorIdx)', secondImageSetExposureTimes, smoothingFactor, weightFunctionIdx);
        figure(4 + colorIdx);
        plot(responseCurve, 1:1:256);
        xlabel("exposure time");
        ylabel("pixel value");
        title("response curve");
        for imageIdx = 1 : secondImageSetTotal
            for heightIdx = 1 : secondImageSetHeight
                for widthIdx = 1 : secondImageSetWidth % then callibrate the image pixels using the response curve
                    secondImgSet(imageIdx, heightIdx, widthIdx, colorIdx) = exp(responseCurve(secondImgSet(imageIdx, heightIdx, widthIdx, colorIdx) + 1));
                end
            end
        end % calculate the radiance map with the callibrated images as input
        secondImgSet(:,:,:, colorIdx) = secondImgSet(:,:,:, colorIdx) / max(max(max(secondImgSet(:,:,:, colorIdx))));
        radianceMap = mergeLDRStack(secondImgSet(:,:,:,colorIdx), secondImageSetExposureTimes, weightFunctionIdx); 
        radianceMap = radianceMap - min((min(radianceMap))); % normalize radiance map so that
        radianceMap = radianceMap ./ max(max(radianceMap)); % toneMapping precondition holds true
        secondSetRgbImage(:,:,colorIdx) = toneMapping(radianceMap, gammaFactor); % calculate image's color channel
    end
    figure(8);
    imshow(secondSetRgbImage); % show image