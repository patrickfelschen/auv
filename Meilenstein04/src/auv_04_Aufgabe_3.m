clc;
close all;
clear;

img = im2double(imread('img/malojapass.png'));
farbstufe_8 = linspace(0,1,8);
farbstufe_32 = linspace(0,1,32);
farbstufe_128 = linspace(0,1,128);

rounded_8 = interp1(farbstufe_8,farbstufe_8,img,'nearest');
rounded_32 = interp1(farbstufe_32,farbstufe_32,img,'nearest');
rounded_128 = interp1(farbstufe_128,farbstufe_128,img,'nearest');

figure;
imshow(rounded_8);

figure;
imshow(rounded_32);

figure;
imshow(rounded_128);