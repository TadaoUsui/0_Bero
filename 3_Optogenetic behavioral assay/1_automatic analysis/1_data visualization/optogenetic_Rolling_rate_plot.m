%% ----------Making raster plots---------- %%

%% Default setting
clear
close all


% Optimized colorset for blindness
oBlack=[0 0 0]/255;
oGray1=[127 135 143]/255;% dark
oGray2=[200 200 203]/255;% light
oWhite=[255 255 255]/255;
oRed=[255 40 0]/255;
oVermi=[213 94 0]/255;
oOrange=[230 159 0]/255;
oYellow=[240 228 66]/255;
oGreen=[0 158 115]/255;
oBlue=[0 114 178]/255;
oSky=[86 180 233]/255;
oPurple=[204 121 167]/255;


set(0,'defaultAxesFontSize',12);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',12);
set(0,'defaultTextFontName','Arial');
LED_delay=0 %22


%% Loading
load(uigetfile({'*.mat','All Files'}));

compensation(1)=0;% To space between different genotypes
main_title=['iHPA2 ' genotype ' ' Temp_set2];

% LED=oBlue
LED=oOrange
% LED=oGreen
LEDX = [5 5 time_window/30 time_window/30]
Heat=oRed
HeatX = [0 0 time_window/30 time_window/30]

%% Raster plots
Fig1=figure('Position',[50 100 800 1000]);


subplot(4,1,1)
trialTime=((1+LED_delay)/30:1/30:(time_window+LED_delay)/30);
plot(trialTime,rolling_rate_sum,'Color',[50/255 105/255 195/255],'LineWidth',1)

   if Temp_set=='46'% Heat shade
        Y = [1 1.1 1.1 1]
        patch(HeatX,Y, Heat,'EdgeColor','none','FaceAlpha',0.6);
   end
   
   % LED shade
        Y = [0 1 1 0]
        patch(LEDX,Y, LED,'EdgeColor','none','FaceAlpha',0.15);

ylim([0 1.1])
xlim([0 time_window/30])
box off
set(gca,'tickdir','out','Color','none')
set(gca,'XTick',0:5:time_window/30)
ylabel('Rolling rate')
xlabel('Time(s)')

subplot(4,1,2)
% boxplot(latency,'Orientation','horizontal')
bp=boxplot(latency,'Orientation','horizontal','Colors',[0 0 0],'Symbol','o');

% LED shade
    Y = [0 2 2 0]
    patch(LEDX,Y, LED,'EdgeColor','none','FaceAlpha',0.15);
    
xlim([0 time_window/30])
box off
set(bp,'linewidth',1.5)
set(gca,'tickdir','out','Color','none')
set(gca,'YTick',[])
set(gca,'XTick',0:5:time_window/30)
ylabel({})
xlabel('Latency(s)')

subplot(4,1,3)
trialTime=(1/30:1/30:time_window/30);
plot(trialTime,rolling_rate_in_jsec,'Color',[50/255 105/255 195/255],'LineWidth',1)

% LED shade
    Y = [0 1 1 0]
    patch(LEDX,Y, LED,'EdgeColor','none','FaceAlpha',0.15);
    
ylim([0 1])
box off
set(gca,'tickdir','out','Color','none')
set(gca,'XTick',0:5:time_window/30)
ylabel('Accumulative Rolling rate')
xlabel('Time(s)')

subplot(4,1,4)
% rolling_rate_in_xsec=[rolling_rate_in_2sec rolling_rate_in_5sec rolling_rate_in_10sec rolling_rate_in_20sec];
bar(rolling_rate_in_xsec,'BarWidth',0.5,'EdgeColor','none','FaceColor',[72 103 214]/256)
box off
set(gca,'tickdir','out','Color','none')
set(gca,'xticklabels',{'Within 2 sec','Within 5 sec','Within 10 sec','Within 20 sec'})
ylabel('Rolling rate')
ylim([0 1])
suptitle(main_title)

savefig(Fig1,[datestr(now,'yyyymmdd_HHMMSS') '_' 'iHPA2 ' genotype '_' Temp_set '_1'])
saveas(Fig1,[datestr(now,'yyyymmdd_HHMMSS') '_' 'iHPA2 ' genotype '_' Temp_set  '_1'],'tiff')

