clear all

path=pwd
D=dir(['C:\Data\Heat Pan Data\220505' '\Image*_tif'])
for foldnum=1:length(D)
    cd([D(foldnum).folder '\' D(foldnum).name])
    D2=dir([pwd '\output*']);
    if length(D2)>0
    cd([D2(1).folder '\' D2(1).name])
    D3=dir([pwd '\*.csv'])
% larvae which are recognized during short time is deleted.
frame_number_threshold=100;

        if length(D3)>0
        csvname=D3.name
        pathname=[D3.folder '\']
        cd(path)
        f=find(pathname=='\');
        tif_dir=pathname(1:f(end-1)-1);

        csv_load_and_analysis
         load('cl_170130_10mL_tusui.mat')
         prediction_rolling_2
         rolling_vs_time
        else
        end
    else
    end
end
