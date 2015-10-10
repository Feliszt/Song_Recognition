 %% clear everything
clear all
close all
clc

%% Load 3 recordings

   % load the files and get the frequencis
[mel1, fe] = audioread('melody_1.wav') ;
mel2 = audioread('melody_2.wav') ;        
mel3 = audioread('melody_3.wav') ;

   % create the vector of frequencies of from the 1st to the 4th scale
frequencies = [ 65.41 , 69.30 , 73.42, 77.78, 82.41, 87.31, 92.50, 98.80, 103.83, 110.00, 116.54, 123.47, 130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185.00, 196.00, 207.65, 220.00, 233.09, 246.94, 261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88 ]  ;
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
winlen = 0.03 ;
frIsequence1 = GetMusicFeatures(mel1, fe, winlen) ;
frIsequence2 = GetMusicFeatures(mel2, fe, winlen) ;
frIsequence3 = GetMusicFeatures(mel3, fe, winlen) ;


   % get the abscisses (number of windows)
abs1 = (1:length(frIsequence1)) ;
abs2 = (1:length(frIsequence2)) ;
abs3 = (1:length(frIsequence3)) ;

   % plot pitch
figure
subplot(3,1,1)
[ax, ~, ~] = plotyy(abs1, log(frIsequence1(1,:)), abs1, log(frIsequence1(3,:)));
title('melody 1'),
ylabel(ax(1),'pitch (Hz)') % label left y-axis
ylabel(ax(2),'Intensity') % label right y-axis
xlabel('window number') ;

subplot(3,1,2)
[ax, ~, ~] = plotyy(abs2, frIsequence2(1,:), abs2, frIsequence2(3,:));
title('melody 2'),
ylabel(ax(1),'pitch (Hz)') % label left y-axis
ylabel(ax(2),'Intensity') % label right y-axis
xlabel('window number') ;

subplot(3,1,3)
[ax, ~, ~] = plotyy(abs3, frIsequence3(1,:), abs3, frIsequence3(3,:)); 
title('melody 3'), 
ylabel(ax(1),'pitch (Hz)') % label left y-axis
ylabel(ax(2),'Intensity') % label right y-axis
xlabel('window number') ;

   %% Mean Intensity calculations
close all

    % get intensity
intensity1 = log(frIsequence1(3,:)) ;
intensity2 = log(frIsequence2(3,:)) ;
intensity3 = log(frIsequence3(3,:)) ;

mean1 = mean(intensity1) ;
mean2 = mean(intensity2) ;
mean3 = mean(intensity3) ;

    % calculate all binary vectors of nots
binnote1 = intensity1 < mean1 == 0 ;
binnote1 = intensity1 >= mean1 == 1 ;

binnote2 = intensity2 < mean2 == 0 ;
binnote2 = intensity2 >= mean2 == 1 ;

binnote3 = intensity3 < mean3 == 0 ;
binnote3 = intensity3 >= mean3 == 1 ;
   
   % plot means
% figure
% subplot(3,1,1)
% plot(abs1, intensity1, abs1, mean1.*ones(1,length(intensity1)), abs1, binnote1);
% 
% subplot(3,1,2)
% plot(abs2, intensity2, abs2, mean2.*ones(1,length(intensity2)), abs2, binnote2);
% 
% subplot(3,1,3)
% plot(abs3, intensity3, abs3, mean3.*ones(1,length(intensity3)), abs3, binnote3);


    % clean binnotes



   %% Call feature extractor
close all
clc


frIsequence = frIsequence2 ;
abs = abs2 ;

  % Isolate the log-pitch and the log-intensity
pitch = 1.5*frIsequence(1,:) ;
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
notes = [] ;
% figure
for i = 1:max(binnote_label)
    % get the binary vector that represents the note
   binnotei = binnote_label == i ; 
   binnotei = binnotei >= 1 == 1 ;
   
   % get the note itself
   pitch_notei = pitch_note .* binnotei ;
   pitch_notei = pitch_notei(binnotei) ;
   
   % get the length of the note
   lengthnote = length(pitch_notei) ;
   
   % verify that the note is not too short (it can be noise)
   if lengthnote >= 10
        pitch_notei = pitch_notei(1+round(0.15*lengthnote):lengthnote-round(0.15*lengthnote)) ;
        lengthnote = length(pitch_notei) ;
            % We check if this note is not two notes
        meanstart = mean(pitch_notei(1:round(lengthnote/2))) ;
        meanend = mean(pitch_notei(round(lengthnote/2):end)) ;
        if sqrt(log(meanstart/meanend)*log(meanstart/meanend)) > 0.05
            notes = [ notes meanstart meanend ] ;
        else
            notes = [ notes mean(pitch_notei) ] ;
        end
        
%         subplot(max(binnote_label), 1, i)
%         plot(pitch_notei) ;
%         pause(0.5)
   end
end

    % We get the closest real note for each note
for i=1:length(notes)
   a = frequencies(notes(i) < frequencies) ;
   b = frequencies(notes(i) >= frequencies) ;
   
  if ( a(1)-notes(i) < notes(i)-b(end) )
      notes(i) = a(1) ;
  else
      notes(i) = b(end) ;
  end   
end

    % We then compute the quotient between two consecutives notes
quotnotes = zeros(1,length(notes)-1) ;
for i=1:length(notes)-1
   quotnotes(i) = notes(i) / notes(i+1) ;    
end


   
    %% plot features
    
    close all
clc

   % uncomment to load the files and get the frequencies
% [mel1, fe] = audioread('melody_1.wav') ;
% mel2 = audioread('melody_2.wav') ;        
% mel3 = audioread('melody_3.wav') ;
% 
%    % uncomment to create the frIsequence matrix from the audio
% winlen = 0.03 ;
% frIsequence1 = GetMusicFeatures(mel1, fe, winlen) ;
% frIsequence2 = GetMusicFeatures(mel2, fe, winlen) ;
% frIsequence3 = GetMusicFeatures(mel3, fe, winlen) ;
% frIsequence4 = frIsequence1 ; frIsequence4(1,:) = 1.5*frIsequence4(1,:) ;
% frIsequence5 = frIsequence2 ; frIsequence5(1,:) = 1.5*frIsequence5(1,:) ;
% frIsequence6 = frIsequence3 ; frIsequence6(1,:) = 1.5*frIsequence6(1,:) ;

%     Get features
features1 = GetFeatures(frIsequence1) ;
features2 = GetFeatures(frIsequence2) ;   
features3 = GetFeatures(frIsequence3) ;
features4 = GetFeatures(frIsequence4) ;
features5 = GetFeatures(frIsequence5) ;
features6 = GetFeatures(frIsequence6) ;

figure
plot(1:length(features1), features1,1:length(features2), features2, 1:length(features3), features3),
title('Feature extraction of mel1, mel2 and mel3')
xlabel('Length of feature vectors'), ylabel('Amplitude of feature vector')
axis( [ 1 10 0 20 ] )

figure
subplot(311)
plot(1:length(features1), features1, 1:length(features4), features4)
title('Features vector of melody 1 with and without transposed pitch')
subplot(312)
plot(1:length(features2), features2, 1:length(features5), features5)
title('Features vector of melody 1 with and without transposed pitch')
subplot(313)
plot(1:length(features3), features3, 1:length(features6), features6)
title('Features vector of melody 1 with and without transposed pitch')
    