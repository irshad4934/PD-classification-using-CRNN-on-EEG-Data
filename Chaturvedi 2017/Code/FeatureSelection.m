function featureVector=FeatureSelection(Features,Peakf,Medianf,SelectedFeatures,AllFreq, ROIList)
% add GP in ROIlist
ROIList{size(ROIList,1)+1}='GP';

featureVector=[];
for i=1:size(SelectedFeatures,1)
    currFeature=SelectedFeatures{i};
   
    
    if(strcmp(currFeature(1),'F') )% freq Fxx.xxRR
        band=[str2num([currFeature(2) currFeature(3)])  str2num([currFeature(5) currFeature(6)])];
        roi=[currFeature(7) currFeature(8)];
        
        band_index=0;
        for bnd=1:size(AllFreq,1) % for bands
            curr_band=AllFreq(bnd,:);
            if(curr_band(1)==band(1) && curr_band(2)==band(2))
                band_index=bnd;
                break;
            end
        end
        %ROI
        roi_index=0;
        for r=1:length(ROIList)
            currentROI=ROIList{r};
            if(strcmp(currentROI,roi))
                roi_index=r;
                break;
            end
        end
        featureVector=[featureVector Features(band_index, roi_index) ];
        
    elseif(strcmp(currFeature(1),'A') ) % alpha1/theta ratio FRR
        roi=[currFeature(2) currFeature(3)];
        %ROI
        roi_index=0;
        for r=1:length(ROIList)
            currentROI=ROIList{r};
            if(strcmp(currentROI,roi))
                roi_index=r;
                break;
            end
        end
        featureVector=[featureVector Features(size(AllFreq,1)+1, roi_index) ];
    elseif(strcmp(currFeature(1),'P') ) % peak P
         featureVector=[featureVector Peakf ];
    elseif(strcmp(currFeature(1),'M') ) % median M
        featureVector=[featureVector Medianf ];
    end
end