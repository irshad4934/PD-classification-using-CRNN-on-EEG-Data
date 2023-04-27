% eeg filter which I designed for substitutiong eegfilt, Not used
function out= myeegfilt(x,Fs,start,stop,order)

d = designfilt('bandstopiir','FilterOrder',order, ...
               'HalfPowerFrequency1',start,'HalfPowerFrequency2',stop, ...
               'DesignMethod','butter','SampleRate',Fs);
           
           out = filtfilt(d,x);