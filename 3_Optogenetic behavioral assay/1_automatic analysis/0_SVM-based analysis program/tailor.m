
clear all

path=pwd
D=dir(['C:\Data\Heat Pan Data\191019 LKvnc' '\Image*_tif'])
for foldnum=1:length(D)
    cd([D(foldnum).folder '\' D(foldnum).name])
    D2=dir([pwd ])
for filename = 901:999
    delete(['0' num2str(filename) '.tif'])
    
end
for filename = 1000:length(D2)
    delete([num2str(filename) '.tif'])
    
end
cd(path)
end