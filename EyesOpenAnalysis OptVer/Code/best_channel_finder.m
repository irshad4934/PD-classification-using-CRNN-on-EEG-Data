function []=best_channel_finder()

load('AllChannels.mat');

load('HyperParamsAllChan.mat');
result1=AllChanResult;
data_new=cell2mat(result1);


Channels=common_channels';
Params=data_new(:,1:4);
ACC10cv=data_new(:,6);

tb=table(Channels,Params,ACC10cv);
tb1=sortrows(tb,'ACC10cv');

cutoff=77;
rows=tb1.ACC10cv > cutoff;
tb2=tb1(rows,:);
disp('Eyes Open analysis==============')
disp('Best channels and parameters: ')
disp(tb2)