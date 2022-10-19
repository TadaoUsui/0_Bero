close all
clear

royalblue=[65 105 225]/255;
midnightblue = [25 25 112]/255;
orange = [255 165 0]/255;
orangered = [255 69 0]/255;
purple = [128 0 128]/255;
darkolivegreen = [85 107 47]/255;
yellowgreen = [154 205 50]/255;
crimson = [220 20 60]/255;
black = [0 0 0];
magentalike = [237 30 121]/255;
bluelike = [46 49 146]/255;
gray=[0.5 0.5 0.5];
skyblue=[0 162 232]/255;

set(0,'defaultAxesFontSize',10);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',10);
set(0,'defaultTextFontName','Arial');
scrsz = get(groot,'ScreenSize');

%% Loading
 load('TBAdata_example.mat'); ColorSet={black,bluelike};

fid=fopen('TBAdata_example.txt','wt');

for i=1:length(X)
    Genotype{i} = X(i).Genotype;
    Time{i} = X(i).Time';
    N(i) = length(Time{i});
end

for i=1:length(Time)
    for j=1:length(Time{i})
        if Time{i}(j)>1000
            Time{i}(j)=10.05;
        else
            Time{i}(j)=Time{i}(j)/100;
        end
    end
end

for k=1:length(N)
    P{k}=k*ones(1,N(k));
end

%% Histogram of rolling data
Fig1=figure('Position',[50 100 850 550]);
for i=1:length(Time)
    for j=1:10
        T(j)=sum(Time{i}>j-1 & Time{i}<=j)/length(Time{i})*100;
    end
    T(11)=sum(Time{i}>10)/length(Time{i})*100;
    MedianLatency(i)=median(Time{i});
     subplot(1,2,i) % Input your number here

    B=bar(T);
    set(B,'BarWidth',0.9,'FaceColor',ColorSet{i},'LineStyle','none')
    set(gca,'XTick',1:1:11,'TickDir','out','Color','none')
    set(gca,'TickLength',[0.025 0.025])
    set(gca,'YTick',0:10:60) %% INPUT!
    set(gca,'XTickLabel',{'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' 'N'})
    xlim([0.25 11.75])
    ylim([0 60]) %% INPUT!
    title(Genotype{i})
    xlabel('Time (s)')
    ylabel('Rolling (%)')    
    box off
    %axis square
    pbaspect([1.5 1 1])
end


%% Boxplot of rolling onset
Fig2=figure('Position',[50 100 850 550]);
plotSpread_TBA([Time(:)],'distributionColors',gray)
hold on
Time_Set=[Time{:}];
d=[P{:}];
%B1=boxplot(Time_Set,d,'Notch','on');
B1=boxplot(Time_Set,d);
set(B1(5,:),'color','k','linewidth',1)
set(B1(6,:),'color','k','linewidth',2)
ylim([-0.5 10.5])
set(gca,'XTickLabel',Genotype,'XTick',1:length(X),'YAxisLocation','left')
set(gca,'YTick',0:1:10,'TickDir','out')
set(gca,'Color','none')
ylabel('Time (s)')
view(90, 90)
box off
axis square

