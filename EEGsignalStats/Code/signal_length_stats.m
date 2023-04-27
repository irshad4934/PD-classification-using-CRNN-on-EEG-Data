function []=signal_length_stats()
% % Age sex matched Iowa subjects

channel='Cz';
[OriginalDataJ,OriginalDataI,OriginalLabelsJ,OriginalLabelsI]=data_load(channel);
    
% New Mexico
Fs=500;
n=length(OriginalDataJ{1});
NM_PD=nan(n,1);
for i=1:n
   NM_PD(i)= length(OriginalDataJ{1}{i})/Fs/60;
end

n=length(OriginalDataJ{2});
NM_CR=nan(n,1);
for i=1:n
   NM_CR(i)= length(OriginalDataJ{2}{i})/Fs/60;
end

disp(['New M PD     : ' ,'   mean: ', num2str(mean(NM_PD)), '+/-',num2str(std(NM_PD)) ]);
disp(['New M Control: ' ,'   mean: ', num2str(mean(NM_CR)), '+/-',num2str(std(NM_CR)) ]);
disp(['New M        :    mean   ', num2str(mean([NM_PD;NM_CR]))])
disp(['New M        :    max   ', num2str(max([NM_PD;NM_CR]))])
disp(['New M        :    min   ', num2str(min([NM_PD;NM_CR]))])
% Iowa

Fs=500;
n=length(OriginalDataI{1});
NM2_PD=nan(n,1);
for i=1:n
   NM2_PD(i)= length(OriginalDataI{1}{i})/Fs/60;
end

n=length(OriginalDataI{2});
NM2_CR=nan(n,1);
for i=1:n
   NM2_CR(i)= length(OriginalDataI{2}{i})/Fs/60;
end

disp(['Iowa PD      : ' ,'   mean: ', num2str(mean(NM2_PD)), '+/-',num2str(std(NM2_PD)) ]);
disp(['Iowa Control : ' ,'   mean: ', num2str(mean(NM2_CR)), '+/-',num2str(std(NM2_CR)) ]);
disp(['Iowa         :    mean   ', num2str(mean([NM2_PD;NM2_CR]))])
disp(['Iowa         :    max   ', num2str(max([NM2_PD;NM2_CR]))])
disp(['Iowa         :    min   ', num2str(min([NM2_PD;NM2_CR]))])
curr_dir=pwd;
cd ../
save('EEGlength.mat','NM2_CR','NM2_PD','NM_CR','NM_PD');
cd(curr_dir);