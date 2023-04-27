%% USING CLASSIFIER ENGINE, CREATE SOFT SCORES
function out=hyperplane_classifier(EnginDataFull,Test,is_normalized_projection)

pca=EnginDataFull{1};
EnginData=EnginDataFull{2};

%load engin
v1=EnginData{1};
m1=EnginData{2};
v2=EnginData{3};
m2=EnginData{4};





YW_test=Test{1};
patient_classification_test=Test{2};
pd_patient_test=sum(patient_classification_test);
total_patient_test=length(patient_classification_test);



total_cls=2;




all_scores=zeros(1,total_patient_test);
total_error=0;
for current_subject_index=1:total_patient_test
    %SUBJECT to test
    pair_rm=current_subject_index;
    tsubst=pair_rm;
    test1=[];
    for i=tsubst
        test1=[test1 ;squeeze(YW_test{i}(:,:))] ;
    end
    
    
    

    
    
    if  is_normalized_projection==0
        Kt1=(test1-repmat(m1',size(test1,1),1));
        Kt1_projection=(Kt1)*v1./ (diag((v1'*v1)))' ;
        K1=Kt1-Kt1_projection*v1';
        K1=norm(K1);
        
        Kt2=(test1-repmat(m2',size(test1,1),1));
        Kt2_projection=(Kt2)*v2./ (diag((v2'*v2)))' ;
        K2=Kt2-Kt2_projection*v2';
        K2=norm(K2);
        
    elseif is_normalized_projection==1
        Kt1=(test1-repmat(m1',size(test1,1),1));
        Kt1_projection=(test1-repmat(m1',size(test1,1),1))*v1;
        K1=norm(Kt1_projection)/norm(Kt1) ;
        
        Kt2=(test1-repmat(m2',size(test1,1),1));
        Kt2_projection=(test1-repmat(m2',size(test1,1),1))*v2;
        K2=norm(Kt2_projection)/norm(Kt2) ;
    end
    
    
    KK=zeros(size(K1,1),total_cls);
    
    for i=1:size(K1,1)
        KK(i,1)=K1(i,:);
    end
    
    for i=1:size(K2,1)
        KK(i,2)=K2(i,:);
    end
    
    
    KK=KK';
    
    
    [~, inx_v]=min(KK);
    
    score=K1/(K1+K2);
    crr=0;
    if score <=.5 && pair_rm <=pd_patient_test
        crr=crr+1;
    elseif score >.5 && pair_rm > pd_patient_test
        crr=crr+1;
    else
        
    end
    all_scores(current_subject_index)=score;
    err=(length(inx_v)-crr);
    total_error=total_error+err;
end
total_error=total_error/total_patient_test*100;
out=[total_error  all_scores ];
