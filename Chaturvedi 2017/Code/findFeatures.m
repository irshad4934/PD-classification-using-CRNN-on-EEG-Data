function FeaturesOut=findFeatures(AllFreq,EEGnew)

totalband=[min(min(AllFreq)) max(max(AllFreq))];
Data=[EEGnew.data];
%band+1 x ROI
FeaturesOut=zeros(size(AllFreq,1)+1,size(Data,1));
for roi=1:size(FeaturesOut,2)
    [Pf, F]=power_calc1(Data(roi,:)); % spectral powers
    for bnd=1:size(AllFreq,1)% for bands
            band=AllFreq(bnd,:);            
            FeaturesOut(bnd,roi)=  power_calc2(band,totalband,true,Pf, F);            
    end
end
% for alpha1/theta ratio
FeaturesOut( (size(AllFreq,1)+1),:)=FeaturesOut(3,:)./FeaturesOut(2,:);
% now for GP
FeaturesOut=[FeaturesOut sum(FeaturesOut,2)];

% so you have : ( band + a/t ratio) x (ROIs + Global Power)