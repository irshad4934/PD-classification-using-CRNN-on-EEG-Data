%% HELPER FUNCTION: remove noise from data
 function out=de_noise(xraw,Fs)


    xraw=myeegfilt(xraw,Fs,59,61,2);
      xraw=myeegfilt(xraw,Fs,119,121,2);
      xraw=myeegfilt(xraw,Fs,179,181,2);
      xraw=myeegfilt(xraw,Fs,199,201,2);

out=xraw;
