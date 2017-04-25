function [ output_args ] = getDistance( data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

sDis=0.20;%20cm
pixelSize=2.2e-6;%2.2um
angle=82/180*pi;
% focal=0.001684349200525;
load('fc.mat');
focal=(fc(2))*pixelSize;
temp=1:480;
temp=pixelSize*abs(temp-240);
tempAngle=atan(temp/focal);
focalTransform=focal./(cos(tempAngle));
% focalTransform=focal*ones(1,480);
data=data(:,:,1);
[T,SM]=graythresh(data);
data=im2bw(data,T);
indes=getInd(data);
xDis=(indes-320)*pixelSize+focalTransform/tan(angle);%focalChange/tan(angle)  is xOffert
qChange=focalTransform*sDis./xDis;%NaN maybe 
% qDis=qChange.*cos(tempAngle);  
qDis=qChange;
output_args=qDis';


end

