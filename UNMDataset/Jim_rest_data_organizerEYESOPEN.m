%% this will organize the data into a single file for Jim Task ungermented data
%% EYES OPEN SET
% Load EEG mat file and look for EEG.events
%In EEG.events...look:  EEG.events.type 
%then you would see the markers type as Jim mentioned below
 % ---------- Get event types
    % All data start with 1 min of eyes closed rest:
        % trigger 3 happens every 2 seconds => EEG.events.type=
        % S 3
        % trigger 4 happens every 2 seconds=> EEG.events.type=
        % S 4
    % Followed by 1 min of eyes open rest:
        % trigger 1 happens every 2 seconds => EEG.events.type= S 1
        % trigger 2 happens every 2 seconds  EEG.events.type= S
        % 2

%Now you have events....and event time would be at EEG.events.latency, but latency is in datapoints...
%you can convert into sec via sampling rate..look EEG.state...


clear all;
close all;
clc;

current_location=pwd;

subjects{1} = {'801'; '802'; '804'; '805';'806' ;'807'; '808'; '809'; '810'; '811'; '813'; '814'; '815';'816' ; '817'; '818'; '819'; '820'; '821';'822';'823';'824';'825'; '826'; '827'; '828' ; '829'} ;
subjects{2}= {'890'; '891'; '892'; '893'; '894'; '895'; '896'; '897'; '898'; '899'; '900'; '901'; '902';'903';'904';'905';'906';'907';'908';'909';'910';'911';'912';'913';'914';'8070';'8060'} ;
% PDsx=[801:811,813:829]; 
% CTLsx=[8010,8070,8060,890:914];

%Each Row: subject -- On sessions
ON_OFF_indicator=[
801	1;
802	2;
803	2;
804	1;
805	1;
806	2;
807	2;
808	2;
809	1;
810	1;
811	1;
813	2;
814	1;
815	1;
816	2;
817	2;
818	1;
819	2;
820	2;
821	1;
822	1;
823	2;
824	2;
825	1;
826	1;
827	2;
828	2;
829	2;

];

cd './Jim_rest';

clear EEGData;
channels=[];
for condition=1:2
    for i=1:length(subjects{condition})
        % session select
        subject_index_in_ON_OFF_indicator=find(ON_OFF_indicator == str2num(subjects{condition}{i}) );
        if size(subject_index_in_ON_OFF_indicator,1)==0
            ON_session='1';
        elseif size(subject_index_in_ON_OFF_indicator,1)> 0
            ON_session=num2str( ON_OFF_indicator(subject_index_in_ON_OFF_indicator,2) );
        end
        %load file
        filename=[subjects{condition}{i},'_',ON_session,'_PD_REST.mat']; % only session 1 for now
        load(filename) ;
        disp(['Working on ....' , filename]); 
        Data=EyesOpenData(EEG); % find the Eyes Open Data
        total_channels=size(Data,1);
        for channel=1:total_channels
            EEGData{channel}{condition}{i}=(Data(channel,:))';
            
            if size(channels,1)==0
                channels{1}=EEG.chanlocs(channel).labels;
            elseif size(channels,2) < total_channels 
                channels{size(channels,2)+1}=EEG.chanlocs(channel).labels;
            end
        end
    end
    
end

disp('Data Created');
Channel_location=channels;
clear EEG;
EEG=EEGData;
%% save data
cd(current_location);
cd './Organized_data';
save('EEG_Jim_rest_Unsegmented_WithAllChannelsEYESOPEN.mat','EEG','Channel_location','-v7.3');
disp('Data saved !');
cd(current_location);

%% This function separates the eyes open data
function Data=EyesOpenData(EEG)
    Fs=EEG.srate;
    n=length(EEG.event);
    Allevents=EEG.event;
    startTime=0;
    endTime=0;
    flag=0;
    for i=1:n
        if (strcmp( Allevents(i).type,'S  1' ) || strcmp( Allevents(i).type,'S  2' )) && flag ==0
            flag=1;
            startTime=Allevents(i).latency;
        end
        if (strcmp( Allevents(i).type,'S  1' ) || strcmp( Allevents(i).type,'S  2' )) && flag ==1
            endTime=Allevents(i).latency+Fs; % up to next second
        end
    end
    data=EEG.data;
    Data=data(:,startTime:1:endTime);
end
