function [EEG_UNM,EEG_UIOWA,Channel_location_UNM,Channel_location_UIOWA,FileNameIowa,FileNameNewMaxico]=file_load()
curr_cd=pwd; % save current dir

cd ../
cd ../
cd ../
cd './Dataset/UNMDataset/Organized_data'

subjects{1} = {'801'; '802'; '804'; '805';'806' ;'807'; '808'; '809'; '810'; '811'; '813'; '814'; '815';'816' ; '817'; '818'; '819'; '820'; '821';'822';'823';'824';'825'; '826'; '827'; '828' ; '829'} ;
subjects{2}= {'890'; '891'; '892'; '893'; '894'; '895'; '896'; '897'; '898'; '899'; '900'; '901'; '902';'903';'904';'905';'906';'907';'908';'909';'910';'911';'912';'913';'914';'8070';'8060'} ;
FileNameNewMaxico=subjects;
load 'EEG_Jim_rest_Unsegmented_WithAllChannels.mat'; % rest jims data
EEG_UNM=EEG;
Channel_location_UNM=Channel_location;
clear EEG;
clear Channel_location;
disp('EEG Data New Maxico read: succesful')

cd(curr_cd)
cd ../
cd ../
cd ../
cd './Dataset/IowaDataset/Organized data'

load 'IowaData.mat'; % for jim task data
FileNameIowa=Filenames;
EEG_UIOWA=EEG;
Channel_location_UIOWA=Channel_location;
clear EEG;
clear Channel_location;
disp('EEG Data Iowa read: succesful')


cd(curr_cd); % rolllback to working directory

end