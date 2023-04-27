function [FullDataJ,FullDataI,FileNamesJ,FileNamesI]=data_load(channel,EEG_UNM,EEG_UIOWA,Channel_location_UNM,Channel_location_UIOWA,FileNameIowa,FileNameNewMaxico)





%% dataset load
% choose channel
disp(channel);



EEG_20=EEG_UNM;
Channel_location_2=Channel_location_UNM;


site_location=0;
for i=1:size(Channel_location_2,2)
    channel_i=upper(Channel_location_2{i});
    if strcmp(upper(channel),channel_i)
        site_location=i;
        break;
    end
end

EEG_2=EEG_20{site_location}; % data for that channel
clear EEG_20;
disp('Channel Data New Maxico Acquired ')
disp(['channel location: ', num2str(site_location)])




EEG_60=EEG_UIOWA;
Channel_location_6=Channel_location_UIOWA;


site_location=0;
for i=1:size(Channel_location_6,2)
    channel_i=upper(Channel_location_6{i});
    if strcmp(upper(channel),channel_i)
        site_location=i;
        break;
    end
end

EEG_6=EEG_60{site_location}; % data for that channel
clear EEG_60;
disp('Channel Data Iowa Acquired ')
disp(['channel location: ', num2str(site_location)])


EEG_5=EEG_6;






EEG_2=PreFilterDataNewGeneralized(EEG_2,[57 63 0 ;177 183 0;197 203 0]);

disp('EEG Data Pre filter New Maxico: succesful')

EEG_5=PreFilterDataNewGeneralized(EEG_5,[56 66.5 0 ;177.5 184 0]);
disp('EEG Data Pre filter Iowa: succesful')









% training set



FileNamesJ=cell(1,2);
FileNamesJ{1}=FileNameNewMaxico{1};
FileNamesJ{2}=FileNameNewMaxico{2};

FileNamesI=cell(1,2);
FileNamesI{1}= FileNameIowa{1};
FileNamesI{2}= FileNameIowa{2};

FullDataJ=EEG_2;
FullDataI=EEG_5;

