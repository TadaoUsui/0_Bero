
data_name='*01_24*tif.mat';
x=ls(data_name);

for i=1:size(x,1)
    clear data
    load(x(i,:));

    if i==1
        d=data;
    elseif i>1
        d=[d;data];
    end
end
        

data=d;
clear d
    