function [ quotnotes ] = GetFeatures( frIsequence, frequencies )
%GetFeatures Extracts the feature of the hummed song from the frIsequence
%Matrix produced by GetMusicFeatures.

   % This vector contains the frequencies of the scales 1 to 3
frequencies = [ 65.41 , 69.30 , 73.42, 77.78, 82.41, 87.31, 92.50, 98.80, 103.83, 110.00, 116.54, 123.47, ... % scale 1
                130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185.00, 196.00, 207.65, 220.00, 233.09, 246.94, ... % scale 2
                261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88 ]  ; % scale 3
            
  % Isolate the log-pitch and the log-intensity
pitch = frIsequence(1,:) ;
intensity = log(frIsequence(3,:)) ;
% corr = frIsequence(2,:) ; % we do not use this for now

  % Search the mean of intensity and pitch
meanI = mean(intensity) ; 

  % Separation between notes and silences can ealisy be found by
  % thresholding the intensity. Binnote is a boolean vector with value 1
  % when there's a note and 0 otherwise (silences, beginning and end of
  % recording). This is arguably the most important part of the feature
  % extractor
binnote = intensity < meanI == 0 ;
binnote = intensity >= meanI == 1 ;

  % get rid of the high pitch rendered by the silences
pitch_note = pitch .* binnote ;

   % This loop loops for all notes found, and find the frequency. Returns
   % all frequencies in vector notes.
binnote_label = bwlabel(binnote) ;
notes = [] ;
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
        notes = [ notes mean(pitch_notei) ] ;
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

    % We then compute the quotient between two consecutives notes which is
    % returned by the function
quotnotes = zeros(1,length(notes)-1) ;
for i=1:length(notes)-1
   quotnotes(i) = notes(i) / notes(i+1) ;    
end

   % TO DO : MAPPING
   
end

