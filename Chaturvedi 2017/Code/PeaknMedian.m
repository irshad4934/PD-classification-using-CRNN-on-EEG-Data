function [Peakf, Medianf]=PeaknMedian(EEG,AllFreq)
totalband=[min(min(AllFreq)) max(max(AllFreq))];
% %avg across ROIs
Data=mean(EEG.data,1);
[Pf, F]=power_calc1(Data);

%peak f
Peak=0;
Pindex=0;
for i=1:length(F)
    % blimit check
    if(F(i)<totalband(1) || F(i) > totalband(2))
        % do nothing . its out of bound
    else
        if(Pf(i)>Peak)
            Pindex=i;
            Peak=F(i);
        end
    end
end
Peakf=F(Pindex);
%median f

currentEstimateMedian=0;
for i=1:length(F)
    % blimit check
    if(F(i)<totalband(1) || F(i) > totalband(2))
        % do nothing . its out of bound
    else
        band=[totalband(1) F(i)];
        currentP=power_calc2(band,totalband,true,Pf, F);
        if(currentP<=0.5)
            currentEstimateMedian=F(i);
        else
            break;
        end
    end
end
Medianf=currentEstimateMedian;


