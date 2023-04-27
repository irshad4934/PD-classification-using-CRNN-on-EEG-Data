function [acc, scores,classes]=combined_classifier(AllParams,FormattedDataTr_all,FormattedDataTest_all,combo_index,is_normalized_projection)
n=length(combo_index);
total_subj=length(FormattedDataTest_all{1}{1});
all_scores=nan(n,total_subj);

for i=1:n
    ch=combo_index(i);
    pca=AllParams(ch,4);
    FormattedDataTr=FormattedDataTr_all{ch};
    FormattedDataTest=FormattedDataTest_all{ch};
    Engindata=hyperplane_finder(FormattedDataTr,pca);
    ClassificationData=hyperplane_classifier(Engindata,FormattedDataTest,is_normalized_projection);
    tempscores=ClassificationData(2:end);
    k1k2score=tempscores./(1-tempscores);
    all_scores(i,:)=k1k2score;
    
end

scores=geo_mean(all_scores,1);
scores=scores./(1+scores);


%acc
crr=0;
pd_patient_test=sum(FormattedDataTest_all{1}{2});
for i=1:total_subj
    
    if scores(i) <=.5 && i <=pd_patient_test
        crr=crr+1;
    elseif scores(i) >.5 && i > pd_patient_test
        crr=crr+1;
    else        
    end
end

acc=crr/total_subj*100;
classes=FormattedDataTest_all{1}{2};
