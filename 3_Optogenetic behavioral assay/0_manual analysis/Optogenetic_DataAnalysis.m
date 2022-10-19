clear
close all

%% load Opto xlsx file
filename = 'ABLK_SELK_opto_activation_sum.xlsx'
T = readtable(filename,'Sheet','Sheet1');
Genotype = table2array(T(:,1));
N = table2array(T(:,2));
RollingN = table2array(T(:,3));
BendingN = table2array(T(:,4));

fid=fopen([filename(1:(length(filename)-5)) '.txt'],'wt');


%% Roll or Bend or Not (3 groups)

for i=1:length(N)
    NoResponse(i) = N(i) - RollingN(i) - BendingN(i) 
    RollingR(i) = RollingN(i)/N(i);
    BendingR(i) = BendingN(i)/N(i);
    NR(i) = (N(i)- RollingN(i) -BendingN(i))/N(i)
    [Rollphat(i,1),Rollpci(i,1:2)] = binofit(RollingN(i), N(i), 0.05);% 95% CI with Clopper-Pearson method Roll or Not (2 groups)
    [Bendphat(i,1),Bendpci(i,1:2)] = binofit(BendingN(i), N(i), 0.05);% 95% CI with Clopper-Pearson method Bend or Not (2 groups)

end

BehaviorR(:,1) = RollingR;
BehaviorR(:,2) = BendingR;
BehaviorR(:,3) = NR;
BehaviorR(:,4) = NoResponse;

BehaviorRT = array2table(BehaviorR,'VariableNames',{'RollingR','BendingR','NoResponseR','NoResponse'});

Output(:,1) = Rollphat;
Output(:,2) = Rollpci(:,1);
Output(:,3) = Rollpci(:,2);
Output(:,4) = Bendphat;
Output(:,5) = Bendpci(:,1);
Output(:,6) = Bendpci(:,2);

OutputT = array2table(Output,'VariableNames',{'Rollphat','Rollpci1','Rollpci2','Bendphat','Bendpci1','Bendpci2'});

Fig=figure('Position',[50 100 850 550]);
B2=bar(BehaviorR*100,0.6,'stacked');
set(B2(1),'FaceColor',[237 125 49]/255,'LineStyle','none')
set(B2(2),'FaceColor',[255 192 0]/255,'LineStyle','none')
set(B2(3),'FaceColor',[165 165 165]/255,'LineStyle','none')

xlim([0.4 length(N)+0.6])
ylim([0 100])
set(gca,'XTickLabel',Genotype,'XTick',1:length(N),'YAxisLocation','left')
set(gca,'YTick',0:25:100,'TickDir','out')
set(gca,'TickLength',[0.025 0.025])
set(gca,'Color','none')
ylabel('Rolling (%)')
box off

% Fisher exact test
NotRollingN = N - RollingN;
NotRollingNT = array2table(NotRollingN,'VariableNames',{'NotRollingN'});

disp([sprintf('\n'),'Roll or Not: Fisher exact test'])
fprintf(fid,'\nRoll or Not: Fisher exact test');
pair=combnk(1:length(N),2);%
for j=1:size(pair,1)
    [h,p,stats]=fishertest([[RollingN(pair(j,1)) NotRollingN(pair(j,1))]; [RollingN(pair(j,2)) NotRollingN(pair(j,2))]]);
    W=sprintf(['   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    fprintf(fid,['\n   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    disp([sprintf('\n'),W])
end


% Chi-squared test
disp([sprintf('\n'),'Roll or Bend or No Response: (3 groups): Chi-squared test'])
fprintf(fid,'\nRoll or Bend or No Response: (3 groups): Chi-squared test');
pair=combnk(1:length(N),2);%
for j=1:size(pair,1)
    x1 = [repmat('a',N(pair(j,1)),1); repmat('b',N(pair(j,2)),1)];
    x2 = [repmat(1,RollingN(pair(j,1)),1); repmat(2,BendingN(pair(j,1)),1); repmat(3,NoResponse(pair(j,1)),1); ...
        repmat(1,RollingN(pair(j,2)),1); repmat(2,BendingN(pair(j,2)),1); repmat(3,NoResponse(pair(j,2)),1)];
    [tbl,chi2,p] = crosstab(x1,x2);
    
    W=sprintf(['   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    fprintf(fid,['\n   ',Genotype{pair(j,1)},' vs ',Genotype{pair(j,2)},': p=%f'],p);
    disp([sprintf('\n'),W])
end


NewT = [T NotRollingNT BehaviorRT OutputT];
writetable(NewT,[filename(1:(length(filename)-5)) '_analyzed.xlsx'] );
savefig(Fig,[datestr(now,'yyyymmdd_HHMMSS') '_' 'RollorNot'])
saveas(Fig,[datestr(now,'yyyymmdd_HHMMSS') '_' 'RollorNot'],'tiff')