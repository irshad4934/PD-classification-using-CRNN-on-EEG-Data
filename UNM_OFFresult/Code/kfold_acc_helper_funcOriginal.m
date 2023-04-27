function [acc_Kfold,all_scores,all_classes]=kfold_acc_helper_funcOriginal(SelectedChans,YWTr_all,TrainingLabels,TrainingClasses,YWTest_all,AllParams,best_comb,is_normalized_projection,k)
% fold on hyperplane finder


%  custom k fold

load('KfoldData.mat','KFoldData');

total_fold=KFoldData.NumTestSets;
FormattedDataTr_all_fold=cell(total_fold,1);
FormattedDataTest_all_fold=cell(total_fold,1);

for fold=1:total_fold
    FormattedDataTr_all=cell(length(SelectedChans),1);
    FormattedDataTest_all=cell(length(SelectedChans),1);
    for ch=1:length(SelectedChans)
        YWTraining=YWTr_all{ch};
        YWTest=YWTest_all{ch};
        [KTrYWData,KTrainingLabels,KTrainingClasses,KYWTestData,KTestLabels,KTestClasses]=training_test_get_fold(YWTraining,TrainingLabels,TrainingClasses,KFoldData,fold);
        FormattedDataTr=data_formatter(KTrYWData,KTrainingLabels,KTrainingClasses);
        FormattedDataTest=data_formatter(KYWTestData,KTestLabels,KTestClasses);
        FormattedDataTr_all{ch}=FormattedDataTr;
        FormattedDataTest_all{ch}=FormattedDataTest;
    end
    FormattedDataTr_all_fold{fold}=FormattedDataTr_all;
    FormattedDataTest_all_fold{fold}=FormattedDataTest_all;
end



% test K fold training
all_scores=[];
all_classes=[];
acc_temp=nan(total_fold,1);
for fold=1:total_fold
    FormattedDataTr_all=FormattedDataTr_all_fold{fold};
    FormattedDataTest_all=FormattedDataTest_all_fold{fold};
    [acc,scores,classes]=combined_classifier(AllParams,FormattedDataTr_all,FormattedDataTest_all,best_comb,is_normalized_projection);
    acc_temp(fold)=acc;
    all_scores=[all_scores  scores];
    all_classes=[all_classes ;classes];
end
acc_Kfold=mean(acc_temp);
end