%% calculate YW of N order then avg
function FilteredData=FilterDataNewGeneralized(DATA,FILTER)
Fs=500;
srate=500;

% temp variable to storethe time series for saving
total_data=size(DATA,2);
FilteredData=cell(total_data,1);


[sos,g]=create_filter(Fs,FILTER);


parfor si=1:total_data
    M1=DATA{si};
    M1=filtfilt(sos,g,double(M1));
    M1=M1./norm(M1);
    FilteredData{si}=M1;
end


end