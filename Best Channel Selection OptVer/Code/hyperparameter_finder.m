function []=hyperparameter_finder()

[EEG_UNM,~,Channel_location_UNM,~,~,FileNameNewMaxico]=file_load();
EEG_UIOWA=[];
Channel_location_UIOWA=[];
FileNameIowa=[];

is_normalized_projection=0;
kfdata=load('KfoldData.mat','KFoldData','KFoldUsedLabels');
KFoldData=kfdata.KFoldData;
KFoldUsedLabels=kfdata.KFoldUsedLabels;

allN=[2:10];
firstFiltercutoffs=[2.5];
secondFiltercutoffs=[8:1:14];

allchanfile=load('AllChannels.mat','common_channels');
common_channels=allchanfile.common_channels;
AllChanResult=cell(length(common_channels),1);

WaitMessage = parfor_wait(size(common_channels,2), 'Waitbar', true);


parfor ch=1:size(common_channels,2)
    channel=common_channels{ch};
    %disp(channel)
    [OriginalDataJ,~,OriginalLabelsJ,~]=data_load(channel,EEG_UNM,EEG_UIOWA,Channel_location_UNM,Channel_location_UIOWA,FileNameIowa,FileNameNewMaxico);

    ClassesJ=[ones(length(OriginalLabelsJ{1}),1) ; zeros(length(OriginalLabelsJ{2}),1)];
    

    TrData=[OriginalDataJ{1} OriginalDataJ{2}];
    TrainingLabels=[1:(length(OriginalLabelsJ{1})+length(OriginalLabelsJ{2}))]';
    TrainingClasses=ClassesJ;
    
    
%         k=10;
%         data_splitter_CV(TrainingLabels,TrainingClasses,k); % use once
    
    %sanity check
    if max(abs(KFoldUsedLabels-TrainingLabels))>0
         % K fold done in different labels
        errmsg='WARNING: ERROR IN K FOLD DATA';
        error(errmsg);
    end
    
    
    
    
    
    %%
    Result=zeros(1,6);

    
    
    
    FirstCutofftempResult=zeros(length(firstFiltercutoffs),6);
    for f_indx=1:length(firstFiltercutoffs)
        SecondCutofftempResult=zeros(length(secondFiltercutoffs),6);
        for secondCutoff_i=1:length(secondFiltercutoffs)
            secondCutoff=secondFiltercutoffs(secondCutoff_i);          
            if  (secondCutoff-firstFiltercutoffs(f_indx)) <= 4
                % nothing
            else
                Filter=[0 firstFiltercutoffs(f_indx) 0; secondCutoff inf 0];
                TrFilteredData=FilterDataNewGeneralized(TrData,Filter);
                tempResultallN=zeros(length(allN),6);
                for i_order=1:length(allN)
                    Order=allN(i_order);
                    YWTraining=YWcalculateGeneralized(Order,TrFilteredData);
                    tempResult=ones(Order-1,4);
                    tempResult(:,1)=firstFiltercutoffs(f_indx)* tempResult(:,1);
                    tempResult(:,2)=secondCutoff* tempResult(:,2);
                    tempResult(:,3)=Order*tempResult(:,3);
                    tempResult(:,4)=[1:Order-1]';
                    justResult=ones(Order-1,2);
                    for pca=1:Order-1
                        kfoldresult=kfold_cv(YWTraining,TrainingLabels,TrainingClasses,KFoldData,pca,is_normalized_projection);
                        justResult(pca,:)=kfoldresult;
                    end
                    
                    allResultCurrentOrder=[tempResult justResult];
                    [~,R_i]=max(allResultCurrentOrder(:,6));
                    BestResultCurrentOrder=allResultCurrentOrder(R_i,:);
                    tempResultallN(i_order,:)=BestResultCurrentOrder;          
                end
                [~,R_i]=max(tempResultallN(:,6));
                BestResultCurrentFilter=tempResultallN(R_i,:);
                SecondCutofftempResult(secondCutoff_i,:)=BestResultCurrentFilter;
            end
        end
        [~,R_i]=max( SecondCutofftempResult(:,6));
        tempMaxResult=SecondCutofftempResult(R_i,:);
        FirstCutofftempResult(f_indx,:)=tempMaxResult;
    end
    
    [~,R_i]=max(FirstCutofftempResult(:,6));
    Result=FirstCutofftempResult(R_i,:);
    AllChanResult{ch}=Result;
    WaitMessage.Send;
end
WaitMessage.Destroy;
curr_dir=pwd;
cd ../;
save('HyperParamsAllChan.mat','AllChanResult');
cd(curr_dir);
