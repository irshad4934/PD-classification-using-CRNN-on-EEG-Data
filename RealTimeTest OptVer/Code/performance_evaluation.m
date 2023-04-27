function[]=performance_evaluation()
SelectedChans={'CP5';'O2';'PO8';'FC5';'P6';'TP8'};
AllParams=[
    2.50000000000000,9,6,3;
    2.50000000000000,11,4,2;
    2.50000000000000,11,4,2;
    2.50000000000000,9,9,3;
    2.50000000000000,12,4,2;
    2.50000000000000,10,6,2
    ];



[EEG_UNM,EEG_UIOWA,Channel_location_UNM,Channel_location_UIOWA,FileNameIowa,FileNameNewMaxico]=file_load();


is_normalized_projection=0;


% get labels
channel='cz';
[OriginalDataJ,OriginalDataI,OriginalLabelsJ,OriginalLabelsI]=data_load(channel,EEG_UNM,EEG_UIOWA,Channel_location_UNM,Channel_location_UIOWA,FileNameIowa,FileNameNewMaxico);
ClassesI=[ones(length(OriginalLabelsI{1}),1) ; zeros(length(OriginalLabelsI{2}),1)];
ClassesJ=[ones(length(OriginalLabelsJ{1}),1) ; zeros(length(OriginalLabelsJ{2}),1)];
TrainingLabels=[1:(length(OriginalLabelsJ{1})+length(OriginalLabelsJ{2}))]';
TestLabels=[1:(length(OriginalLabelsI{1})+length(OriginalLabelsI{2}))]';
TestClasses=ClassesI;
TrainingClasses=ClassesJ;

% times
alltimes=[10:1:400];
nt=length(alltimes);
timestart=.1;
Fs=500;
% 1. get all LPC coefficients
YWTr_all=cell(length(SelectedChans),1);
YWTest_all=cell(length(SelectedChans),1);
YWTr_alltime=cell(length(SelectedChans),1);
YWTest_alltime=cell(length(SelectedChans),1);

for ch=1:length(SelectedChans)
    channel=SelectedChans{ch};
    params=AllParams(ch,:);
    %disp(channel)
    [OriginalDataJ,OriginalDataI,OriginalLabelsJ,OriginalLabelsI]=data_load(channel,EEG_UNM,EEG_UIOWA,Channel_location_UNM,Channel_location_UIOWA,FileNameIowa,FileNameNewMaxico);
    ClassesI=[ones(length(OriginalLabelsI{1}),1) ; zeros(length(OriginalLabelsI{2}),1)];
    ClassesJ=[ones(length(OriginalLabelsJ{1}),1) ; zeros(length(OriginalLabelsJ{2}),1)];
    
    
    TrData=[OriginalDataJ{1} OriginalDataJ{2}];
    TestData=[OriginalDataI{1} OriginalDataI{2}];
    
    Filter=[0 params(1) 0; params(2) inf 0];
    Order=params(3);
    pca=params(4);
    
    YWtr_currentTime=cell(nt,1);
    YWtest_currentTime=cell(nt,1);
    parfor i_t=1:nt
        Tr_i=signal_cutter(TrData,timestart,alltimes(i_t),Fs);
        Tr_iFilteredData=FilterDataNewGeneralized(Tr_i,Filter);
        YW_iTraining=YWcalculateGeneralized(Order,Tr_iFilteredData);
        
        Test_i=signal_cutter(TestData,timestart,alltimes(i_t),Fs);
        Test_iFilteredData=FilterDataNewGeneralized(Test_i,Filter);
        YW_iTest=YWcalculateGeneralized(Order,Test_iFilteredData);
        YWtr_currentTime{i_t}=YW_iTraining;
        YWtest_currentTime{i_t}=YW_iTest;
    end
    
    YWTr_alltime{ch}=YWtr_currentTime;
    YWTest_alltime{ch}=YWtest_currentTime;
    
    TrFilteredData=FilterDataNewGeneralized(TrData,Filter);
    YWTraining=YWcalculateGeneralized(Order,TrFilteredData);
    YWTr_all{ch}=YWTraining;
    
    
end
%2. k fold data
best_comb=[1:6]; % take all of the channels

%% full training set
FormattedDataTr_all=cell(length(SelectedChans),1);
for ch=1:length(SelectedChans)
    YWTraining=YWTr_all{ch};
    FormattedDataTr=data_formatter(YWTraining,TrainingLabels,TrainingClasses);
    FormattedDataTr_all{ch}=FormattedDataTr;
end

% training set
allACCTr=nan(nt,1);
allScoreTr=nan(nt,length(TrainingClasses));
for i=1:nt
    
    FormattedData_all=cell(length(SelectedChans),1);
    for ch=1:length(SelectedChans)
        YW=YWTr_alltime{ch}{i};
        FormattedData=data_formatter(YW,TrainingLabels,TrainingClasses);
        FormattedData_all{ch}=FormattedData;
    end
    
    [accT, scores_i, ~]=combined_classifier(AllParams,FormattedDataTr_all,FormattedData_all,best_comb,is_normalized_projection);
    allACCTr(i)=accT;
    allScoreTr(i,:)=scores_i;
end

% test set
allACCTest=nan(nt,1);
allScoreTest=nan(nt,length(TestClasses));
for i=1:nt
    
    FormattedData_all=cell(length(SelectedChans),1);
    for ch=1:length(SelectedChans)
        YW=YWTest_alltime{ch}{i};
        FormattedData=data_formatter(YW,TestLabels,TestClasses);
        FormattedData_all{ch}=FormattedData;
    end
    
    [accT,scores_i, ~]=combined_classifier(AllParams,FormattedDataTr_all,FormattedData_all,best_comb,is_normalized_projection);
    allACCTest(i)=accT;
    allScoreTest(i,:)=scores_i;
end

curr_dir=pwd;
cd ../;
save('VaryingResults.mat','allACCTest','allScoreTest','allACCTr','allScoreTr','alltimes','AllParams','SelectedChans','TestClasses','TrainingClasses');
cd(curr_dir);
