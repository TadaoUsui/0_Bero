
[filename,pathname]=uigetfile('*');
true_label=xlsread([pathname filename]);

%%
j=1;
img_number=[];
for k=1:length(true_label)
    if j==true_label(k,1)
        img_number(j)=k;
        j=j+1;
    end
end

img_number(j)=length(true_label)+1;

%%
true_label(isnan(true_label(:,2)),3)=1;
true_label(isnan(true_label(:,2)),2)=2;




%%
for j=1:length(img_number)-1
    for k=img_number(j):img_number(j+1)-1
        data{j}.t(true_label(k,2):true_label(k,3))=1;
    end
end
        
