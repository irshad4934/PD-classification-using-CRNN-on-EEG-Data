function []=performance_evaluation()
SelectedChans={'CP5';'O2';'PO8';'FC5';'P6';'TP8'};
AllParams=[
    2.50000000000000,9,6,3;
    2.50000000000000,11,4,2;
    2.50000000000000,11,4,2;
    2.50000000000000,9,9,3;
    2.50000000000000,12,4,2;
    2.50000000000000,10,6,2
    ];



is_normalized_projection=0;


% 1. get all LPC coefficients
YWTr_all=cell(length(SelectedChans),1);
YWTest_all=cell(length(SelectedChans),1);
for ch=1:length(SelectedChans)
    channel=SelectedChans{ch};
    params=AllParams(ch,:);
    %disp(channel)
    [OriginalDataJ,~,OriginalLabelsJ,~]=data_load(channel);
    ClassesJ=[ones(length(OriginalLabelsJ{1}),1) ; zeros(length(OriginalLabelsJ{2}),1)];
    
    [OriginalDataJOFF,OriginalLabelsJOFF]=data_loadOFF(channel);
    ClassesJOFF=[ones(length(OriginalLabelsJOFF{1}),1) ; zeros(length(OriginalLabelsJOFF{2}),1)];
    
    TrData=[OriginalDataJ{1} OriginalDataJ{2}];
    TrainingLabels=[1:(length(OriginalLabelsJ{1})+length(OriginalLabelsJ{2}))]';
    TrainingClasses=ClassesJ;
    
    TestData=[OriginalDataJOFF{1} OriginalDataJOFF{2}];
    TestLabels=[1:(length(OriginalLabelsJOFF{1})+length(OriginalLabelsJOFF{2}))]';
    TestClasses=ClassesJOFF;
    
    % TrainingClass and TestClass are same and we utilize this fact
    
    Filter=[0 params(1) 0; params(2) inf 0];
    Order=params(3);
    pca=params(4);
    TrFilteredData=FilterDataNewGeneralized(TrData,Filter);
    YWTraining=YWcalculateGeneralized(Order,TrFilteredData);
    YWTr_all{ch}=YWTraining;
    
    TestFilteredData=FilterDataNewGeneralized(TestData,Filter);
    YWTrainingT=YWcalculateGeneralized(Order,TestFilteredData);
    YWTest_all{ch}=YWTrainingT;
end
%2. k fold data
best_comb=[1:6]; % take all of the channels


k=1;
k_all=1;

KFoldData = cvpartition(length(TrainingClasses),'LeaveOut');
save('KfoldData.mat','KFoldData');

performance_helper(best_comb,k,k_all,SelectedChans,YWTr_all,TrainingLabels,TrainingClasses,YWTest_all,AllParams,is_normalized_projection);
performance_helperON(best_comb,k,k_all,SelectedChans,YWTr_all,TrainingLabels,TrainingClasses,YWTest_all,AllParams,is_normalized_projection);

%% test full test
FormattedDataTr_all=cell(length(SelectedChans),1);
for ch=1:length(SelectedChans)
    YWTraining=YWTr_all{ch};
    FormattedDataTr=data_formatter(YWTraining,TrainingLabels,TrainingClasses);
    FormattedDataTr_all{ch}=FormattedDataTr;
end

FormattedDataTest_all=cell(length(SelectedChans),1);
for ch=1:length(SelectedChans)
        YWTraining=YWTest_all{ch};
        FormattedDataTest=data_formatter(YWTraining,TestLabels,TestClasses);
        FormattedDataTest_all{ch}=FormattedDataTest;
end
[accT, fullscoresT, fullclassesT]=combined_classifier(AllParams,FormattedDataTr_all,FormattedDataTest_all,best_comb,is_normalized_projection);
scores=fullscoresT;
classes=fullclassesT;
curr_dir=pwd;
cd ../;
save('FullOFFDatatest.mat','scores','classes');
cd(curr_dir);
disp(accT)



