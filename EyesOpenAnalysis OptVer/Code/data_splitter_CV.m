function []=data_splitter_CV(Labels,Classes,k)
KFoldData = cvpartition(Classes,'KFold',k);
KFoldUsedLabels=Labels;
save('KfoldData.mat','KFoldData','KFoldUsedLabels');