clear;
close all;
clc;
load('Result.mat');

originalClass=Result(:,80);
data=Result(:,1:79);
NumTrees=80; % number of trees
predictedClass=originalClass*0;


%% leave one out method with Random Forest
for subj=1:size(Result,1)
    tempdata=data;
    tempdata(subj,:)=[]; % removing  subj's data
    temporiginalClass=originalClass;
    temporiginalClass(subj)=[]; % removing  subj's class
    classifierModel= TreeBagger(NumTrees,tempdata,temporiginalClass,'Method','regression');
    [predictedScore,scores,stdevs]= predict(classifierModel,data(subj,:));
    predictedClass(subj)=predictedScore;
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
%ROC
[X,Y,T,AUC]=perfcurve(originalClass,predictedClass,2);
plot(X,Y)

% box plot
boxdata=[predictedClass(1:27,1)   predictedClass(28:end,1)];
boxplotCustom(boxdata,'PD','Control','Chaturvedi 2017')

%ANOVA 
[pANOVA,~,~]= anova1(predictedClass,originalClass,'off');
disp(pANOVA);
%ranksum
pWK= ranksum(predictedClass(1:27,1), predictedClass(28:end,1));
disp(pWK);
% ROC data save, 
save('ROCdataC17.mat','X','Y','AUC','ACC','pANOVA','pWK','originalClass','predictedClass',...
    'TP','TN','FP','FN','sensitivity','specificity','PPV','NPV','OR');