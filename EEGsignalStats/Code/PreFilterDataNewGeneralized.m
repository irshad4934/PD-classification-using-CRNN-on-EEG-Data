%% Generalized Pre Filter for any dataset
function [OUT]=PreFilterDataNewGeneralized(DATA,filtr)
Fs=500;
srate=500;

% temp variable to storethe time series for saving
Temp_v=[];

for conditions=1:2  % CTL vs. PD
    
    for si = 1:size(DATA{conditions},2)
        M1=DATA{conditions}{si};
        % average the time series
        % for normalizing energy in the time seroes
        for m1=1:size(M1,2)
            mm=M1(:,m1);
            mm=mm'*mm;
            M1(:,m1)=M1(:,m1)./sqrt(mm);
        end        
     
        % take mean of time series
        M1=mean(M1,2);
        
        
        M1=lpf_smooth_x4(M1,Fs,filtr,0);
        OUT{conditions}{si}=M1;              
    end
    
    
end

end
