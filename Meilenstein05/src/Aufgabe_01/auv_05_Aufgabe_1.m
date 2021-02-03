%created by Patrick Felschen, Julian Voss
%Lecture: Audio und Videotechnik

clc;
clear;
close all;

img = double(imread('space.png'));
ori = uint8(img);

%% Farbkanaele in Bloecke aufteilen
imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);

blocksize = 32;

N = blocksize*ones(1,16);
blocksR = mat2cell(imgR,N,N);
blocksG = mat2cell(imgG,N,N);
blocksB = mat2cell(imgB,N,N);

dctR = blocksR;
dctG = blocksG;
dctB = blocksB;

%% Quantisierungsmatrix aufstellen
quality = 6;
Q = [];
for i = 0 :blocksize-1
    for j = 0: blocksize-1
        Q(i+1,j+1)=1+(1+i+j)*quality;
    end
end

%% Bloecke iterieren, transformieren, quantisieren und rekonstruieren
for i=1: size(blocksR)
    for j=1: size(blocksR)
        I = blocksR{i, j};
        %Kodierung
        f = I - 128;
        DCT = dct2(f);
        P = round(DCT./Q);
        dctR{i ,j} = P;
        %Dekodierung
        F_rec = P.*Q;
        f_rec = idct2(F_rec);
        I_rec = f_rec + 128;
        blocksR{i, j} = I_rec;
    end
end

for i=1: size(blocksG)
    for j=1: size(blocksG)
        I = blocksG{i, j};
        %Kodierung
        f = I - 128;
        DCT = dct2(f);
        P = round(DCT./Q);
        dctG{i ,j} = P;
        %Dekodierung
        F_rec = P.*Q;
        f_rec = idct2(F_rec);
        I_rec = f_rec + 128;
        blocksG{i, j} = I_rec;
    end
end

for i=1: size(blocksB)
    for j=1: size(blocksB)
        I = blocksB{i, j};
        %Kodierung
        f = I - 128;
        DCT = dct2(f);
        P = round(DCT./Q);
        dctB{i ,j} = P;
        %Dekodierung
        F_rec = P.*Q;
        f_rec = idct2(F_rec);
        I_rec = f_rec + 128;
        blocksB{i, j} = I_rec;
    end
end

%% Matrix wiederherstellen
matR = cell2mat(blocksR);
matG = cell2mat(blocksG);
matB = cell2mat(blocksB);

matDctR = cell2mat(dctR);
matDctG = cell2mat(dctG);
matDctB = cell2mat(dctB);

imgOut(:,:,1) = uint8(matR);
imgOut(:,:,2) = uint8(matG);
imgOut(:,:,3) = uint8(matB);

dctOut(:,:,1) = matDctR;
dctOut(:,:,2) = matDctG;
dctOut(:,:,3) = matDctB;

%% Plot
set(gcf, 'WindowState', 'maximized');

subplot(1,3,1);
imshow(ori, []);

subplot(1,3,2);
imshow(dctOut, []);

subplot(1,3,3);
imshow(imgOut, []);

imwrite(ori, 'original.png');
imwrite(dctOut, 'dct.png');
imwrite(imgOut, 'reconst.png');