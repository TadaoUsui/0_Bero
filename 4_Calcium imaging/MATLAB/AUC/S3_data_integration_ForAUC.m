% CP data_integration_ATR
% 191206 by Kai
% RCaMP Analyzerから得たデータを統合するためのスクリプト
% For ATR and Non ATR comparing (unpaired, data from 2 groups)
% 211028 by Kai integrate results from all neurons
% 211118 modified by Kurio, add max amplitude(0<t<30) 

%% Before integrating the mat data,
%% please copy two groups of data that you want to compare into folder Data_Integration/G1 and G2
%% Data.G1 for Non ATR(black),G2 for ATR(red)

clear all

Condition='ABLK_X305_ControlvsberoKD'     %% !!! Please enter your filename(usually genotype or neuron name) (e. mCSI)


A={}; %A will be the integrated data struct
path=pwd
cd(['D:\Tsuksa Data\bero\ABLK\Ca imaging\MATLAB\RCaMP_Persistent_Tsukasa\Data_Integration\G1'])
D=dir([pwd '\*.mat']);
  
j=1;
for i=1:length(D)
% %% Loading Data
% Input=uigetfile('*.mat');
% load(Input); %load manually
load([pwd '\' D(i).name]) %load automatically
 for ii=1:length(img.roi)-1
     A.a{j,1}=D(i).name; %保存先の名前
     A.a{j,2}=img.roi(ii).delta;
     A.a{j,3}=img.roi(ii).raw(1,2); %F0
     A.a{j,4}=mean(img.roi(ii).delta); %AUC
     j=j+1;
 end


end

Data.G1=A.a; 


clear i ii j Input img D

%%
cd ..
cd(['D:\Tsuksa Data\bero\ABLK\Ca imaging\MATLAB\RCaMP_Persistent_Tsukasa\Data_Integration\G2'])

D=dir([pwd '\*.mat']);

j=1;
for i=1:length(D)
% %% Loading Data
% Input=uigetfile('*.mat');
% load(Input); %load manually
load([pwd '\' D(i).name]) %load automatically

 for ii=1:length(img.roi)-1
     A.b{j,1}=D(i).name; %保存先の名前
     A.b{j,2}=img.roi(ii).delta;
     A.b{j,3}=img.roi(ii).raw(1,2); %F0
     A.b{j,4}=mean(img.roi(ii).delta); %AUC
     j=j+1;
 end


end

cd ..

Data.G2=A.b; 


clear i m Input img D A path
save([Condition datestr(now,'yyyymmdd_HHMMSS')])


%% AUCをまとめたファイルを作成
% space=0.3;
G1_size=size(Data.G1);
G2_size=size(Data.G2);

for i = 1:G1_size(1)
    AUC_first(i,1) = Data.G1{i,4}; 
end

for i = 1:G2_size(1)
    AUC_second(i,1) = Data.G2{i,4};
end
AUC_integrate = ["Control" "beroKD"; AUC_first AUC_second]
writematrix(AUC_integrate,[Condition '_AUC' '.csv'])

%% Baselineをまとめたファイルを作成
% space=0.3;
G1_size=size(Data.G1);
G2_size=size(Data.G2);

for i = 1:G1_size(1)
    BL_first(i,1) = Data.G1{i,3}; 
end

for i = 1:G2_size(1)
    BL_second(i,1) = Data.G2{i,3};
end

BL_integrate = ["First" "Second"; BL_first BL_second]
writematrix(BL_integrate,[Condition '_BL' '.csv'])

%% AUC 2
space=0.3;

for i = 1:G1_size(1)
    Peak.cont(i,1) = Data.G1{i,4}*100; %% Peak.cont is the peak of the Data.G1(continuous in CP or Left in LR)
end
writematrix(Peak.cont,'ABLK_Control_withoutATR_X305.csv')

for i = 1:G2_size(1)
    Peak.pulse(i,1) = Data.G2{i,4}*100;    
end
writematrix(Peak.pulse,'ABLK_beroKD_withoutATR_X305.csv')