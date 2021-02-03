clc;
close all;
clear;

[mono,sampleRate] = audioread("surfer_320kbps_48000hz.mp3");

N = sampleRate / 2;
B = mono;
% Rest mit Nullen fuellen
B(end+1 : N * ceil(numel(B) / N)) = 0;

matrix = reshape(B, N, size(B, 1) / N);

matrix_fft = abs(fft(matrix));

freq = linspace(0, sampleRate, 36);
time = linspace(0, 17, N);

surf(freq, time, matrix_fft, "EdgeColor", "none", "LineStyle", "none");
view(24,33);