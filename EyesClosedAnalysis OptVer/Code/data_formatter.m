%% reorder the data so that all PD comes first
function FormattedData=data_formatter(Data,Labels,Classes)
% 1-PD ; 0- Control
total_subject=length(Data);
total_pd=sum(Classes);
total_cr=total_subject-total_pd;
pd_data=cell(total_pd,1);
cr_data=cell(total_cr,1);
pd_i=1;
cr_i=1;

for i=1:total_subject
    if Classes(i)==1
        pd_data{pd_i}=Data{i};
        pd_i=pd_i+1;
    elseif Classes(i)==0
        cr_data{cr_i}=Data{i};
        cr_i=cr_i+1;
    end
end

FormattedLabels=[Labels(Classes==1) ; Labels(Classes==0) ];
FormattedClass=[Classes(Classes==1) ; Classes(Classes==0) ];

FormattedData{1}=[pd_data;cr_data];
FormattedData{2}=FormattedClass;
FormattedData{3}=FormattedLabels;