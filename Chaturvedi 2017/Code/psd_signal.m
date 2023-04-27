function [Pf, F]=psd_signal(x,Fs,s,config)
%Plot PSD plots avg of PSDs of signal x1 ... xN
%   Input: x: m x N  COLLUMS OF X ARE DFT SIGNALS
% Fs- sampling freq
% s- show plot or not
% x needs to be real. otherwise do real(x)
N=size(x,1);
K=length(x);

% if config parameter does not exist then do default
if ~exist('config','var')
    config=[500 300 K];
end

[Pf, F]=pwelch(x,config(1),config(2),config(3),Fs,'onesided'); %pwelch(real(x),hamming(K/8),.5,K,Fs);

% if min(size(x)) > 1 % when we have more than one input signal
%     Pf=mean(Pf');
% end
% totalP=trapz(Pf);
% Pf=Pf/totalP;

% if min(size(x)) > 1
%     for i=1:size(Pf,2)
%         Pf(:,i)= Pf(:,i)./trapz(Pf(:,i)); % normalize the energy
%     end
% else
%     Pf=Pf./trapz(F,Pf);
% end

if s==1
    plot(F,20*log10(Pf));
    xlabel('Freq (Hz)');
    ylabel('power/freq');
    
end

end