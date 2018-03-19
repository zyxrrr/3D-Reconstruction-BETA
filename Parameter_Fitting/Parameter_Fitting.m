clear all;close all;clc;
% focal=4e-3;%4mm
s=0.2;%20cm
pixelSize=2.2e-6;%2.2um
angle=82/180*pi;
load('fc.mat');
focal=(fc(2))*pixelSize;
% focal=0.001684349200525;
ind=[584 506 450 428 382 354 340 397 482 334 502 489 490];
qActual=[33 43 54 60 75 89 98 69 47 103 44 47]*1e-2;%cm
x=(ind-320)*pixelSize+focal/tan(angle);
q=focal.*s./x;
% qtest=sort([q ; qActual],2);


%% Parameter Fiting
% get angle and s
