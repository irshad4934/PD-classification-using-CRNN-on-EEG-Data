function PDDI=PDDI_calc(EEG)
Fs=500;
%data 
data=EEG.data;
% %avg across channels
% data=mean(data,1);

% bispectrum
[Bspec,~] = bispecd (data,1024 ,15, 1024, 50);

% HOS features
H1=H1_calc(Bspec);
H2=H2_calc(Bspec);
Ent1=BiEnt1_calc(Bspec);

% PDDI 
% PDDI=((3.5*Ent1)+ (0.5*(H1/H2) )  )/10;
PDDI=[H1 H2 Ent1];