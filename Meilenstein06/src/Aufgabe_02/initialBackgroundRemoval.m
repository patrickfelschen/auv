% Programmzeilen mit * gekennzeichnet muessen fuer die Aufgabe 2.a nicht im
% Projekbereicht erklaert werden.
clear %*
close all %*
v = VideoReader(fullfile('videos', 'combineColoredBackground.mp4'));
s = VideoReader(fullfile('videos','scene.mp4'));

video=zeros(v.Height,v.Width,3,floor(v.Duration/(1/v.FrameRate))-2,'uint8');
t=1;%*
threshold = 0.9 ;
first_frame = im2double(read(v, 1));

while hasFrame(v)
    Img = im2double(readFrame(v));
    mask = sqrt(first_frame(:,:,1) - Img(:,:,1).^2 + first_frame(:,:,2) - Img(:,:,2).^2 + first_frame(:,:,3) - Img(:,:,3).^2) < threshold;
    video(:,:,:,t) = imoverlay(im2uint8(Img),mask,[0 0 0]);
    imshow(video(:,:,:,t));
    t=t+1;%*
end

videoOut = VideoWriter('result.mp4','MPEG-4');
videoOut.FrameRate=v.FrameRate;
open(videoOut);
moveX=0;%*

filter = fspecial('average', 16);

for t=1:1:size(video,4)
    im = video(:,:,:,t);
    mask = im(:,:,1)+im(:,:,2)+im(:,:,3)==0;
   
    background = imfilter(readFrame(s), filter);
    frame=imoverlay(readFrame(s),~mask,[0 0 0]);
    
    frame=frame+im;
    writeVideo(videoOut,frame);
    imshow(frame);
end
close(videoOut);
