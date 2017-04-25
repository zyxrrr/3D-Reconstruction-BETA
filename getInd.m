function [ indes_output ] = getInd( image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [m n]=size(image);
    indes_output=[];
    for ii=1:m
        midData=image(ii,:);
        indes=find((midData==1));
        ind=(mean(indes));
        if(ind>320)
            indes_output=[indes_output ind];
        else
            indes_output=[indes_output NaN];
        end

    end

end

