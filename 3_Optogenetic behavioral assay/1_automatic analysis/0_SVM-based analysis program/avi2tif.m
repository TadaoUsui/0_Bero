% [videoname,pathname]=uigetfile('Image*.avi','Select a HPA movie','C:\Data\KAI_DATA\Opto HPA Data\170830'); %load manually
%[videoname,pathname]=uigetfile('Image*.avi','Select a HPA movie','C:\Data\Heat Pan Data\170712'); %load manually
D=dir(['C:\Data\Heat Pan Data\220505' '\Image*.avi'])
for i=1:length(D)
    videoname=D(i).name
    pathname=[D(i).folder '\']
v = VideoReader([pathname videoname]);

tic

im_plot=0;%% if you want to watch images, this is 1.
tif_make=1;%%if you want to make tif from movie,this is 1.

if tif_make==1
close all
foldername=[pathname videoname datestr(now,'yyyymmdd_HHMMSS')];
foldername(foldername=='.')='_';
mkdir([foldername '_tif'])
cd([foldername '_tif'])
end

ii=1;
image_number=1;
while hasFrame(v)
% while ii<2000
    if mod(ii,100)==0
        ii
    end
    
    if mod(ii,2)==0
        img = readFrame(v);
        % if you want to change the range of movie used, change this range.
        img_used=img(20:420,200:600,:);


    %         
        if im_plot==1
            imshow(img_used)
            title(ii)
            pause(0.1)
        end

        if tif_make==1
            filename = [sprintf('%04d',image_number) '.tif'];
            imwrite(img_used,filename)
        end

        image_number=image_number+1;
    end
    ii=ii+1;
    %if ii>4800 %convert only 2400 frames
    if ii>5400 %convert only 2700 frames
        break
    end
    
end


toc
% %% Continue or not Interface
% y=1;
% n=2;
% temp=input('Continue loading or not(y/n): ');
% if temp==2
%     break
% else
% end


end

