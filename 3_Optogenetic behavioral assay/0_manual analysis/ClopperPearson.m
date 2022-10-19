clear
close all

%% [Roll, Non-roll]
x=[49,26];% Opto (Conti)
%x=[84,11];% Opto (Inter)
%x=[62,42];% Light (black)
%x=[49,47];% Light (magenta)
%x=[35,30];% Light (orange)
%x=[13,5]% Ca (black)
%x=[9,2]% Ca (blue)
%x=[3,7]% Ca (magenta)

%% Usui-san protocol
p1=x(1)/sum(x);
s=p1*(1-p1);
CI1=1.96*sqrt(s/sum(x));
Range1=[p1, p1-CI1, p1+CI1];
W=sprintf(['   %4.2f +/- %4.2f percent'],p1*100,CI1*100);
disp([sprintf('\n'),W])

%% MATLAB function
[p2,pci] = binofit(x(1), sum(x), 0.05);
CI2=[p2-pci(1), pci(2)-p2, (pci(2)-pci(1))/2];
Range2=[p2, pci];

%% ver3
%r = binornd(100,p1);
p3=65.9/100;
s3=p3*(1-p3);
CI3=1.96*sqrt(s3/75);
Range3=[p3, p3-CI3, p3+CI3];

