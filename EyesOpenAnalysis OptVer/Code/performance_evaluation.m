function []=performance_evaluation()

SelectedChans={'O2';'TP7';'PO3';'P2';'P6';'CP2';'P1';'P3'};
AllParams=[
2.50000000000000,11,4,2;
2.50000000000000,10,10,5;
2.50000000000000,11,4,2;
2.50000000000000,8,7,1;
2.50000000000000,11,2,1;
2.50000000000000,12,6,2;
2.50000000000000,11,7,1;
2.50000000000000,11,4,2
    ];

[EEG_UNM,Channel_location_UNM,FileNameNewMaxico]=file_load();


is_normalized_projection=0;


% get labels
channel='cz';
[OriginalDataJ,OriginalLabelsJ]=data_load(channel,EEG_UNM,Channel_location_UNM,FileNameNewMaxico);

ClassesJ=[ones(length(OriginalLabelsJ{1}),1) ; zeros(length(OriginalLabelsJ{2}),1)];
TrainingLabels=[1:(length(OriginalLabelsJ{1})+length(OriginalLabelsJ{2}))]';

TrainingClasses=ClassesJ;

% 1. get all LPC coefficients
YWTr_all=cell(length(SelectedChans),1);
YWTest_all=cell(length(SelectedChans),1);

WaitMessage = parfor_wait(length(SelectedChans), 'Waitbar', true);
parfor ch=1:length(SelectedChans)
    channel=SelectedChans{ch};
    params=AllParams(ch,:);
    %disp(channel)
    [OriginalDataJ,OriginalLabelsJ]=data_load(channel,EEG_UNM,Channel_location_UNM,FileNameNewMaxico);
    ClassesJ=[ones(length(OriginalLabelsJ{1}),1) ; zeros(length(OriginalLabelsJ{2}),1)];
    
    
    TrData=[OriginalDataJ{1} OriginalDataJ{2}];
    

    
    Filter=[0 params(1) 0; params(2) inf 0];
    Order=params(3);
    pca=params(4);
    TrFilteredData=FilterDataNewGeneralized(TrData,Filter);
    YWTraining=YWcalculateGeneralized(Order,TrFilteredData);
    YWTr_all{ch}=YWTraining;
    
  
    WaitMessage.Send;
end
WaitMessage.Destroy;
%2. k fold data
best_comb=1:size(AllParams,1); % take all of the channels
disp('Eyes Open analysis==============')

k=5;
k_all=10;
performance_helper(best_comb,k,k_all,SelectedChans,YWTr_all,TrainingLabels,TrainingClasses,AllParams,is_normalized_projection);


k=10;
k_all=10;
performance_helper(best_comb,k,k_all,SelectedChans,YWTr_all,TrainingLabels,TrainingClasses,AllParams,is_normalized_projection);


k=1;
k_all=1;
performance_helper(best_comb,k,k_all,SelectedChans,YWTr_all,TrainingLabels,TrainingClasses,AllParams,is_normalized_projection);





