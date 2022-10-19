

t_result_vs_time=zeros(data{1}.max_frame_number,1);
how_many_larvae_are_recognized_at_that_time=zeros(data{1}.max_frame_number,1);

for k=1:length(data)

t_result_vs_time(data{k}.load_range(1)+1+pre:data{k}.load_range(2)+1-delay)=...
    t_result_vs_time(data{k}.load_range(1)+1+pre:data{k}.load_range(2)+1-delay)+(data{k}.p+1)/2;
  

how_many_larvae_are_recognized_at_that_time(data{k}.load_range(1)+1+pre:data{k}.load_range(2)+1-delay)=...
    how_many_larvae_are_recognized_at_that_time(data{k}.load_range(1)+1+pre:data{k}.load_range(2)+1-delay)+1;
end

rolling_rate = t_result_vs_time./how_many_larvae_are_recognized_at_that_time;
rolling_rate(find(isnan(rolling_rate)))=0;

save(['Rr ' data{1}.name '_Usui'],'rolling_rate','t_result_vs_time','how_many_larvae_are_recognized_at_that_time');

clearvars -except path D frame_number_threshold


