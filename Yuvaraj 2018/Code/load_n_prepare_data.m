%%  this will organize the data , filter and make asc file for processing in loreta



clear;
close all;
clc;

% set data path
 temppath=importdata('datapath.txt');
 data_location=temppath{1};
 
 
% set for the perf comparison
desired_pd_sets=[1:27];
desired_cr_sets=[1:27];

%for saving results
Resultpd=zeros(length(desired_pd_sets),4);
Resultcr=zeros(length(desired_cr_sets),4);

% pre-filter
FILTER=[0 1 0; 49 inf 0 ];

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



clear EEGData;
channels=[];
for condition=1:2
    if condition==1
        subject_numbers=desired_pd_sets;
    else
        subject_numbers=desired_cr_sets;
    end
    
    parfor indexs=1:length(subject_numbers)
        i=subject_numbers(indexs);
        % session select
        subject_index_in_ON_OFF_indicator=find(ON_OFF_indicator == str2num(subjects{condition}{i}) );
        if size(subject_index_in_ON_OFF_indicator,1)==0
            ON_session='1';
        elseif size(subject_index_in_ON_OFF_indicator,1)> 0
            ON_session=num2str( ON_OFF_indicator(subject_index_in_ON_OFF_indicator,2) );
        end
      %load file
        filename=[subjects{condition}{i},'_',ON_session,'_PD_REST.mat']; % only session 1 for now
          disp(['Working on ....' , filename]);
          [PDDI]=EEG_steps(data_location,current_location,filename,FILTER);
          if(condition==1)
             Resultpd(indexs,:)=[PDDI condition ];
          else
              Resultcr(indexs,:)=[PDDI condition ];
          end
    end
    
end

Result=[Resultpd;Resultcr];

param{1}=1024;
param{2}= '15';
param{3}= 1024;
param{4}=50;
disp('Finished');
clear EEG;
cd(current_location);
save('Result.mat','Result','param');