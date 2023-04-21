function responseCurve = estimateResponseCurve (imgStack, exposureTimes, smoothingLamda, weightingFcn)
    responseCurveSize = 256; % precondition 1: pixelsTotal*(imagesTotal-1) > (Zmax - Zmin)
    imagesTotal = size(imgStack, 2); % precondition 2: Z belongs to the range [0, 255]
    pixelsTotal = size(imgStack, 1);
    
    A = zeros(imagesTotal * pixelsTotal + responseCurveSize + 1, responseCurveSize + pixelsTotal);
    b = zeros(size(A,1), 1); % define matrix A and b (their dimensions)
    
    row = 1;
    for pixelIdx = 1 : pixelsTotal
        for imageIdx = 1 : imagesTotal % calculate the first term (ensures that the solution satisfies equation 2 from Debevec's paper)
            pixelWeight = WeightFunctionRange0_255(imgStack(pixelIdx, imageIdx) + 1, weightingFcn);
            A(row, imgStack(pixelIdx, imageIdx) + 1) = pixelWeight;
            A(row, responseCurveSize + pixelIdx) = -pixelWeight;
            b(row, 1) = pixelWeight * log(exposureTimes(imageIdx));
            row = row + 1;
        end
    end
   
    A(row, 129) = 1;
    row = row + 1;
    
    for i = 1 : responseCurveSize - 2 % calculate the second term (ensures that the function g is smooth)
        A(row, i) = smoothingLamda * WeightFunctionRange0_255(i + 1, weightingFcn);
        A(row, i+1) = -2 * smoothingLamda * WeightFunctionRange0_255(i + 1, weightingFcn);
        A(row, i+2) = smoothingLamda * WeightFunctionRange0_255(i + 1, weightingFcn);
        row = row + 1;
    end
   
    x = (A\b); % solves the optimization problem
    responseCurve = x(1:responseCurveSize); % get the response curve (x includes the radiance map as well)
end