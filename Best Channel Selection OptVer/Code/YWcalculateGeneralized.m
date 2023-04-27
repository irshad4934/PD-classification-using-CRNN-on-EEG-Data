%% calculate YW of N order then avg
function YW=YWcalculateGeneralized(N,Input)
Fs=500;
srate=500;
DATA=Input;
total_patients=size(DATA,1);
 YW=cell(total_patients,1);
for i=1:total_patients
    x1=DATA{i};
    g=arburg_ongpu( x1 , N );
    yw=[g(2:end)];
    YW{i}=yw;
end
end
