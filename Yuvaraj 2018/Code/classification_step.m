clear;
close all;
clc;
load('Result.mat');

originalClass=Result(:,end);
data=Result(:,1:(end-1));
%NumTrees=80; % number of trees
predictedClass=originalClass*0;
predictedScores=originalClass*0;

%% leave one out method with Multinomial Logistic Reg
for subj=1:size(Result,1)
    tempdata=data;
    tempdata(subj,:)=[]; % removing  subj's data
    temporiginalClass=originalClass;
    temporiginalClass(subj)=[]; % removing  subj's class
    classifierModel= fitcsvm(tempdata,temporiginalClass,'Standardize',true,...
        'KernelFunction','rbf','BoxConstraint',1);
    [predictedC,pScore]=  predict(classifierModel,data(subj,:));
    predictedClass(subj)=predictedC;
    predictedScores(subj)=pScore(2);
end

%% results 
PD_total=27;
CR_total=length(originalClass)-PD_total;
TP=0;
TN=0;
for i=1:length(originalClass)
    if(originalClass(i)==1 && predictedClass(i)<=1.5) %  PD
        TP=TP+1;
    elseif(originalClass(i)==2 && predictedClass(i)>1.5) % crtl
        TN=TN+1;
    else
     
    end
end
FN=PD_total-TP;
FP=CR_total-TN;
sensitivity=TP/(TP+FN);
specificity=TN/(TN+FP);
ACC=(TN+TP)/(TP+FP+TN+FN);
PPV=TP/(TP+FP);
NPV=TN/(TN+FN);
OR=(TP/FP)/(FN/TN);


predictedClass=predictedScores;
% ACC=(length(originalClass)-error)/length(originalClass);
%ROC
[X,Y,T,AUC]=perfcurve(originalClass,predictedClass,2);
plot(X,Y)

% box plot
boxdata=[predictedClass(1:27,1)   predictedClass(28:end,1)];
boxplotCustom(boxdata,'PD','Control','Yuvraj 2018')

%ANOVA 
[pANOVA,~,~]= anova1(predictedClass,originalClass,'off');
disp(pANOVA);
%ranksum
pWK= ranksum(predictedClass(1:27,1), predictedClass(28:end,1));
disp(pWK);
% ROC data save, 
save('ROCdataY18.mat','X','Y','AUC','ACC','pANOVA','pWK','originalClass','predictedClass',...
    'TP','TN','FP','FN','sensitivity','specificity','PPV','NPV','OR');