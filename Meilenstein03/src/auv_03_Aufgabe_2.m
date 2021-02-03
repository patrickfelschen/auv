%created by Julius Schoening
%edited by Patrick Felschen, Julian Voss
clc;
close all;
clear;

%variables
A1=2; %amplitude signal 2
playbacktime = 2.5; % in seconds
sampleRate = 1000; % in Hz
F1 = 600; %frequency signal 1, 600 Hz
plotTime = 2/F1;

t = linspace(0, playbacktime, playbacktime*sampleRate);

%output graph preparation

tt = t.^t;

factor = 100;
signal=round((A1*(sin(pi*F1*tt)./tt))*factor)/factor; % Signal equation

audioData = [signal ; t];

%plot signal(t) and its amplitude
subplot(1,1,1);
plot(t,signal);

xlim([0, playbacktime]);
xlabel('time(s)');
ylabel('signal(t)');
ax = gca;
ax.XAxisLocation = 'origin';

sound(signal,sampleRate);