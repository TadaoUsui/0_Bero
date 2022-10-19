clear feature
tic

%% hyper parameters

pre=10;%previous frames used to recognize rolling at certain frame. 
delay=10;%post frames used to recognize rolling at certain frame.

%false_negative_penalty=1;% strength of penalty when the answer of model is false negative.
						 % if this number is big, this model tend to predict positive (often answer rolling)
                         % 1: Posi:Nega = 1
c_set=[0.00001 1 10000]; 
% c_set=1

ganma_set=[0.00001 1 10000];
% ganma_set=1

%% parameter you set when you evaluate hyperparameter
test_data_rate=0.5;% data not assigned as test data are used as training data.
				  % so if this number is small, you regard many data as training data.

test_data_size=round(test_data_rate*length(data));
%%

				   
random_test_data=randperm(length(data));


clear results_test
clear results_train
clear correct_percentage_for_test_data
clear correct_percentage_for_training_data
clear hit_test
clear hit_test_mean


best_accuracy = 0;

for c_loop=1:length(c_set)
    for ganma_loop=1:length(ganma_set)
        for j=1:length(data)/test_data_size  %closs validation
            %%%%%%%%%%%%%%
%             if j==2
%                 break
%             end
            %%%%%%%%%%%%%%%

            %% feature
            test_set=random_test_data(1+(j-1)*test_data_size:j*test_data_size);%[1 40 randperm(length(data),10)];
            x=[];
            t=[];
            x_test=[];
            t_test=[];

            for k=1:length(data)
                if ~isempty(data{k})

                    %data{k}
                    for i=1:data{k}.frame_number-pre-delay
                        feature(i,:)=[data{k}.mom_speed_tail_to_head(i:pre+i+delay)' data{k}.mom_speed_tail_to_head_perpen(i:pre+i+delay)' data{k}.theta(i:pre+i+delay)'];
                    end
                    if data{k}.frame_number-pre-delay<1
                        feature=[];
                    end
        %             feature(:,size(feature,2)/3+1:end)=abs(feature(:,size(feature,2)/3+1:end));
                    feature=abs(feature);

                    %test_set
                    if isempty(find(test_set==k, 1))
                        x=[x;feature];
                        t=[t;data{k}.t(pre+1:end-delay)];
                    else
                        x_test=[x_test;feature];
                        t_test=[t_test;data{k}.t(pre+1:end-delay)];
                    end
                    clear feature
                end
            end

          %% 
            
            c=c_set(c_loop);
            ganma=ganma_set(ganma_loop);
%             cl = fitcsvm(x,t,'KernelFunction','rbf','Standardize',true,'BoxConstraint',c,'KernelScale',ganma,'Cost',[0 1;false_negative_penalty 0]);
            cl = fitcsvm(x,t,'KernelFunction','rbf','Standardize',true,'BoxConstraint',c,'KernelScale','auto','Cost',[0 mean(t == 1);mean(t == -1) 0]);

            %% predict
            % test dat
            if ~isempty(t_test)
            p_test=predict(cl,x_test);
            correct_percentage_for_test_data(j)=sum(p_test==t_test)/length(t_test);
            hit_test(j)=sum((p_test==1).*(t_test==1))/sum(t_test==1);
            [sum((p_test==1).*(t_test==1))/sum(t_test==1) ...           % True Positive
                sum((p_test==-1).*(t_test==1))/sum(t_test==1)...        % False Nenegative
                sum((p_test==1).*(t_test==-1))/sum(t_test==-1)...       % False Positive
                sum((p_test==-1) .* (t_test==-1))/sum(t_test==-1)]      % True Negative
            end

           

            % training dat
            p=predict(cl,x);
            correct_percentage_for_training_data(j)=sum(p==t)/length(t);
            % [sum((p==1).*(t==1))/sum(t==1)...
            %     sum((p==-1).*(t==1))/sum(t==1)...
            %     sum((p==1).*(t==-1))/sum(t==-1)...
            %     sum((p==-1).*(t==-1))/sum(t==-1)]



        end

        results_test(c_loop,ganma_loop)=mean(correct_percentage_for_test_data)
        results_train(c_loop,ganma_loop)=mean(correct_percentage_for_training_data)
        hit_test_mean(c_loop,ganma_loop)=mean(hit_test)
        '----------'
        if best_accuracy < results_test(c_loop, ganma_loop)
            best_accuracy = results_test(c_loop, ganma_loop)
            c_best = c_set(c_loop);
            ganma_best = ganma_set(ganma_loop);
            cl_best = cl;
        end
    end
end

cl = cl_best;


toc