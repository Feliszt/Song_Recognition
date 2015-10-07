 %% Load 3 recordings
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

   % uncomment to create the frIsequence matrix from the audio
% frIsequence1 = GetMusicFeatures(mel1, fe, 0.02) ;
% frIsequence2 = GetMusicFeatures(mel2, fe, 0.02) ;
% frIsequence3 = GetMusicFeatures(mel3, fe, 0.02) ;

   % get the abscisses (number of windows)
abs1 = (1:length(frIsequence1)) ;
abs2 = (1:length(frIsequence2)) ;
abs3 = (1:length(frIsequence3)) ;

   % plot pitch
figure
subplot(3,1,1)
plot(abs1, frIsequence1(1,:)), title('pitch melody 1'), ylabel('pitch (Hz)'), xlabel('window number') ;
subplot(3,1,2)
plot(abs2, frIsequence2(1,:)), title('pitch melody 2'), ylabel('pitch (Hz)'), xlabel('window number') ;
subplot(3,1,3)
plot(abs3, frIsequence3(1,:)), title('pitch melody 3'), ylabel('pitch (Hz)'), xlabel('window number') ;


   % plot intensity profile
figure
subplot(3,1,1)
plot(abs1, frIsequence1(3,:)), title('Intensity profile melody 1'), ylabel('intensity'), xlabel('window number') ;
subplot(3,1,2)
plot(abs2, frIsequence2(3,:)), title('Intensity profile melody 2'), ylabel('intensity'), xlabel('window number') ;
subplot(3,1,3)
plot(abs3, frIsequence3(3,:)), title('Intensity profile melody 3'), ylabel('intensity'), xlabel('window number') ;


   %% Call feature extractor