% Wilcoxon rank sum test
disp([sprintf('\n'),'Latency: Wilcoxon rank sum test'])
fprintf(fid,'\nLatency: Wilcoxon rank sum test');
pair=combnk(1:length(Time),2);
for j=1:size(pair,1)
    [p,h,stats]=ranksum(Time{pair(j,1)}, Time{:,pair(j,2)});
    W=sprintf(['   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    fprintf(fid,['\n   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    disp([sprintf('\n'),W])
    Pvalue(1,j)=p;
end


%% Roll or Not (2 groups)
for i=1:length(Time)
    Roll(i,1)=sum(Time{i}<=5);
    Roll(i,2)=sum(Time{i}>5);
    pRoll(i,:)=Roll(i,:)/length(Time{i})*100;
    [phat(i,1),pci(i,1:2)] = binofit(Roll(i,1), Roll(i,1)+Roll(i,2), 0.05);% 95% CI with Clopper-Pearson method
    CI(1,i)=pRoll(i,1);
    CI(2,i)=pci(i,2)*100;
    CI(3,i)=pci(i,1)*100;
end

Fig3=figure('Position',[50 100 850 550]);
B2=bar(pRoll,0.6,'stacked');
set(B2(1),'FaceColor',[0.6 0.6 0.6],'LineStyle','none')
set(B2(2),'FaceColor','w','LineStyle','none')
for i = 1:length(Time)
    line([i i],[pci(i,1:2)]*100,'LineWidth',1.2,'Color','k') % 95% CI
    hold on
end
xlim([0.4 length(Time)+0.6])
ylim([0 100])
set(gca,'XTickLabel',Genotype,'XTick',1:length(X),'YAxisLocation','left')
set(gca,'YTick',0:20:100,'TickDir','out')
set(gca,'TickLength',[0.025 0.025])
set(gca,'Color','none')
ylabel('Rolling (%)')
box off
axis square
view(90, 90)

% Fisher exact test
disp([sprintf('\n'),'Roll or Not: Fisher exact test'])
fprintf(fid,'\nRoll or Not: Fisher exact test');
pair=combnk(1:size(Roll,1),2);
for j=1:size(pair,1)
    [h,p,stats]=fishertest([Roll(pair(j,1),1:2); Roll(pair(j,2),1:2)]);
    W=sprintf(['   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    fprintf(fid,['\n   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    disp([sprintf('\n'),W])
    Pvalue(2,j)=p;
end


%% Early (0-2 s), Middle (2-5 s), Late (5-10 s), Not (4 groups)
for i=1:length(Time)
    ELN(i,1)=sum(Time{i}<=2);
    ELN(i,2)=sum(Time{i}>2 & Time{i}<=5);
    ELN(i,3)=sum(Time{i}>5 & Time{i}<=10);
    ELN(i,4)=sum(Time{i}>10);
    pELN(i,:)=ELN(i,:)/length(Time{i})*100;
end

Fig4=figure('Position',[50 100 850 550]);
B3=bar(pELN,0.5,'stacked');
set(B3(1),'FaceColor',[237 125 49]/255,'LineStyle','none')
set(B3(2),'FaceColor',[165 165 165]/255,'LineStyle','none')
set(B3(3),'FaceColor',[255 192 0]/255,'LineStyle','none')
set(B3(4),'FaceColor','w','LineStyle','none')
xlim([0.4 length(Time)+0.6])
ylim([0 100])
set(gca,'XTickLabel',Genotype,'XTick',1:length(X),'YAxisLocation','left')
set(gca,'YTick',0:20:100,'TickDir','out')
set(gca,'TickLength',[0.015 0.015])
set(gca,'Color','none')
ylabel('Rolling (%)')
box off
set(gca,'XTickLabelRotation',45)
pbaspect([1.5 1 1])

% Chi-squared test
disp([sprintf('\n'),'Early (0-2 s), Middle (2-5 s), Late (5-10 s), Not (4 groups): Chi-squared test'])
fprintf(fid,'\nEarly (0-2 s), Middle (2-5 s), Late (5-10 s), Not (4 groups): Chi-squared test');
pair=combnk(1:size(ELN,1),2);
for j=1:size(pair,1)
    x1 = [repmat('a',length(Time{pair(j,1)}),1); repmat('b',length(Time{pair(j,2)}),1)];
    x2 = [repmat(1,ELN(pair(j,1),1),1); repmat(2,ELN(pair(j,1),2),1); repmat(3,ELN(pair(j,1),3),1); repmat(4,ELN(pair(j,1),4),1); ...
        repmat(1,ELN(pair(j,2),1),1); repmat(2,ELN(pair(j,2),2),1); repmat(3,ELN(pair(j,2),3),1); repmat(4,ELN(pair(j,2),4),1)];
    [tbl,chi2,p] = crosstab(x1,x2);
    W=sprintf(['   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    fprintf(fid,['\n   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    disp([sprintf('\n'),W])
    Pvalue(3,j)=p;
end


%% violinplot of rolling onset
Fig5=figure('Position',[50 100 850 550]);
hold on
Time_Set=[Time{:}];
d=[P{:}];
%B1=boxplot(Time_Set,d,'Notch','on');
B1=violinplot(Time_Set,d,'Boxcolor',[0 0 0],'Width',0.25,'Bandwidth',1);
ylim([-0.5 10.5])
set(gca,'XTickLabel',Genotype,'XTick',1:length(X),'YAxisLocation','left')
set(gca,'YTick',0:1:10,'TickDir','out')
set(gca,'Color','none')
ylabel('Time (s)')
view(90, 90)
box off
axis square


savefig(Fig5,[datestr(now,'yyyymmdd_HHMMSS') '_' 'HProA_violin'])
saveas(Fig5,[datestr(now,'yyyymmdd_HHMMSS') '_' 'HProA_violin'],'tiff')