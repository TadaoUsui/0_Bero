% %% Plot
% %% %% Defalut setting
clear
% close all
sigma=10
genotype='ABLK-CsChrimson'

LED_delay=0 %
Temp_set='25'
Temp_set2='25\circC'
time_window = 900 %2700 %1800

rolling_rate_sum=zeros(time_window,1);

D=dir([pwd '\Rr *.mat'])

for i=1:length(D)
%% Loading Data
%load(uigetfile({'*.mat','All Files'})); %load manually
load([pwd '\' D(i).name]) %load automatically

rolling_rate(find(isnan(rolling_rate)))=0;
rolling_rate(find(rolling_rate>0))=1;
rolling_rate=rolling_rate(1:time_window);

rolling_rate_all{i}=rolling_rate
rolling_index{i}=find(rolling_rate>0);
individual_rolling_rate(i)=sum(rolling_rate)/time_window;

rolling_rate_sum=(rolling_rate_sum*(i-1)+rolling_rate)/i;
% %% Continue or not Interface
% y=1;
% n=2;
% temp=input('Continue loading or not(y/n): ');
% if temp==2
%     break
% else
% end


end

counter=0;
for i = 1:length(rolling_index)
    counter=counter+any(rolling_index{i}+LED_delay<60);
end
rolling_rate_in_2sec=counter/length(rolling_index);

counter=0;
for i = 1:length(rolling_index)
    counter=counter+any(rolling_index{i}+LED_delay<150);
end
rolling_rate_in_5sec=counter/length(rolling_index);

counter=0;
for i = 1:length(rolling_index)
    counter=counter+any(rolling_index{i}+LED_delay<300);
end
rolling_rate_in_10sec=counter/length(rolling_index);

counter=0;
for i = 1:length(rolling_index)
    counter=counter+any(rolling_index{i}+LED_delay<600);
end
rolling_rate_in_20sec=counter/length(rolling_index);
rolling_rate_in_xsec=[rolling_rate_in_2sec rolling_rate_in_5sec rolling_rate_in_10sec rolling_rate_in_20sec];

rolling_rate_in_jsec=zeros(time_window,1);
for j =1:time_window
    counter=0;
    for i = 1:length(rolling_index)
        counter=counter+any(rolling_index{i}+LED_delay<j);
    end
    rolling_rate_in_jsec(j)=counter/length(rolling_index);
end

for i = 1:length(rolling_index)
    if length(rolling_index{i})== 0
        latency(i)= 30;
    else
    latency(i)=(rolling_index{i}(1)+LED_delay)/30;
    end
end

A(1).rolling_rate_all=rolling_rate_all;
A(1).rolling_index=rolling_index;
A(1).individual_rolling_rate=individual_rolling_rate;

clearvars -except A genotype Temp_set Temp_set2 rolling_rate_sum rolling_rate_in_xsec latency rolling_rate_in_jsec time_window 
save([datestr(now,'yyyymmdd_HHMMSS') '_' 'iHPA2' ' ' genotype '_' Temp_set  ])

clear all