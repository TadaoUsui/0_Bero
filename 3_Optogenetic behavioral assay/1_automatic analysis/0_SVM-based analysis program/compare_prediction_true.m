close all
k=11; 

    if exist('pre')==0
        pre=data{k}.pre;
    end
    if exist('delay')==0
        delay=data{k}.delay;
    end

% prediction

    feature=[];
    for i=1:data{k}.frame_number-pre-delay
        feature(i,:)=[data{k}.mom_speed_tail_to_head(i:pre+i+delay)' data{k}.mom_speed_tail_to_head_perpen(i:pre+i+delay)' data{k}.theta(i:pre+i+delay)'];
    end

    feature=abs(feature);
    p=predict(cl,feature);
    % p(i_list)=-1;

    plot(p)
    hold on
    plot(data{k}.t(pre+1:end-delay))
    ylim([-1.5 1.5])
    legend('prediction','true')

    sum(p==data{k}.t(pre+1:end-delay))/length(p)% correct answer rate



