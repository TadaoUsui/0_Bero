% RCaMP Analyzer 
% 180214 by S. Baba 
% Roiを四角形で指定した後、その領域中の輝度の高い上位300pixelを対象に、
% 平均のdF/F0を算出してグラフに描画する。
% F0は青色光照射前の5Fの平均値をとる。←最初の1farameは含めない 青色光照射直前の5frame　191226 modified by A. Tsumadori
% 200305 modified by Tsumadori Roi color, Roi text color, Font Size(fig.3),
% x軸表示範囲(BL照射6秒前より fig.3),Blue light ONを示すBoxを自動作成その他細かな計算手法を修正
% 201221 save周りでデータ量が大きすぎる場合に保存できなくなる不具合を修正　
% 201225　F0計算式を光照射前5秒間に修正
% F0の定義を「光照射前50frameのうち小さいほうから5frame抽出してその中央値」に変更　220117 by Tsukasa
% Roiを四角形で指定した後、その領域中の輝度の高い上位200pixelを対象に、　220610 by Tsukasa
%% Default setting -----------------------------------------------------------------
close all% Figureを全て閉じる
clear% ワークスペースの変数一覧を削除
set(0,'defaultAxesFontSize',10);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',10);
set(0,'defaultTextFontName','Arial');
scrsz = get(groot,'ScreenSize');
%% Loading ---------------------------------------------------------
% 光刺激直前のフレーム,fps(img.fps,単位はHz),観察するRoiの数を指定する
img.Frame0 = 250;
img.fps = 1;
nRoi = 7;

