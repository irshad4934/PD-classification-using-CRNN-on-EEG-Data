%filter and denoise
function [EEG]=filter_data(EEG,FILTER)
Fs=500;




[sos,g]=create_filter(Fs,FILTER);

for chan=1:size(EEG.data,1)
    EEG.data(chan,:)=filtfilt(sos,g,double(EEG.data(chan,:)));
    EEG.data(chan,:)=de_noise(   double(   EEG.data(chan,:)),Fs);
end