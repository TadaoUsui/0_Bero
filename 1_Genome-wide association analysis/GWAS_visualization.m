clear

% load gaws txt file
filename = 'gwas_all_rolling5.txt'
t=readtable(filename);
ID = table2array(t(:,1));
ID3 = extractBetween(ID,1,2);
SingleMixedPval = table2array(t(:,8));
SinglePval = table2array(t(:,6));

x_interval = 20000; % interval between the plots of distinct groups
y = SingleMixedPval;
Idx = 1:length(y);
n = length(y);

% find index of SNPs on different chromosome region
Id_2L = find(contains(ID3, '2L'));
Id_2R = find(contains(ID3, '2R'));
Id_3L = find(contains(ID3, '3L'));
Id_3R = find(contains(ID3, '3R'));
Id_x = find(contains(ID3, 'X_'));
Id_4 = find(contains(ID3, '4_'));

% rearrange the x axes of SNPs
Idx_x = Id_x - Id_x(1) + 1 + x_interval;
Idx_2L = Id_2L + length(Id_x) + x_interval*2;
Idx_2R = Id_2R + length(Id_x) + x_interval*3;
Idx_3L = Id_3L + length(Id_x) + x_interval*4;
Idx_3R = Id_3R + length(Id_x) + x_interval*5;
Idx_4 = Id_4 + x_interval*6;

X_tick = [median(Idx_x) median(Idx_2L) median(Idx_2R) median(Idx_3L) median(Idx_3R) median(Idx_4)];
X_tickLabel = {'X' '2L' '2R' '3L' '3R' '4'};

% get P value
y_2L = y(Id_2L);
y_2R = y(Id_2R);
y_3L = y(Id_3L);
y_3R = y(Id_3R);
y_x = y(Id_x);
y_4 = y(Id_4);

Y_tick = [10^-7 10^-6 10^-5 10^-4 10^-3 10^-2 10^-1 1];
Y_tickLabel = {'7' '6' '5' '4' '3' '2' '1' '0'};

Fig1 = figure('Position',[50 100 1250 550]);
semilogy(Idx_2L(y_2L>=10^(-5)),y_2L(y_2L>=10^(-5)),'.','MarkerEdgeColor',([0.635 0.078 0.184]+1)/2)
hold on
semilogy(Idx_2L(y_2L<10^(-5)),y_2L(y_2L<10^(-5)),'.','MarkerEdgeColor',[0.635 0.078 0.184])
hold on

semilogy(Idx_2R(y_2R>=10^(-5)),y_2R(y_2R>=10^(-5)),'.','MarkerEdgeColor',([0 0.447 0.741]+1)/2)
hold on
semilogy(Idx_2R(y_2R<10^(-5)),y_2R(y_2R<10^(-5)),'.','MarkerSize',20,'MarkerEdgeColor',[0 0.447 0.741])
hold on

semilogy(Idx_3L(y_3L>=10^(-5)),y_3L(y_3L>=10^(-5)),'.','MarkerEdgeColor',([0.466 0.6740 0.188]+1)/2)
hold on
semilogy(Idx_3L(y_3L<10^(-5)),y_3L(y_3L<10^(-5)),'.','MarkerSize',20, 'MarkerEdgeColor',[0.466 0.6740 0.188])
hold on

semilogy(Idx_3R(y_3R>=10^(-5)),y_3R(y_3R>=10^(-5)),'.','MarkerEdgeColor',([0.494 0.184 0.556]+1)/2)
hold on
semilogy(Idx_3R(y_3R<10^(-5)),y_3R(y_3R<10^(-5)),'.','MarkerSize',20,'MarkerEdgeColor',[0.494 0.184 0.556])
hold on

semilogy(Idx_x(y_x>=10^(-5)),y_x(y_x>=10^(-5)),'.','MarkerEdgeColor',([0.85 0.325 0.098]+1)/2)
hold on
semilogy(Idx_x(y_x<10^(-5)),y_x(y_x<10^(-5)),'.','MarkerSize',20,'MarkerEdgeColor',[0.85 0.325 0.098])
hold on

semilogy(Idx_4(y_4>=10^(-5)),y_4(y_4>=10^(-5)),'.','MarkerEdgeColor',([0.929 0.694 0.125]+1)/2)
hold on
semilogy(Idx_4(y_4<10^(-5)),y_4(y_4<10^(-5)),'.','MarkerSize',20,'MarkerEdgeColor',[0.929 0.694 0.125])


set(gca,'YDir','reverse')
title('Rolling5')
xlabel('SNPs')
ylabel('-log_10(P-value)')
set(gca, 'box', 'off')
set(gca,'TickDir','out','Color','none', 'LineWidth', 1.5)
ylim([10^-9 1.5])
xlim([-60000 max(Idx_4)+60000])
set(gca,'XTick',X_tick,'XTickLabel',X_tickLabel,'YAxisLocation','left');
set(gca,'YTick',Y_tick,'YTickLabel',Y_tickLabel,'XAxisLocation','bottom');

savefig(Fig1,[datestr(now,'yyyymmdd_HHMMSS') '_' filename(1:(length(filename)-4))])
saveas(Fig1,[datestr(now,'yyyymmdd_HHMMSS') '_' filename(1:(length(filename)-4))],'tiff')