% img.raw{:,1}にフレーム毎の撮影データが格納される
% Fnumに総フレーム数が格納される
NAME1=uigetfile('*.tif');        
bI = bfopen([pwd,'\',NAME1]);        
img.Fnum = length(bI{1,1});
for i = 1:img.Fnum
    img.raw_img{i,1}=double(bI{1,1}{i,1});
end
clear bI
Timescale=(1-img.Frame0)*(1/img.fps):(1/img.fps):(img.Fnum-img.Frame0)*(1/img.fps);
%% Making projection -----------------------------------------------
% img.raw{:,1}と同じキャンバスサイズのimg.projを作り
% 生データのz-project(Ave)を計算して保存する
img.proj = zeros(size(img.raw_img{1,1}));
        for i = 1:img.Fnum
            img.proj = img.proj + img.raw_img{i,1};
        end
img.proj=img.proj./img.Fnum;

%% Getting ratio ---------------------------------------------------        
% Roiの色の設定 (Max15色)、バックグラウンド用に最後のroiの色はグレーになる。  
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

% 走査する領域をマウスで選択しRoiデータとしてimg.roi(nRoi).regionに格納
figure; imagesc(img.proj);  axis('image','off');
img.roi = struct;
for iRoi=1:nRoi
    img.roi(iRoi).region = round(getrect);
     hold on
     rectangle('position',img.roi(iRoi).region,'edgecolor',colorRoi(iRoi,:));
end

 for iRoi = 1:nRoi
% Roiデータから、Roi座標軸(Regionx,Regiony)を作成
% Roi座標軸からRoi領域に１，非Roi領域に0を格納した行列データ、PreRoiマスクを作成する
    Regionx=img.roi(iRoi).region(1):(img.roi(iRoi).region(1)+img.roi(iRoi).region(3));
    Regiony=img.roi(iRoi).region(2):(img.roi(iRoi).region(2)+img.roi(iRoi).region(4));
    Roi=zeros(size(img.proj));  
    Roi(Regiony,Regionx) = 1;  
     
    if iRoi == nRoi
    % (if:バックグラウンド用のスクリプト、選択域をそのままRoiとし、1pixelの平均輝度値をF_tempへ一時保存)   
        roisize_total = sum(Roi(:));
       for i = 1:img.Fnum
           img.roi(iRoi).map=img.raw_img{i,1}.*Roi;
           F_temp(i) = sum(sum(img.roi(iRoi).map))/roisize_total;
       end  
       
    else
    %(else: シグナル用のスクリプト。領域中上位200pixelの輝度値を抽出して平均化する)    
    %各フレームで選択領域を浮き彫りにし、ベクトルデータに直した後降順に並べ替え、上位200を平均化し、F_tempへ一時保存。
       for ind = 1:img.Fnum
           vec_temp=img.raw_img{ind,1}.*Roi;
           vec_temp=vec_temp(:);
           vec_temp=sort(vec_temp,'descend');  
           F_temp(ind,1) = sum(vec_temp(1:200))/200   ;
       end
        vec_temp1=img.raw_img{1,1}.*Roi;
       vec_temp1=vec_temp1(:);
       vec_temp1=sort(vec_temp1,'descend'); 
       vec(iRoi,:)=  vec_temp1(1:2000);  
    end   
% F0の定義を「光照射前50frameのうち小さいほうから5frame抽出してその中央値」に変
    Fs=sort(F_temp((img.Frame0-49):img.Frame0));   %毎回変更
    F0=median(Fs(1:5)) ;
    img.roi(iRoi).raw(:,1) = F_temp;
    img.roi(iRoi).raw(1,2)=F0; 
 end
 filename=NAME1(1:length(NAME1)-4)
clear Mx Mxs MxInd MxY MxX F_temp F0 PreRegionx PreRegiony regionx regiony Roi PreRoiFs

%% Figure 0: intensity per pixels
figure('Position',[500 100 scrsz(3)*6/10 scrsz(4)*5/10])
for iRoi = 1:nRoi-1
    plot(vec(iRoi,:),'LineWidth',1.5,'color',colorRoi(iRoi,:))
    hold on   
end
ylim([0 4000])
% ylim([0 max(img.roi(1).raw(:,1))])
set(gca,'YTick',0:500:4000)
set(gca,'TickDir','out','Ticklength',[0.02 0])% Others
set(gca,'Color','none')
box off
savefig([filename '_pix']);

%% Figure 1: Whole image and ROIs
figure('Position',[50 100 scrsz(3)*3/10 scrsz(4)*5/10])
imagesc(img.proj);
axis('image','off')
for iRoi = 1:nRoi
    hold on
    rectangle('position',img.roi(iRoi).region,'LineWidth',1,'edgecolor',colorRoi(iRoi,:));
    text(img.roi(iRoi).region(1)+3,img.roi(iRoi).region(2)+7,[num2str(iRoi)],'color','w','FontSize',12)
end
title(NAME1,'interpreter','none');
savefig([filename '_img']);

%% Figure 2:Raw Ca2+ dynamics of each ROI
figure('Position',[500 100 scrsz(3)*4/10 scrsz(4)*5/10])
for iRoi = 1:nRoi
    Time = Timescale;
    plot(Time,img.roi(iRoi).raw(:,1),'LineWidth',1.5,'color',colorRoi(iRoi,:))
    hold on   
end
xlim([-250 max(Time)])% 軸の範囲
ylim([0 4000])
set(gca,'XTick',-250:50:250)% 軸の目盛り間隔
set(gca,'YTick',00:500:4000)
xlabel('Time(sec)')% 軸ラベル
ylabel('Intensity')
title(NAME1,'interpreter','none');% タイトル
set(gca,'TickDir','out','Ticklength',[0.03 0])% Others
set(gca,'Color','none')
box off
axis square
savefig([filename '_raw']);

%% Figure 3:ｄFF0 Ca2+ dynamics of each ROI
figure('Position',[800 100 scrsz(3)*4/10 scrsz(4)*5/10])
bs=sort(img.roi(nRoi).raw((img.Frame0-49):img.Frame0,1));
b0=median(bs(1:5));   
back_incre = (img.roi(nRoi).raw(:,1)-b0);
for iRoi = 1:nRoi-1
    Time=Timescale;    
    F0=img.roi(iRoi).raw(1,2) ;     
    img.roi(iRoi).sub_back=(img.roi(iRoi).raw(:,1)-F0-back_incre)/F0; %signnal量はratioなのに対しback_increは強度なので、分母が等しくなるようF0で割る
    plot(Time,img.roi(iRoi).sub_back*100,'LineWidth',1.5,'color',colorRoi(iRoi,:));
    hold on
end

    

patch([0 2.5 2.5 0],[-300 -300 500 500], 'b','FaceAlpha',.2,'EdgeColor','none')
xlim([-50 50])% 軸の範囲
ylim([-20 200])
set(gca,'XTick',-50:10:50,'FontSize',18)% 軸の目盛り間隔
set(gca,'YTick',-20:20:200,'FontSize',14)
xlabel('Time(sec)','FontSize',14)% 軸ラベル
ylabel('\DeltaF/F_{0} (%)','FontSize',14)
title(NAME1,'interpreter','none');% タイトル
set(gca,'TickDir','out','Ticklength',[0.03 0])% Others
set(gca,'Color','none')
box off
axis square

savefig([filename '_cal']);

clear  b0 back_incre colorRoi F0 i ind iRoi NAME1  Regionx Regiony roisize_total scrsz Time Timescale vec_temp bs
%% Saving
 img.raw_img =[];
%  NAME1=uigetfile('*.tif');  
%  filename=NAME1(1:length(NAME1)-4);
 pathname='D:\Tsuksa Data\bero\ABLK\Ca imaging\MATLAB\ABLK file\Part-I'
 save(fullfile(pathname, filename));
 



 %save -v7.3 ([filename '.mat']);
%save([filename '2']);


