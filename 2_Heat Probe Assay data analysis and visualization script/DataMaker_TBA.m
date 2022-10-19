%% ---------- CG9336/bero project ---------- %%
%%
clear
close all

filename = 'Example.xlsx';
xlRange1 = 'F14:F150';
xlRange2 = 'J14:J150';
i = 1;

sheet = 'Lk_GFPRNAi';
X(i).Genotype = 'Lk>GFP RNAi';
X(i).Temp = 46;
X(i).Time = xlsread(filename, sheet, xlRange1)
i = i + 1;

sheet = 'Lk_beroRNAi2';
X(i).Genotype = 'Lk>bero RNAi 2';
X(i).Temp = 46;
X(i).Time = xlsread(filename, sheet, xlRange1);
i = i + 1;


for i=1:length(X)
    X(i).Time(isnan(X(i).Time)) = 0;
    X(i).Time(X(i).Time==0) = [];
    X(i).Time(X(i).Time>10) = 10.05;
    X(i).Time = X(i).Time*100;
    X(i).Time = round(X(i).Time);
end

save('TBAdata_example','X')




