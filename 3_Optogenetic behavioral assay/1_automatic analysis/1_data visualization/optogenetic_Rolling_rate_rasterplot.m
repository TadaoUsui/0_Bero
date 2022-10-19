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

LED=oBlue
% LED=oOrange
% LED=oGreen
Heat=oRed

LED_delay=0 %22

set(0,'defaultAxesFontSize',12);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',12);
set(0,'defaultTextFontName','Arial');



%% Loading
load(uigetfile({'*.mat','All Files'}));

compensation(1)=0;% To space between different genotypes
main_title=['iHPA2 ' genotype ' ' Temp_set2];

HeatX = [0 0 time_window/30 time_window/30];
LEDX = [5 5 time_window/30 time_window/30];

%% Raster plots
Fig1=figure('Position',[50 100 500 1000]);

% For each genotype
for i=1:length(A)
    Fs=30;
    rolling_index{i}=A(i).rolling_index;
    individual_rolling_rate{i}=A(i).individual_rolling_rate;
    
    [B,I]=sort(individual_rolling_rate{i},'ascend');
    % "I" is the order along the sorting
    for j = 1:length(rolling_index{i})
        rolling_index2{i}{j}=rolling_index{i}{I(j)};% To rearrange dataset
    end
    
    if i>1
        compensation(i)=length(rolling_index2{i-1})+compensation(i-1)+2;
        % To space between different genotypes
    end
    
    for j = 1:length(rolling_index2{i})
        for k = 1:length(rolling_index2{i}{j})
            line(([rolling_index2{i}{j}(k)+LED_delay rolling_index2{i}{j}(k)+LED_delay])/30,[j-0.4 j+0.4]+compensation(i),'color','k','LineWidth',0.003);
        end
    end
    
    if Temp_set=='46' % Heat shade
    Y = [0.6 0 0 0.6]+compensation(i)
    patch(HeatX,Y, Heat,'EdgeColor','none','FaceAlpha',0.6);
    end
    
    % LED shade
    Y = [1-0.4 length(rolling_index2{i})+0.4 length(rolling_index2{i})+0.4 1-0.4]+compensation(i)
    patch(LEDX,Y, LED,'EdgeColor','none','FaceAlpha',0.15);

    clearvars -except i A rolling_index2 compensation rolling_rate_sum genotype Temp_set main_title rolling_rate_in_xsec latency Fig1 time_window
end


            
xlim([0 time_window/30])
ylim([0 length(rolling_index2{length(A)})+compensation(length(A))+1])
set(gca,'XTick',0:5:time_window/30,'TickDir','out')
set(gca,'YTick',1:1:length(rolling_index2{length(A)})+compensation(length(A)),'TickDir','out')
set(gca,'Color','none')
box off
axis ij
xlabel('Time (s)')


suptitle(main_title)

savefig(Fig1,[datestr(now,'yyyymmdd_HHMMSS') '_' 'iHPA2 ' genotype '_' Temp_set '_2'])
saveas(Fig1,[datestr(now,'yyyymmdd_HHMMSS') '_' 'iHPA2 ' genotype '_' Temp_set  '_2'],'tiff')

clear all