%created by Patrick Felschen, Julian Voss
%Lecture: Audio und Videotechnik
clc;
clear;
close all;

%% Einlesen

%ton_ja = audioread('ja_f.flac');
ton_ja = audioread('ja_m.flac');

%ton_nein = audioread('nein_f.flac');
ton_nein = audioread('nein_m.flac');

%audio = audioread('synthetic_Ja_Nein_Nein_Nein_Ja_Ja_Nein_Nein_Ja.flac');
audio = audioread('voice_Ja_Nein_Nein_jein_Ja_Ja_Nein_Nein_Ja_Nein.flac');

sampleRate = 44100;
fragment_size = sampleRate / 100;

%% Einteilen

ton_ja(end+1:fragment_size*ceil(numel(ton_ja)/fragment_size)) = 0;
ton_nein(end+1:fragment_size*ceil(numel(ton_nein)/fragment_size)) = 0;
audio(end+1:fragment_size*ceil(numel(audio)/fragment_size)) = 0;

ton_ja_mat = reshape(ton_ja, fragment_size, []);
ton_nein_mat = reshape(ton_nein, fragment_size, []);
audio_mat = reshape(audio, fragment_size, []);

%% Fourier transformieren
fft_ton_ja = abs(fft(ton_ja_mat, [], 1));
fft_ton_nein = abs(fft(ton_nein_mat, [], 1));
fft_audio = abs(fft(audio_mat, [], 1));

%% Vergleichen

i = 1;
result = '';
tolerance = 14;

ja_size = size(fft_ton_ja, 2);
nein_size = size(fft_ton_nein, 2);

while i+ja_size-1 <= size(fft_audio, 2)
    
    diff2ton_ja = abs((fft_audio(1:50,i:i+ja_size-1)) - (fft_ton_ja(1:50,:)));
    diff2ton_nein = abs((fft_audio(1:50,i:i+nein_size-1)) - (fft_ton_nein(1:50,:)));
    
    if(max(diff2ton_ja) <= tolerance)
        result = append(result, ' ja');
        i = i + ja_size;
    elseif(max(diff2ton_nein) <= tolerance)
        result = append(result, ' nein');
        i = i + nein_size;
    else
        i = i + 1;
    end
    
end

%% Plot
result

figure;
plot(audio);
figure;
imagesc(fft_audio(1:50,:));
