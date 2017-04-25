clc;clear all;close all;
%% camera data load
% Access an image acquisition device.
vidobj = videoinput('winvideo', 2, 'YUY2_640x480');

% Configure the number of frames to log.
vidobj.FramesPerTrigger = 180;

% Skip the first few frames the device provides
% before logging data.
vidobj.TriggerFrameDelay = 5;

% Access the device's video source.
src = getselectedsource(vidobj);

src.ExposureMode = 'manual';
src.Exposure = -7;

% Determine the device specific frame rates (frames per second) available.
frameRates = set(src, 'FrameRate')

% Configure the device's frame rate to the highest available setting.
src.FrameRate = frameRates{1};
actualRate = str2num( frameRates{1} )

com3=serial('COM3');
% set(a,'BaudRate',9600); %设置波特率s
%9号是信号线
fopen(com3);%打开串口对象

pause(3);
disp(com3);
% disp('open com3');

fprintf(com3,'1');
% Start the acquisition.
start(vidobj)
% idn = fscanf(a);
% disp(idn);

% fclose(a);
%  delete(instrfind({'Port'},{'COM3'}));
% % Start the acquisition.
% start(vidobj)

% Wait for data logging to end before retrieving data.  Set the wait time
% to be equal to the expected time to acquire the number of frames
% specified plus a little buffer time to accommodate  overhead.
waittime = actualRate * (vidobj.FramesPerTrigger + vidobj.TriggerFrameDelay) + 5;
wait(vidobj, waittime);

% Retrieve the data and timestamps.
[frames, timeStamp] = getdata(vidobj);

% Graph frames vs time.
figure;
plot(timeStamp,'x')
xlabel('Frame Index')
ylabel('Time(s)')

% Find the time difference between frames.
diffFrameTime = diff(timeStamp);

% Graph the time differences.
figure;
plot(diffFrameTime, 'x');
xlabel('Frame Index')
ylabel('Time Difference(s)')
% ylim([0 .12])

% Find the average time difference between frames.
avgTime = mean(diffFrameTime);

% Determine the experimental frame rate.
expRate = 1/avgTime


% Determine the percent error between the determined and actual frame rate.
diffRates = abs(actualRate - expRate);

percentError = (diffRates/actualRate) * 100;

% Once the video input object is no longer needed, delete
% it and clear it from the workspace.
delete(vidobj)
clear vidobj
fclose(com3);
delete(instrfind({'Port'},{'COM3'}));
% save('frames.mat','frames')


%% 3D

%% parameter initialization
sDis=0.2;                    %----------------------------20cm laser camera distance
sRotation=0.105;             %----------------------------laser rotation distance
pixelSize=2.2e-6;            %----------------------------2.2um
angle=82/180*pi;             %----------------------------laser angle
% focal=0.001684349200525;
load('fc.mat');
focal=(fc(2))*pixelSize;
tempAngle=(1:480)';
tempAngle=-pixelSize*(tempAngle-240);
% temp=-temp;
surToSurAngle=atan(tempAngle/focal);%distance surface-base surface angle
rotationAngle=1:180;
focalTransform=focal./(cos(surToSurAngle));%distance surface facla
posXall=[];
posYall=[];
posZall=[];
% qAll=[];
%% camera data load
% fileName='video6.avi';
% mov=VideoReader(fileName);
% load('frames.mat');
data=frames;
% sta=136;
% qtest=0.5*ones(480,1);
% qtest=qtest./cos(surfaceToSurfaceAngle);
%% 3D reconstruction
for ii=rotationAngle
    rotAngle=ii;
%     q=rand(480,1); %get distance
%     frameNow=read(mov,rotAngle+189);
    frameNow=data(:,:,:,ii);        %-------------Ycbcr image
%     imageData=rgb2ycbcr(frameNow);
    imageData=frameNow(:,:,1);
    q=getDistance(imageData);
%     q=qtest./cos(rotAngle/180*pi);
%     qAll=[qAll q];
    posY=q.*cos(surToSurAngle);%480*1 position
    posZ=q.*sin(surToSurAngle);
    posX=posY./tan(angle)-sRotation;
%     posObj=[posX posY posZ];
    offsetAngle=-(0+rotAngle-90)/180*pi;
    posXtrue=posX*cos(offsetAngle)+posY*sin(offsetAngle);
    posYtrue=posY*cos(offsetAngle)-posX*sin(offsetAngle);
    posZtrue=posZ;
    posXall=[posXall posXtrue];
    posYall=[posYall posYtrue];
    posZall=[posZall posZtrue];
end
%% plot figure
figure;mesh(posXall,posYall,posZall)
xlabel('x')
ylabel('y')
zlabel('z')
% figure;plot3(positionXall,positionYall,positionZall)
% figure;scatter3(positionXall(:),positionYall(:),positionZall(:))

% [x,y]=meshgrid(positionXall(:),positionYall(:));
% z=positionZall(:);
% figure;surf(x,y,z)
xyz=[posXall(:) posYall(:) posZall(:)];
indesNaN=~isnan(xyz);
xyz1=xyz(indesNaN);
xyz=reshape(xyz1,length(xyz1)/3,3);
save('pos.txt','xyz','-ascii')