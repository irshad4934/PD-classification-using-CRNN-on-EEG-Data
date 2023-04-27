function [Result]=EEG_steps(data_location,current_location,filename,FILTER)
cd(data_location);
load(filename,'EEG') ;
cd(current_location);


% %avg across channels
EEG.data=mean(EEG.data,1);
%filter
EEG=filter_data(EEG,FILTER);

% PDDI calculation
PDDI=PDDI_calc(EEG);

%save PDDI
         Result=[PDDI ];
