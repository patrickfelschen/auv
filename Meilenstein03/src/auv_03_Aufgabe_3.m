%created by Julius Schoening
%edited by Patrick Felschen, Julian Voss
clc;
close all;
clear;

%variables
playbacktime = 2.0; % in seconds
sampleRate = 44100; % in Hz
F=2; %frequency signal, 3 Hz
plotTime = 2/F;

t = linspace(0, playbacktime, playbacktime*sampleRate);

%output graph preparation

signal1 = 1.0 * sin(1*F*pi*t);
signal2 = 0.5 * sin(2*F*pi*t);
signal3 = 0.3 * sin(3*F*pi*t);
signal4 = 0.1 * sin(10*F*pi*t);
signal5 = 0.08 * sin(12*F*pi*t);

signalFFT = signal1 + signal2 + signal3 + signal4 + signal5;

%plot signal(t) and its amplitude
subplot(1,2,1);
plot(t,signalFFT);
xlim([0, playbacktime]);
xlabel('time(s)');
ylabel('signal(t)');
ax = gca;
ax.XAxisLocation = 'origin';

subplot(1,2,2)
plot(t, fft(signalFFT));

xlim([0, 15]);
ylim([0, 2]);
xlabel('f(Hz)');
ylabel('|A|')

