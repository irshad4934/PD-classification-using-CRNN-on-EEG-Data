function [sos,g]=create_filter(Fs,filtr)

start_f=filtr(1,2);
if(size(filtr,1)==1 || filtr(2,3)==1)
    stop_f= Fs/2-.6;
else

stop_f=filtr(2,1);
end

%% 1st approach: was not that good
% bpFilt = designfilt('bandpassiir','FilterOrder',100, ...
%          'HalfPowerFrequency1',start_f, ...
%          'HalfPowerFrequency2',stop_f, ...
%          'SampleRate',Fs);
%      
% y = filter(bpFilt,X);



%% 2nd approach
Order=6;
Fn = Fs/2; % nyquist freq

Wp = [start_f stop_f]/Fn; % pass band
Ws = [start_f stop_f]/Fn; % 3db passband

Rp=2; % pass band ripple in db
Rs=220; % stopband atttenuation in db

% [n,Ws] = cheb2ord(Wp,Ws,Rp,Rs); 
% [z,p,k] = cheby2(n,Rs,Ws);
[z,p,k] = butter(Order,Ws);
[sos,g] = zp2sos(z,p,k);

end