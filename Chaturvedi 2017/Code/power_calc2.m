%% helper function: power of a band (needs power_calc1)
% input: xraw- input time series, band- frequency band , isNormalizedPower-power normalizstion

function out=power_calc2(band,totalband,isNormalizedPower,Pf, F)



%for band
HighCut=band(2);
LowCut=band(1);
indexhigh=find(F<=HighCut);
indexlow=find(LowCut<=F);
index=intersect(indexhigh,indexlow);
Pf1=Pf(index);
F1=F(index);
if (length(F1)==1)
    absolutePower=Pf1;
else
    absolutePower=trapz(F1,Pf1);
end
%for total band
HighCut=totalband(2);
LowCut=totalband(1);
indexhigh=find(F<=HighCut);
indexlow=find(LowCut<=F);
index=intersect(indexhigh,indexlow);
Pf1=Pf(index);
F1=F(index);

totalPower=trapz(F1,Pf1);

if(isNormalizedPower)
    out=absolutePower/totalPower;
else
    out=absolutePower;
end
