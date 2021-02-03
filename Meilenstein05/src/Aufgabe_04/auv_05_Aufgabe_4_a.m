%created by Patrick Felschen, Julian Voss
%Lecture: Audio und Videotechnik
clc;
clear;
close all;

%% Einlesen
ton_d = audioread('d.flac');
ton_g = audioread('g.flac');
audio = audioread('dgggddgd.flac');

sampleRate = 44100;
fragment_size = sampleRate / 100;

%% Einteilen
ton_d_mat = reshape(ton_d, fragment_size, []);
ton_g_mat = reshape(ton_g, fragment_size, []);
audio_mat = reshape(audio, fragment_size, []);

%% Fourier transformieren
fft_ton_d = abs(fft(ton_d_mat, [], 1));
fft_ton_g = abs(fft(ton_g_mat, [], 1));
fft_audio = abs(fft(audio_mat, [], 1));

%% Vergleichen

i = 1;
result = '';
tolerance = 2.0;

while i <= size(fft_audio, 2)
    
    diff2ton_d = abs((fft_audio(1:50,i:i+99)) - (fft_ton_d(1:50,:)));
    diff2ton_g = abs((fft_audio(1:50,i:i+99)) - (fft_ton_g(1:50,:)));
    
    if(max(diff2ton_d) <= tolerance)
        result = append(result, ' d');
    end
    
    if(max(diff2ton_g) <= tolerance)
        result = append(result, ' g');
    end
    
    i = i + 100;
end

%% Plot
result

figure;
plot(audio);
figure;
imagesc(fft_audio(1:50,:));
