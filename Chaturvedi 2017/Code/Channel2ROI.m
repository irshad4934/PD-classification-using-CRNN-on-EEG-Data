function EEGnew=Channel2ROI(EEG,ChanNumber,Chan2ROI, ROIList)

EEGnew=struct;
EEGnew.data=zeros(length(ROIList),size(EEG.data,2));
for i=1:length(ROIList)
    currentROI=ROIList{i};
    tempdata=[];
    for chan=1:length(ChanNumber)
        %if channel is in ROI
        if(strcmp(Chan2ROI(chan,2),currentROI ))
           tempdata=[ tempdata;  EEG.data(chan,:)];
        end
    end
    EEGnew.data(i,:)=mean( tempdata,1);
end
