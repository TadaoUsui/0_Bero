fid=fopen([pathname csvname],'r');
a=textscan(fid,'%s',5000,'delimiter',',');
x=a{1}(1:5000);
data_size=find(strcmp(x,'mom_x(0)')==1)-2;
fclose(fid);
clear a

x=xlsread([pathname csvname],'B1:B20000');
n=(find(x==0,1)-1)/2;

csv=csvread([pathname csvname],1,1,[1,1,n*8,data_size]);
csv=[csv;zeros(n,data_size)]
csv=[csv;csvread([pathname csvname],n*9+1,1,[n*9+1,1,n*20,data_size])];

data_name=split(pathname,'\');
data_name=char(['data_' + data_name(end-2)]);
data_name(data_name=='.')='_';


data=cell(data_size,1);

data_index=1;
for larva_n=1:data_size
    larva=struct;
    k=1;
    % larva.mom_x=csvread(csvname,1+n*(k-1),larva_n,[1+n*(k-1),larva_n,n*k,larva_n]); %
    larva.mom_x=csv(1+n*(k-1):n*k,larva_n);

    f=find(larva.mom_x==0,1);
    if isempty(f)
        load_range=[1 n];
    else
        if f==1
            sta=find(larva.mom_x>0,1);
            en=find(larva.mom_x(sta:end)==0,1);
            if isempty(en)
                load_range=[sta n];
            else
                load_range=[sta en+sta-2];
            end
        else
            load_range=[1 f-1];
        end
    end


    larva.load_range=load_range-1;%
    larva.frame_number=load_range(2)-load_range(1)+1;%


    k=1;
    larva.mom_x=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    k=2;
    larva.mom_y=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=3;
    % larva.mom_dist=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=4;
    % larva.acc_dist=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=5;
    % larva.dst_to_origin=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    k=6;
    larva.area=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=7;
    % larva.perimeter=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=8
    % larva.spine_length=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=9;
    % larva.bending=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    k=10;
    larva.head_x=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    k=11;
    larva.head_y=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=12;
    % larva.spinepoint_1_x=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=13;
    % larva.spinepoint_1_y=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=14;
    % larva.spinepoint_2_x=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=15;
    % larva.spinepoint_2_y=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=16;
    % larva.spinepoint_3_x=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=17;
    % larva.spinepoint_3_y=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    k=18;
    larva.tail_x=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    k=19;
    larva.tail_y=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=20;
    % larva.radius_1=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=21;
    % larva.radius_2=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=22;
    % larva.radius_3=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=23;
    % larva.is_coiled=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=24;
    % larva.is_well_oriented=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=25;
    % larva.go_phase=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=26;
    % larva.left_bended=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=27;
    % larva.right_bended=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=28
    % larva.mov_direction=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=29;
    % larva.velocity=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %
    % k=30;
    % larva.acceleration=csv(n*(k-1) + load_range(1):n*(k-1) + load_range(2),larva_n:larva_n);; %


    mh=[larva.head_x-larva.mom_x larva.head_y-larva.mom_y];%middle to head vector
    tm=[larva.mom_x-larva.tail_x larva.mom_y-larva.tail_y];%tail to middle vector

    tail_to_head_vec=[larva.head_x-larva.tail_x larva.head_y-larva.tail_y];
    tail_to_head_vec_perpen=([0 -1;1 0]*tail_to_head_vec')';

    mom_velo=[0 0;diff(larva.mom_x) diff(larva.mom_y)];
    mom_velo_tail_to_head=sum(mom_velo.*tail_to_head_vec,2)./sum(tail_to_head_vec.*tail_to_head_vec,2) .* tail_to_head_vec;
    mom_velo_tail_to_head_perpen=mom_velo-mom_velo_tail_to_head;


    theta=atan2(mh(:,2),mh(:,1))/pi*180-atan2(tm(:,2),tm(:,1))/pi*180;

    theta(theta>180)=theta(theta>180)-360;
    theta(theta<-180)=theta(theta<-180)+360;


    larva.theta=theta;
    larva.mom_speed_tail_to_head=sum(mom_velo_tail_to_head.*mom_velo_tail_to_head,2);
    larva.mom_speed_tail_to_head_perpen=sum(mom_velo_tail_to_head_perpen.*mom_velo_tail_to_head_perpen,2);
    % l.head_speed_tail_to_head=sum(head_velo_tail_to_head.*head_velo_tail_to_head,2);
    % l.head_speed_tail_to_head_perpen=sum(head_velo_tail_to_head_perpen.*head_velo_tail_to_head_perpen,2);

    larva.mom_speed_tail_to_head(tail_to_head_vec(:,1).*mom_velo_tail_to_head(:,1)<0)=-larva.mom_speed_tail_to_head(tail_to_head_vec(:,1).*mom_velo_tail_to_head(:,1)<0);
    larva.mom_speed_tail_to_head_perpen(tail_to_head_vec_perpen(:,1).*larva.mom_speed_tail_to_head_perpen(:,1)<0)=-larva.mom_speed_tail_to_head_perpen(tail_to_head_vec_perpen(:,1).*larva.mom_speed_tail_to_head_perpen(:,1)<0);

    %%%%%%%%%%%%%
 

    larva.t=zeros(larva.frame_number,1)-1;




    larva.larva_number=larva_n;
    larva.max_frame_number=n;
    larva.name=data_name;
    larva.tif_dir=tif_dir;
    

    data{data_index}=larva;


    data_index=data_index+1;


end

data(data_index+1:end)=[];
data_connecting;



l=length(data);
for k=1:l
    if data{l-k+1}.frame_number<frame_number_threshold
    data(l-k+1)=[];
    end
end



save(data_name,'data')





clear x
clear larva
clear en
clear f
clear i
clear k
clear l
clear larva_n
clear load_range
clear sta
clear mh
clear mom_velo
clear mom_velo_tail_to_head
clear mom_velo_tail_to_head_perpen
clear head_velo
clear head_velo_tail_to_head
clear head_velo_tail_to_head_perpen
clear tail_to_head_vec
clear theta
clear tm
clear t
clear tail_to_head_vec_perpen

clear csv
clear a
clear b
clear ans
clear connect_number
clear csvname
clear data_index
clear data_name
clear data_size
clear fid
clear field_name
clear frame_length_threshold
clear j
clear n
clear nam
clear pathname
clear sorted_connect_number
clear tif_dir
clear x_length_threshold
clear y
clear y_length_threshold
clear frame_number_threshold

