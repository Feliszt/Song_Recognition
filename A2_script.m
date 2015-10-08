 %% clear everything
clear all
close all
clc

%% Load 3 recordings

   % load the files and get the frequencis
% [mel1, fe] = audioread('melody_1.wav') ;
% mel2 = audioread('melody_2.wav') ;        
% mel3 = audioread('melody_3.wav') ;

   % create the vector of frequencies of from the 1st to the 4th scale
frequencies = [ 65.41 , 69.30 , 73.42, 77.78, 82.41, 87.31, 92.50, 98.80, 103.83, 
   % uncomment to play the sweet tunes
sound(mel2, fe)

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
% set(gca, 'Yscale', 'log'),
[ax, ~, ~] = plotyy(abs1, log(frIsequence1(1,:)), abs1, log(frIsequence1(3,:)));
title('melody 1'),
ylabel(ax(1),'pitch (Hz)') % label left y-axis
ylabel(ax(2),'Intensity') % label right y-axis
xlabel('window number') ;

subplot(3,1,2)
% set(gca, 'Yscale', 'log'),
[ax, ~, ~] = plotyy(abs2, frIsequence2(1,:), abs2, frIsequence2(3,:));
title('melody 2'),
ylabel(ax(1),'pitch (Hz)') % label left y-axis
ylabel(ax(2),'Intensity') % label right y-axis
xlabel('window number') ;

subplot(3,1,3)
% set(gca, 'Yscale', 'log'),
[ax, ~, ~] = plotyy(abs3, frIsequence3(1,:), abs3, frIsequence3(3,:)); 
title('melody 3'), 
ylabel(ax(1),'pitch (Hz)') % label left y-axis
ylabel(ax(2),'Intensity') % label right y-axis
xlabel('window number') ;


   %% Call feature extractor
close all

frIsequence = frIsequence3 ;
abs = abs3 ;

  % Isolate the log-pitch and the log-intensity
pitch = frIsequence(1,:) ;
intensity = log(frIsequence(3,:)) ;
corr = frIsequence(2,:) ;

  % Search the mean of intensity and pitch
meanI = mean(intensity) ; 
meanP = mean(pitch) ;

  % Substract the mean pitch to the pitch so that the same song sung higher
  % or slower can still be recognize
% pitch = pitch - meanP ;


  % Separation between notes and silences can ealisy be found by
  % thresholding the intensity
binnote = intensity < meanI == 0 ;
binnote = intensity >= meanI == 1 ;
% binnote = pitch < meanP == 1 ;
% binnote = pitch >= meanP == 0 ;


  % plot to see if correct
% figure
% [ax, ~, ~] = plotyy(abs1, pitch, abs1, binnote);
% title('melody 1'),
% ylabel(ax(1),'pitch (Hz)') % label left y-axis
% ylabel(ax(2),'Intensity') % label right y-axis
% xlabel('window number') ;

  % get rid of the high pitch rendered by the silences
pitch_note = pitch .* binnote ;
   
  % plot to see the difference
figure
subplot(2,1,1)
plot(abs, pitch)
subplot(2,1,2)
plotyy(abs, pitch_note, abs, intensity)

% we managed to eliminate the noisiness in the beginning and the end of the
% audio file, it is not useful to us since it can be created by noise close
% to the micro or the micro itself


binnote_label = bwlabel(binnote) ;
N_note = max(binnote_label) ;
notes = [] ;
figure
for i = 1:N_note
    % get the binary vector that represents the note
   binnotei = binnote_label == i ; 
   binnotei = binnotei >= 1 == 1 ;
   
   % get the note itself
   pitch_notei = pitch_note .* binnotei ;
   pitch_notei = pitch_notei(binnotei) ;
   
   % get the length of the note
   lengthnote = length(pitch_notei) ;
   
   % verify that the note is not too short (it can be noise)
   if lengthnote < 10
       
   else       
        plot(1:lengthnote, pitch_notei) ;
        notes = [ notes mean(pitch_notei) ] ;
   end
end

quotnotes = zeros(1,length(notes)-1) ;
for i=1:length(notes)-1
   quotnotes(i) = notes(i) / notes(i+1) ;    
end
   

    %% plot features

figure
subplot(411)
plot(quotnotes1)
subplot(412)
plot(quotnotes2)
subplot(413)
plot(quotnotes3)
subplot(414)
plot(quotnotes4)
    
    