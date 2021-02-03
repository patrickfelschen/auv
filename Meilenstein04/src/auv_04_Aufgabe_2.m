clc;
close all;
clear;

img = imread('img/moon.bmp');
info = imfinfo('img/moon.bmp');

hoehe = size(img, 1);
breite = size(img, 2);

fileID = fopen('moon_compressed.txt','w');
fprintf(fileID, '%i:%i\n', hoehe, breite);

anzahl = 1;
current = img(1 ,1);

for i = 1: 1:hoehe
    
    for j = 1: 1:breite
        
        zeichen = img(i, j);
        
        if current == zeichen
            anzahl = anzahl + 1;
        else
            fprintf(fileID, '%i%i', anzahl, current);
            anzahl = 1;
            current = zeichen;
        end
        
    end
    
end

fclose(fileID);