function acc=kfold_cv(YWTraining,TrainingLabels,TrainingClasses,KFoldData,pca,is_normalized_projection)
FormattedDataTr=data_formatter(YWTraining,TrainingLabels,TrainingClasses);
Engindata=hyperplane_finder(FormattedDataTr,pca);
ClassificationData=hyperplane_classifier(Engindata,FormattedDataTr,is_normalized_projection);
Tracc=(100-ClassificationData(1));

acc=0;
total_fold=KFoldData.NumTestSets;
for fold=1:total_fold

[KTrYWData,KTrainingLabels,KTrainingClasses,KYWTestData,KTestLabels,KTestClasses]=training_test_get_fold(YWTraining,TrainingLabels,TrainingClasses,KFoldData,fold);
FormattedDataTr=data_formatter(KTrYWData,KTrainingLabels,KTrainingClasses);
FormattedDataTest=data_formatter(KYWTestData,KTestLabels,KTestClasses);
Engindata=hyperplane_finder(FormattedDataTr,pca);
ClassificationData=hyperplane_classifier(Engindata,FormattedDataTest,is_normalized_projection);
acc=acc +(100-ClassificationData(1));
end
acc=acc/total_fold;
acc=[Tracc acc];