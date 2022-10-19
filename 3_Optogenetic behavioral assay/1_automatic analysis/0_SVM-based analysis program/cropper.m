clear all

path=pwd
D=dir(['C:\Data\Heat Pan Data\220505' '\Image*_tif'])
for foldnum=1:length(D)
    cd([D(foldnum).folder '\' D(foldnum).name])
    tic
    D2=dir([pwd '\*.tif'])
    for tifnum=1:length(D2)  
        temp=imread(D2(tifnum).name);

        temp=temp(40:400,1:360,:);
        imwrite(temp,D2(tifnum).name)
    end
    toc
end