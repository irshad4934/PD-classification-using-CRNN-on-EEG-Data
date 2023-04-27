function[]=performance_helper(best_comb,k,k_all,SelectedChans,YWTr_all,TrainingLabels,TrainingClasses,YWTest_all,AllParams,is_normalized_projection)
scores=[];
classes=[];
acc_kfold_all=zeros(k_all,1);
for j=1:k_all
[acc_Kfold,all_scores,all_classes]=kfold_acc_helper_func(SelectedChans,YWTr_all,TrainingLabels,TrainingClasses,YWTest_all,AllParams,best_comb,is_normalized_projection,k);
acc_kfold_all(j)=acc_Kfold;
scores=[scores all_scores];
classes=[classes ;all_classes];
end
acc_Kfold=mean(acc_kfold_all);
disp(acc_Kfold);
fname=[num2str(k),'_OFF_foldData.mat'];
curr_dir=pwd;
cd ../;
save(fname,'scores','classes','k_all','k');
cd(curr_dir);