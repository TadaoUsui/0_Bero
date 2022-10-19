
for k=1:length(data)
    pl(k)=sum(data{k}.t==1);
    m(k)=sum(data{k}.t==-1);
end


sum(pl)
sum(m)