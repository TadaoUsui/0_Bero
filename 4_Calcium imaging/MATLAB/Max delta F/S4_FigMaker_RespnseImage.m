% jRCaMP intensity of before and after stimulation
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
img.FrameBefore = 250;
img.FrameAfter = 255;
img.fps = 1;
clims = [0 2500];
clims_res = [0 2];
% nRoi = 1;

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
filename=NAME1(1:length(NAME1)-4);
%% Image Before
figure('Position',[50 100 scrsz(3)*3/10 scrsz(4)*5/10])
imagesc(img.raw_img{img.FrameBefore,1}, clims);
axis('image','off')
colorbar
savefig([filename '_img_before'])
%% Image After
figure('Position',[50 100 scrsz(3)*3/10 scrsz(4)*5/10])
imagesc( img.raw_img{img.FrameAfter,1}, clims);
axis('image','off')
colorbar
savefig([filename '_img_after'])
%% Making Response
img.delta = img.raw_img{img.FrameAfter,1} -  img.raw_img{img.FrameBefore,1} ;
img.res = img.delta ./ img.raw_img{img.FrameBefore,1};

%% Image Response
figure('Position',[50 100 scrsz(3)*3/10 scrsz(4)*5/10])
imagesc(img.res, clims_res);
axis('image','off')
colorbar
savefig([filename '_img_res'])
