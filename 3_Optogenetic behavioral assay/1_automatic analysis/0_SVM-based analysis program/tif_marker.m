clear all

path=pwd
D=dir(['C:\Data\Heat Pan Data\220505' '\Image*_tif'])
for foldnum=1:length(D)
    cd([D(foldnum).folder '\' D(foldnum).name])
    tic
    D2=dir([pwd '\*.tif'])
    for tifnum=1:length(D2)  
        temp=imread(D2(tifnum).name);

%         if mod(length(D2),2)==0        
%             temp([10:25],[10:13],:)=200;
%         else
%             temp([14:20],[8:15],:)=200;
%         end
        
        if mod(length(D2),2)==0        
            temp([floor(10+300*tifnum/length(D2)):floor(25+300*tifnum/length(D2))],[10:13],:)=200;
        else
            temp([floor(14+300*tifnum/length(D2)):floor(20+300*tifnum/length(D2))],[8:15],:)=200;
        end
        imwrite(temp,D2(tifnum).name)
    end
    toc
end