%% HELPER FUNCTION: box plot create
% data=[class1 class2]
function boxplotCustom(data,label1,label2,title)
boxplot(data,'Labels',{label1,label2},'Widths',.7);
 set(gcf, 'Position',  [100, 100, 100, 400])
 xtickangle(90)
 ylabel(title,'FontSize', 12)
 set(gca, 'XTickLabel',{label1,label2}, 'fontsize', 10);
 a = get(get(gca,'children'),'children');   % Get the handles of all the objects

% For a particular part: 
% t = get(a,'tag');   % List the names of all the objects 
% idx=strcmpi(t,'box');  % Find Box objects
% boxes=a(idx);          % Get the children you need
% For whole box:
boxes=a; % you can select all elements of the box
set(a,'linewidth',1.1); % Set width