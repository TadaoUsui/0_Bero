%% SEM等の範囲を塗りつぶしたプロットを作成 %%
% 170913 by K. Onodera
% modified by bbsp
% 180308 modified by Kai
% 180314 modified by K. Onodera
% 180316 modified by Kai, add some description, change the xlim
% 211118 modified by Kurio,　対応するデータ同士を線で結ぶように変更

%% Please move to Data_Integration first!!


%% Defalut setting
opengl hardwarebasic %% For high-resolution graphic

clear all
close all
set(0,'defaultAxesFontSize',20);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',20);
set(0,'defaultTextFontName','Arial');
scrsz = get(groot,'ScreenSize');


%% Loading
% 光刺激直前のフレーム,fps(Hz),を指定する
Frame0=251;
fps=1;

% 比較データをまとめる
input=uigetfile({'*.mat','All Files'});
load(input);
input2=input(1:length(input)-4) % To remove .mat

F_num=length(Data.G1{1,2});
G1_size=size(Data.G1);
G2_size=size(Data.G2);

for i = 1:G1_size(1)
    Ca.cont(i,:) = Data.G1{i,2}*100;
    %Ca.pulse(i+length(A05q.p1)-1,:) = A05q.p2{i,2}*100;
end

for i = 1:G2_size(1)
    Ca.pulse(i,:) = Data.G2{i,2}*100;    
    %Ca.cont(i+length(A05q.c1)-1,:) = A05q.c2{i,2}*100;
end

% Timescaleの設定
Time=(1-Frame0)*(1/fps):(1/fps):(F_num-Frame0)*(1/fps);

% 母平均の区間推定
    for j=1:F_num
    [muhat,sigmahat,muci,sigmaci] = normfit(Ca.cont(:,j));
    mu.cont(j)=muhat;
    ci.cont(j)=muci(2)-muhat;
    
   [muhat,sigmahat,muci,sigmaci] = normfit(Ca.pulse(:,j));
    mu.pulse(j)=muhat;
    ci.pulse(j)=muci(2)-muhat;
    end

%% Each plot and Mean
figure('Position',[800 100 scrsz(3)*4/10 scrsz(4)*5/10])
for i = 1:size(Ca.cont,1)
    plot(Time,Ca.cont(i,:),'color',[0.75 0.75, 0.75],'LineWidth',1)
    hold on
end

for i = 1:size(Ca.pulse,1)
    plot(Time,Ca.pulse(i,:),'color',[1.0, 0.75, 0.75],'LineWidth',1)
    hold on
end

plot(Time,mu.cont,'color','k','LineWidth',2.5)
plot(Time,mu.pulse,'color','r','LineWidth',2.5)

patch([0 2.5 2.5 0],[-300 -300 500 500], 'b','FaceAlpha',.2,'EdgeColor','none')
xlim([-50 50])%%xlim([-5 31]) %% xlim([-10 31]) 
set(gca,'XTick',-50:10:50)%%set(gca,'XTick',-5:5:31)
ylim([-20 200])
set(gca,'YTick',-20:20:200)
set(gca,'TickDir','out','Color','none');
xlabel('Time (s)');
ylabel('ΔF/F_{0}');
% title('Each plot and Mean');
box off
axis square

%% Mean and CI range
figure('Position',[800 100 scrsz(3)*4/10 scrsz(4)*5/10])
for i=1:length(Time)
    Top.cont(i)=mu.cont(i)+ci.cont(i);
    Down.cont(i)=mu.cont(i)-ci.cont(i);
end

for i=1:length(Time)
    Top.pulse(i)=mu.pulse(i)+ci.pulse(i);
    Down.pulse(i)=mu.pulse(i)-ci.pulse(i);
end

plot(Time,Top.cont,'color',[0.75 0.75 0.75],'LineWidth',1)
hold on
plot(Time,Down.cont,'color',[0.75 0.75 0.75],'LineWidth',1)
hold on
plot(Time,Top.pulse,'color',[1.0 0.75 0.75],'LineWidth',1)
hold on
plot(Time,Down.pulse,'color',[1.0 0.75 0.75],'LineWidth',1)

% 塗りつぶしのための座標作成
invTime=fliplr(Time);
invDown.cont=fliplr(Down.cont);
invDown.pulse=fliplr(Down.pulse);

% SEM範囲を多角形として塗りつぶし（外枠なし）
patch([Time, invTime],[Top.cont, invDown.cont],[0.75 0.75 0.75],'EdgeColor','none')
hold on
patch([Time, invTime],[Top.pulse, invDown.pulse],[1.0 0.75 0.75],'EdgeColor','none')
hold on
plot(Time,mu.cont,'color','k','LineWidth',2.5)
hold on
plot(Time,mu.pulse,'color','r','LineWidth',2.5)

patch([0 2.5 2.5 0],[-300 -300 500 500], 'b','FaceAlpha',.2,'EdgeColor','none')
xlim([-50 50]) %% xlim([-10 31]) 
set(gca,'XTick',-50:10:50)
ylim([-20 100])
set(gca,'YTick',-20:20:200)
set(gca,'TickDir','out','Color','none');
xlabel('Time (s)');
ylabel('ΔF/F_{0}');
% title('Mean and CI');
box off
axis square




%% Maximum amplitude (each plot, mean, SEM)
% subplot(1,4,3)
space=0.3;

for i = 1:G1_size(1)
    Peak.cont(i,1) = Data.G1{i,4}*100; %% Peak.cont is the peak of the Data.G1(continuous in CP or Left in LR)
end
writematrix(Peak.cont,'ABLK_Control_withoutATR_X305.csv')

for i = 1:G2_size(1)
    Peak.pulse(i,1) = Data.G2{i,4}*100;    
end
writematrix(Peak.pulse,'ABLK_beroKD_withoutATR_X305.csv')





