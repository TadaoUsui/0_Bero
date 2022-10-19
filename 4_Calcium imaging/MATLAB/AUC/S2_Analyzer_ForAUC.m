%% Defalut setting
opengl hardwarebasic %% For high-resolution graphic

clear
close all
set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');
scrsz = get(groot,'ScreenSize');


%% Loading
% 光刺激直前のフレーム,fps(Hz),を指定する


% 比較データをまとめる
input=uigetfile('*.mat');
% input=uigetfile({'*.mat','All Files'});
load(input);
input2=input(1:length(input)-4) % To remove _transient.mat
 filename=input2;
%  pathname='D:\Kurio Data\ABLK\Ca-α1D\P{}attP2\persistent';

img.Frame0=0;
img.Fnum = 249;
fps=1;

% Timescaleの設定

Timescale=(img.Frame0)*(1/img.fps):(1/img.fps):(img.Fnum-img.Frame0)*(1/img.fps);
Time = Timescale(1:249);

% % 母平均の区間推定
%     for j=1:img.Fnum
%     [muhat,sigmahat,muci,sigmaci] = normfit(Ca.cont(:,j));
%     mu.cont(j)=muhat;
%     ci.cont(j)=muci(2)-muhat;
%     
%    [muhat,sigmahat,muci,sigmaci] = normfit(Ca.pulse(:,j));
%     mu.pulse(j)=muhat;
%     ci.pulse(j)=muci(2)-muhat;
%     end

for iRoi = 1:nRoi
F_temp = img.roi(iRoi).raw(:,1);
img.roi(iRoi).half = F_temp(1:249);
end
    

% Roiの色の設定 (Max15色)、バックグラウンド用に最後のroiの色はグレーにする。  
colorRoi =[     1         0         0;
                0         1         0;
                0         0         1;
                1         1         0;
                1         0         1;
                0         1         1;
                0    0.4470    0.7410;               
           0.8500    0.3250    0.0980;
           0.9290    0.6940    0.1250;
           0.4940    0.1840    0.5560;
           0.4660    0.6740    0.1880;
           0.3010    0.7450    0.9330;
           0.6350    0.0780    0.1840;
              0.5       0.5       0.5];         
colorRoi(nRoi,:)=0.75;

    
%% Figure 3:ｄFF0 Ca2+ dynamics of each ROI
figure('Position',[500 100 scrsz(3)*6/10 scrsz(4)*5/10])
Baseline_window=10; %% Enter the size of window!
% バックグラウンドの輝度を計算
B_temp=img.roi(nRoi).half(:,1);

 for i = 1:Baseline_window
        asc_Bi=sort(B_temp(1:i+Baseline_window));
        B0(i,1)=asc_Bi(3); % Lowest N frames will be choosed and the average will be the Baseline for T = i
    end
    for i = Baseline_window+1:img.Fnum-Baseline_window
        asc_Bi=sort(B_temp(i-Baseline_window:i+Baseline_window));
        B0(i,1)=asc_Bi(3); % Lowest N frames will be choosed and the average will be the Baseline for T = i
    end
    for i = img.Fnum-Baseline_window+1:img.Fnum
        asc_Bi=sort(B_temp(i-Baseline_window:img.Fnum));
        B0(i,1)=asc_Bi(3); % Lowest N frames will be choosed and the average will be the Baseline for T = i
    end


for iRoi = 1:nRoi-1    
    F_temp=img.roi(iRoi).half(:,1);
    
    Baseline_window=10; %% Enter the size of window!
    
    for i = 1:Baseline_window
        asc_Fi=sort(F_temp(1:i+Baseline_window));
        F0(i,1)=asc_Fi(3); % Lowest N frames will be choosed and the average will be the Baseline for T = i
    end
    for i = Baseline_window+1:img.Fnum-Baseline_window
        asc_Fi=sort(F_temp(i-Baseline_window:i+Baseline_window));
        F0(i,1)=asc_Fi(3); % Lowest N frames will be choosed and the average will be the Baseline for T = i
    end
    for i = img.Fnum-Baseline_window+1:img.Fnum
        asc_Fi=sort(F_temp(i-Baseline_window:img.Fnum));
        F0(i,1)=asc_Fi(3); % Lowest N frames will be choosed and the average will be the Baseline for T = i
    end
    
    img.roi(iRoi).delta=((F_temp-F0)-(B_temp-B0))./F0;
    plot(Time,img.roi(iRoi).delta*100,'LineWidth',1.5,'color',colorRoi(iRoi,:));

    hold on
end


xlim([min(Time) max(Time)])% 軸の範囲
 ylim([0 100])
% ylim([min(img.roi(1).sub_back*100) max(img.roi(1).sub_back*100)])
set(gca,'XTick',0:50:249)% 軸の目盛り間隔
set(gca,'YTick',0:10:100)
xlabel('Time(sec)','FontSize',24)% 軸ラベル
ylabel('\DeltaF/F_{0} (%)','FontSize',24)
title(input2,'interpreter','none');% タイトル
set(gca,'TickDir','out','Ticklength',[0.02 0])% Others
set(gca,'Color','none')
box off
% axis square

savefig([filename '_persistent']);;

clear  B0 back_incre colorRoi F0 i ind iRoi NAME1  Regionx Regiony roisize_total scrsz Time Timescale vec_temp F_temp asc_Fi Baseline_window bs fps Fs input 


%% Saving
 img.raw_img =[];
%  NAME1=uigetfile('*.tif');  
 pathname='D:\Tsuksa Data\bero\ABLK\Ca imaging\MATLAB\ABLK file\Part-I'
 save(fullfile(pathname, [filename '_persistent']));
%  save(filename);
% writematrix(Pks_Hz, [filename '_Pks .csv']);