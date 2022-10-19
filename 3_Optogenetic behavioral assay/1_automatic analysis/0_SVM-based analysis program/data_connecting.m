%parameter
frame_length_threshold=1;
x_length_threshold=5;
y_length_threshold=5;

connect_number=1;
while isempty(connect_number)==0
    
    clear sta
    clear en
    for k=1:length(data)
        sta(k)=data{k}.load_range(1);
        en(k)=data{k}.load_range(2);
    end

    connect_number=[];
    j=1;
    for k=1:length(data)
        f=find( ((sta-en(k))<=frame_length_threshold) & ((sta-en(k))>0));
        if f>0
            for i=1:length(f)
                if abs(data{k}.mom_x(end)-data{f(i)}.mom_x(1))<x_length_threshold
                    if abs(data{k}.mom_y(end)-data{f(i)}.mom_y(1))<y_length_threshold
                        connect_number=[connect_number;[k f(i)]];
                        j=j+1;
                    end
                end
            end
        end
    end

    if ~isempty(connect_number)==1
    [a,b]=unique(connect_number(:,1));
    connect_number=connect_number(b,:);
    end


    field_name=fieldnames(data{1});

    for i=1:size(connect_number,1)
        if sum(connect_number(:,1)==connect_number(i,2))>0
            continue
        end
        for k=1:length(field_name)
            nam=field_name(k);
            if strcmp(nam{1},'load_range')

                x=getfield(data{connect_number(i,1)},nam{1});
                y=getfield(data{connect_number(i,2)},nam{1});
                data{connect_number(i,1)}.load_range=[x(1) y(2)];
            elseif strcmp(nam{1},'frame_number')
                data{connect_number(i,1)}.frame_number=data{connect_number(i,1)}.frame_number+data{connect_number(i,2)}.frame_number;
            elseif strcmp(nam{1},'max_frame_number')
            elseif strcmp(nam{1},'name')
            elseif strcmp(nam{1},'tif_dir')
            else
                x=getfield(data{connect_number(i,1)},nam{1});
                y=getfield(data{connect_number(i,2)},nam{1});
                data{connect_number(i,1)}.(nam{1})=[x;y];
            end
        end
    end


    if length(connect_number)>0
        sorted_connect_number=sort(connect_number(:,2));
    end

    for k=1:size(connect_number,1)
        if sum(connect_number(:,1)==sorted_connect_number(-k+size(connect_number,1)+1))==0
            data(sorted_connect_number(-k+size(connect_number,1)+1))=[];
        end
    end


 
end