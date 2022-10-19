
for k=1:length(data)


feature=[];
for i=1:data{k}.frame_number-pre-delay
    feature(i,:)=[data{k}.mom_speed_tail_to_head(i:pre+i+delay)' data{k}.mom_speed_tail_to_head_perpen(i:pre+i+delay)' data{k}.theta(i:pre+i+delay)'];
end

feature=abs(feature);
p=predict(cl,feature);

data{k}.p=p;
data{k}.cl_name='cl_name';
data{k}.delay='delay';
data{k}.pre='pre';

end


save([data{1}.name(1,:) '_Usui'])




