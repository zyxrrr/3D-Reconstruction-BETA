function [ indes_output ] = getInd( image )
%input a image, output the light position

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

