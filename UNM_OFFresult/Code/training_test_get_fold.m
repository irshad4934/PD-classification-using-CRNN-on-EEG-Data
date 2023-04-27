function [TrData,TrainingLabels,TrainingClasses,TestData,TestLabels,TestClasses]=training_test_get_fold(Data,Labels,Classes,KFoldData,fold)

Tr_indx=KFoldData.training(fold);
Test_indx=KFoldData.test(fold);

TrainingLabels=[];
TrainingClasses=[];

TestLabels=[];
TestClasses=[];

clear TrData;
clear TestData;
Tr_data_indx=1;
Test_data_indx=1;

for i=1:length( Data)
    if Tr_indx(i)
        TrData{Tr_data_indx}=Data{i};
        TrainingLabels=[TrainingLabels;Labels(i)];
        TrainingClasses=[TrainingClasses;Classes(i)];
        Tr_data_indx=Tr_data_indx+1;
    end
end

for i=1:length( Data)
    if Test_indx(i)
        TestData{Test_data_indx}=Data{i};
        TestLabels=[TestLabels;Labels(i)];
        TestClasses=[TestClasses;Classes(i)];
        Test_data_indx=Test_data_indx+1;
    end
end

