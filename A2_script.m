   %% Plots of 3 recordings
clear all
close all
clc

   % load the files and get the frequencis
[mel1, fe] = audioread('melody_1.wav') ;
mel2 = audioread('melody_2.wav') ;
mel3 = audioread('melody_3.wav') ;

   % uncomment to play the sweet tunes
%sound(mel1, fe)

   %% Plot the melody on a Time/Amplitude axis
close all

   % abcisse in second
T = (1:length(mel1)) ./ fe ;
  
figure, subplot(2,1,1), plot(T, mel1), title('melody 1'), ylabel('amplitude (V)'), xlabel('time (sec)') ;
subplot(2,1,2), plot(T(800:1100), mel1(800:1100)), title('melody 1 zoomed in'), ylabel('amplitude (V)'), xlabel('time (sec)') ;

   %% Plots of pitch and intensity profile
close all  




