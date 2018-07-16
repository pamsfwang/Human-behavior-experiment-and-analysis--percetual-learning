%Shao-Fang Wang 2018
%file name
fname = 'stimuli_param_uniqueF3.csv';
fname_train = 'stimuli_param_uniqueF3_train.csv';
fname_test = 'stimuli_param_uniqueF3_test.csv';
%specify training features 
F1 = [1,2,3,4];
F2 = [1,2,3,4];
%F3 = [0,1,3,4];
F3 = 0:0.1:7;

%%
%category A: training
%F1_freq = [6 10 6 4];
%F2_freq = [9 9 4 4];
f(1).F1freq = 6;
f(1).F2freq = [2 2 1 1];
f(2).F1freq = 10;
f(2).F2freq = [4 4 1 1 ];
f(3).F1freq = 6;
f(3).F2freq = [2 2 1 1];
f(4).F1freq = 4;
f(4).F2freq = [1 1 1 1];

%%feature01
temp = [];
for ii = 1:length(F1)%feature identity
    for ifreq = 1:f(ii).F1freq %first feature frequency
       temp = [temp; F1(ii)];
    end
end

%%feature02
temp2 = [];
for ii = 1:length(F1)%feature identity
for i2 = 1:length(F2)%feature identity
    for ifreq2 = 1:f(ii).F2freq(i2) %second feature frequency
        temp2 = [temp2;F2(i2)];
    end
end
end

%%feature03
temp3 = datasample(F3,size(temp2,1),'Replace',false);%F3(randperm(size(temp2,1)));
temp3 = temp3';

CatA_train_feature_set = [temp temp2 temp3 ones(length(temp),1)];%3 features + category label

%%
%category B: training
%F1_freq = [4 6 10 6];
%F2_freq = [4 4 9 9];
f(1).F1freq = 4;
f(1).F2freq = [1 1 1 1];
f(2).F1freq = 6;
f(2).F2freq = [1 1 2 2];
f(3).F1freq = 10;
f(3).F2freq = [1 1 4 4];
f(4).F1freq = 6;
f(4).F2freq = [1 1 2 2];

%%feature01
temp = [];
for ii = 1:length(F1)%feature identity
    for ifreq = 1:f(ii).F1freq %first feature frequency
       temp = [temp; F1(ii)];
    end
end

%%feature02
temp2 = [];
for ii = 1:length(F1)%feature identity
for i2 = 1:length(F2)%feature identity
    for ifreq2 = 1:f(ii).F2freq(i2) %second feature frequency
        temp2 = [temp2;F2(i2)];
    end
end
end

%%feature03
lia = ismember(F3,temp3);
F3 = F3(lia==0);
temp3 = datasample(F3,size(temp2,1),'Replace',false);
temp3 = temp3';
% temp3 = [];
% for ii = F1
%     switch ii
%         case {1,3}
%             t1 = datasample(F3,2, 'Replace', true);
%             t2 = datasample(F3,2, 'Replace', true);
%             t3 = datasample(F3,2, 'Replace', true);
%             
%             temp3 = [temp3; t1'; t2'; t3'];
%         case 2
%             t = datasample(F3,2, 'Replace', true);
%             temp3 = [temp3; F3'; F3'; t'];
%         case 4
%           t = F3(randperm(4));
%           temp3 = [temp3; t'];
%     end
%     
%     %temp3(ii)=datasample(F3,1);
% end
CatB_train_feature_set = [temp temp2 temp3 zeros(length(temp),1)];%3 features + category label

Cat_train_set = [CatA_train_feature_set; CatB_train_feature_set];

%%%Plot
c = [0.9 0.4 0.4];%color for category A (red)
c2 = [0.4 0.4 0.9]; % color for category B (blue)
C = [];
    for ii = 1:size(CatA_train_feature_set,1)
        C = [C; c];
    end

    for ii = 1:size(CatB_train_feature_set,1)
        C = [C; c2];
    end
    
for ii = 10:10:100
h=figure(1);scatter3(Cat_train_set(:,1),Cat_train_set(:,2),Cat_train_set(:,3),120,C,'fill')
view(ii,30)
img_name = ['stimuli_dimension_train_',num2str(ii,'%03d'),'.jpg'];
saveas(h,img_name)
pause
end

%%save training stimuli parameters
csvwrite(fname_train,Cat_train_set)

%% New stimuli
%specify new features:
F1new = F1;
F2new = F2;
lia= ismember(F3,temp3);
F3new = F3(lia==0);
F3new_subset = datasample(F3new,16);

CatA_train_feature_set_new = [1 0 F3new_subset(1); ...
    1 1 F3new_subset(2); ...
    2 0 F3new_subset(3); ...
    2 1 F3new_subset(4); ...
    2 datasample(([3,4]),1) F3new_subset(5); ...
    3 0 F3new_subset(6); ...
    3 1 F3new_subset(7); ...
    4 datasample(([0,1]),1) F3new_subset(8)];

CatB_train_feature_set_new = [1 datasample(([3,4]),1) F3new_subset(9); ...
    2 3 F3new_subset(10); ...
    2 4 F3new_subset(11); ...
    3 3 F3new_subset(12); ...
    3 4 F3new_subset(13); ...
    3 datasample(([0,1]),1) F3new_subset(14); ...
    4 3 F3new_subset(15); ...
    4 4 F3new_subset(16)];

CatA_new = [CatA_train_feature_set_new ones(size(CatA_train_feature_set_new,1),1)];
CatB_new = [CatB_train_feature_set_new zeros(size(CatB_train_feature_set_new,1),1)];

New_set = [CatA_new; CatB_new];
%%save training stimuli parameters
csvwrite(fname_test,New_set)

%%plot
c = [0.6 0.2 0.3];%color for category A (red)
c2 = [0.3 0.2 0.6]; % color for category B (blue)
%C = [];
     for ii = 1:size(CatA_train_feature_set_new,1)
         C = [C; c];
     end
 
     for ii = 1:size(CatB_train_feature_set_new,1)
         C = [C; c2];
     end

%%% labels for train and test stimuli sets
Cat_train_set = [Cat_train_set ones(size(Cat_train_set,1),1)]
New_set = [New_set zeros(size(New_set,1),1)];
Cat = [Cat_train_set; New_set];

%%%Plot
for ii = 10:10:100
h=figure(2);scatter3(Cat(:,1),Cat(:,2),Cat(:,3),120,C,'fill')
view(ii,30)
img_name = ['stimuli_dimension_train_test_',num2str(ii,'%03d'),'.jpg'];
saveas(h,img_name)
pause
end

h=figure(3);scatter3(New_set(:,1),New_set(:,2),New_set(:,3),120,'fill')
img_name = ['stimuli_dimension_test.jpg'];
saveas(h,img_name)
%% save stimuli parameters
csvwrite(fname,Cat)
%parameters for three features, category label, and train/test label

