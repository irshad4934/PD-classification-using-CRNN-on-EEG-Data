%% classify with SVD and find best result
% log: 3/31/17: edited for actual pca
% out puts actuall % or errors
% looks at the dimension that has least varience
function out=hyperplane_finder(Training,pca)

YW=Training{1};
patient_classification=Training{2};
pd_patient=sum(patient_classification);
total_patient=length(patient_classification);

Classifier_data=cell(1,4);




odr=1;%N-1;


%% training
subst=[1:pd_patient ];%[1:12];%[1 2 3 8 9 10 11 ];%[2];
subst2=[pd_patient+1:total_patient ];


class1=[];
class2=[];



for i=subst
    class1=[class1 ;squeeze(YW{i}(:,:))] ;
end

for i=subst2
    class2=[class2 ;squeeze(YW{i}(:,:))] ;
end




[~,V1,m1]=pca2(class1');
[~,V2,m2]=pca2(class2');


major_d=pca;
v1=V1(:,1:major_d);
v2=V2(:,1:major_d);



Classifier_data{1}=v1;
Classifier_data{2}=m1;
Classifier_data{3}=v2;
Classifier_data{4}=m2;
out=cell(1,2);
out{1}=[ pca];
out{2}=Classifier_data;
end