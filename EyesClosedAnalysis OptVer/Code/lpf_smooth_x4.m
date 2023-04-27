%% this is SMOOTH filter for X. each collum of X is considered a DTS
% Fahim Anjum ------ filter is the filter design :
% each row is one band pass filter: [start frequ end freq  (0 stop band)/(1 pass band)]
% inf means the maximum freq.
% for example, a low pass filter at 15Hz : [0 15 1; 15 inf 0]
% another way: [15 inf 0] (because by default filter is all pass)
% Fs is the sampling freq (Hz)
% s=1 shows the plot
%
% log: edited 2/8/17 - now it outputs real valued series
% log edited 2/90/17- corrected for odd stop band middle value
% log edited 2/10/17- corrected the stop band
%%

function y=lpf_smooth_x4(X,Fs,filtr,s)

%make the signal odd length
if mod(size(X,1),2)==0
    X=X(2:end,:);
end

total_signl=size(X,2);
N=size(X,1);
T=1/Fs;
K=(N-1)/2+1;
F= -1/(2*T):1/(N*T):1/(2*T)-1/(N*T);
F_uncut=linspace(1,N,N);
F_cut=F_uncut;
%% design the filter from matrix
Filtr=ones(N,1);
total_band=size(filtr,1);

% identy cutoff
cut_off=filtr(:,1:2) .*(N*T);

% replace infinite with max freq
fmax=1/(2*T);
fmax_cutoff=N/2;
cut_off(isinf(cut_off))=fmax_cutoff;

% make filter
for bnd=1:total_band
    if filtr(bnd,3)==0
        f1=cut_off(bnd,1);
        f2=cut_off(bnd,2);
        for i=1:N
            if  ( ((K-f2)<= i) && (i <= K-f1) ) || ( ((K+f1)<= i) && (i <= K+f2) )
                Filtr(i)=nan;
                F_cut(i)=nan; % new
            end
        end
    end
end





%% apply filter
y=[];

for i=1:total_signl
    x=X(:,i);
    
    % FFT
    Xf=fftshift(fft(x));
    
    %show
    if s==1
        
        figure;
        plot(F,Filtr)
        figure;
        plot(F,abs(Xf))
        hold on
    end
    
    %apply filter to FFT
    Xff=Xf.*Filtr;
    
    % replace NaN with some previous data etc shits
    
    Xff1=Xff;
    band_on= 0 ;
    stop_band=[];
    for bb=1:N
        if isnan(Xff(bb)) && band_on==0 % first encounter of stop band
            band_on=1;
            stop_band=[stop_band bb];
            
        elseif isnan(Xff(bb)) && band_on==1 % inside stop band
            stop_band=[stop_band bb];
            
        elseif isnan(Xff(bb))==0 && band_on==1 % last encounter of stop band
            band_on=0;
            % modify the Xff
            len_b=length(stop_band);
            
            % if the length is odd, make it even
            if len_b==1
                Xff1(stop_band)=(Xff1(stop_band-1)+Xff1(stop_band+1))/2;
            elseif mod(len_b,2)
                len_b=length(stop_band)-1;
                stop_band1=stop_band(1:(len_b/2));
                stop_band2=stop_band((len_b/2)+2:end);
                Xff1(stop_band1)=Xff1(stop_band1-(len_b/2));
                Xff1(stop_band2)=Xff1(stop_band2+(len_b/2));
                Xff1(stop_band(len_b/2)+1)=(Xff1(stop_band(len_b/2))+Xff1(stop_band(len_b/2)+2))/2;% take care of the middle point
            else % length is even
                stop_band1=stop_band(1:(len_b/2));
                stop_band2=stop_band((len_b/2)+1:end);
                Xff1(stop_band1)=Xff1(stop_band1-(len_b/2));
                Xff1(stop_band2)=Xff1(stop_band2+(len_b/2));
                
            end
            stop_band=[]; %reset stop band
        end
    end
    
    Xff=Xff1;
    %show
    if s==1
        figure;
        plot(F,abs(Xff))
        grid minor
    end
    
    % convert FFT to signal
    Xff=ifftshift(Xff);
    y=[y ifft(Xff)];
end
end