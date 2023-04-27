function [FullDataJ,FullDataI,FileNamesJ,FileNamesI]=data_load(channel)
main_result=[];

best_filter=[];
best_error=100; % this is for general kfold
best_N=[];
best_dim=[];

cutoffs=[8:1:40];
curr_cd=pwd; % save current dir

cd ../
cd ../
cd ../
cd './Dataset/UNMDataset/Organized_data'



%% dataset load
% choose channel
disp(channel);

load 'EEG_Jim_rest_Unsegmented_WithAllChannels.mat'; % rest jims data
subjects{1} = {'801'; '802'; '804'; '805';'806' ;'807'; '808'; '809'; '810'; '811'; '813'; '814'; '815';'816' ; '817'; '818'; '819'; '820'; '821';'822';'823';'824';'825'; '826'; '827'; '828' ; '829'} ;
subjects{2}= {'890'; '891'; '892'; '893'; '894'; '895'; '896'; '897'; '898'; '899'; '900'; '901'; '902';'903';'904';'905';'906';'907';'908';'909';'910';'911';'912';'913';'914';'8070';'8060'} ;

FileNameNewMaxico=subjects;
EEG_20=EEG;
Channel_location_2=Channel_location;
clear EEG;
clear Channel_location;
disp('EEG Data New Maxico read: succesful')

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

cd(curr_cd)
cd ../
cd ../
cd ../
cd './Dataset/IowaDataset/Organized data'


load 'IowaData.mat'; % for jim task data
FileNameIowa=Filenames;
EEG_60=EEG;
Channel_location_6=Channel_location;
clear EEG;
clear Channel_location;
disp('EEG Data Iowa read: succesful')

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



cd(curr_cd); % rolllback to working directory


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