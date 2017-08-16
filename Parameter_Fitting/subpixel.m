clc;close all;clear all 
load('dist60.mat');
figure;imshow(data(:,:,1));
title('次像素点提取')
hold on;
img=data(:,:,1);
ind=(1:640)';
I=double(img(:,400:470));
subPixel=I*ind(400:470)./sum(I,2);
plot(subPixel,1:480,'r')