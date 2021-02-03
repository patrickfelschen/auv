%created by Patrick Felschen, Julian Voss
%Lecture: Audio und Videotechnik

clc;
clear;
close all;

framerate = 25;
length = 3; %in Sekunden

v = VideoWriter('auv_05_Aufgabe_2.mp4', 'MPEG-4');

v.FrameRate = framerate;

open(v);

I = imread('rad.png');

rad1 = I;
rad2 = I;
rad3 = I;
rad4 = I;
rad5 = I;
rad6 = I;

% 1 Raddrehung = 360/25
for i=1:framerate*length
    rad1 = imrotate(rad1, -360/25, 'bilinear', 'crop'); %1 Umdrehung pro Sekunde
    rad2 = imrotate(rad2, (-360/25)/2, 'bilinear', 'crop'); %1/2 Umdrehung pro Sekunde
    rad3 = imrotate(rad3, (-360/25)*(framerate + 1), 'bilinear', 'crop'); %Mehr als eine Umdrehung pro Frame
    rad4 = imrotate(rad4, -360, 'bilinear', 'crop'); %1 Umdrehung pro Frame
    rad5 = imrotate(rad5, (-360/25)*(framerate - 0.5), 'bilinear', 'crop'); %Fast eine Umdrehung pro Frame
    rad6 = imrotate(rad6, (-360/25)*(framerate - 1), 'bilinear', 'crop');%Etwas weniger als vorher, dadurch wirkt die Drehung schneller
    
    tile = imtile({rad1,rad2,rad3,rad4,rad5,rad6}, [2 3]);
    
    writeVideo(v, tile);
end

close(v);

