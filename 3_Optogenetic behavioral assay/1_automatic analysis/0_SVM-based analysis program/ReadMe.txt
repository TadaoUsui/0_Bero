FIMTrack is available in 'https://www.uni-muenster.de/PRIA/en/FIM/download.shtml'



how to predict rolling when you have already trained a classifier model. 

‡@run avi2tif.m
	select movie
		this code makes tif images FIMTrack can load.
‡Arun FIMTrack and track larvae (the manual is available)
	according to my experience, 'gray threshold' = 40, 'min larvae area' = 20, 'max larvae area'=100 is OK.
‡Brun csv_load_and_analysis.m
	select output.csv FIMTrack made
		this code load csv and calculate velocity and angle of larvae.
		data from csv is saved
‡Crun predict_rolling.m
		prediction is included by data{k}.p (k is larva number)





when you want to train new model.

if you already have true label, you can skip to ‡F
‡@‡A‡B are same as above.

‡Cload 'data' made in ‡B.
‡Drun make_magnification_movie.m
	this code makes movies of each larvae
‡Emake true labels by watching movies made.
	format is same as examples by Usui-san.
		csv is also OK. 
‡Frun load_true_label.m  (if you clear data, please load data again)
	select xlsx or csv including true label.
		this code load true labels and write these to data structure.
‡Grun svm_train
	you load all data used in training and combine them.
		hyperparameter are 'pre', 'delay', 'c, 'ganma', and 'false_positive_penalty'
			pre  : do you use how many frames before the frame you want to assign as rolling or not
			delay: do you use how many frames after the frame you want to assign as rolling or not
			c,ganma  : the bigger this is, the simpler the model.   if prediction accuracy in training data is high, maybe you should make this parameter bigger.
			false_positive_penalth : when this parameter is big, the model tends to avoid false positive. so this model select negative more time.
		when you optimize hyperparameter, you make 'test_data_size' big to some extent.
		model is included in 'cl'
		when you predict rolling, you need 'cl', 'pre', and 'delay'. So you should save these 3.




other scripts explanation:
data_connecting.m:
	this script is used in 'csv_load_and_analysis'.
	this connect 2 larvae, when one larva vanished and other larva appeared then near vanishing one.
first_rolling_time.m:
	this calculate first rolling time.
	before you run this script, you must predict and make data{k}.p, which is predicted result.
	if you want to calculate about data{k}.t not data{k}.p, you should rewrite.
rolling_vs_time.m:
	this calculate rolling or not at that time.
	before you run this script, you must predict and make data{k}.p, which is predicted result.
load_data_together.m:
	load several 'data' whose name include same name. for example, 01_23.
animation_of_larva.m:
	animation of one larva.
	you designate one larva by decide 'k'.
	if 'prediction_want' is 1, this scripts predict rolling or not about the larva.
when_collision_occur:
	when some larvae vanished at once, probably collision occured.
	this script calculate when such collision occured.
plus_minus_number:
	how many plus and minus the 'data{k}.t' include. this tell you ununiformity of your data set.
	
	




contents of 'data{k}'
	mom_x,mom_y: center of gravity of larva. this is calculated in FIMTrack.
	load_range : frames when this larva is tracked.
	frame_number: during how many frames, this larva is tracked.  
	area : area of larva. this is calculated in FIMTrack.
	head_x,head_y: positions of head of larva.
	tail_x,tail_y: positions of tail of larva.
	theta: angle of head-mom-tail.
	mom_speed_tail_to_head: speed parallel to tail-head vector.
	mom_speed_tail_to_head_perpen: speed perpendicularto tail-head vectior.
	t: label used in training. when you load data from table.csv, 
	larva_number: number FIMTrack assigned to the larva. when 'data_connecting.m' merge 2 larva, this marged larva has some 'larva_number'.
	max_frame_number: how many frame of the movie which include the larva
	name: the name of the movie includes the larva