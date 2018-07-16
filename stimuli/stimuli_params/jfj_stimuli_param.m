%Jiefeng's stimuli set
%file name
fname = 'jfj_stimuli_param.csv';
fname_train = 'jfj_stimuli_param_train.csv';
fname_test = 'jfj_stimuli_param_test.csv';
%specify training features 
F1 = [1,2,3,4];
F2 = [0,1,3,4];
F3 = [0,1,3,4];

%%categoryA
f(1).F1freq = 3;
f(1).F2freq = [1 2 0 0];
f(2).F1freq = 5;
f(2).F2freq = [2 3 0 0];
f(3).F1freq = 5;
f(3).F2freq = [0 0 3 2];
f(4).F1freq = 3;
f(4).F2freq = [0 0 2 1];

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
temp3 = repmat(F3,1,4);
temp3 = temp3';

CatA_train_feature_set = [temp temp2 temp3 ones(length(temp),1)];%3 features + category label

%%category B
f(1).F1freq = 3;
f(1).F2freq = [0 0 2 1];
f(2).F1freq = 5;
f(2).F2freq = [0 0 3 2];
f(3).F1freq = 5;
f(3).F2freq = [2 3 0 0];
f(4).F1freq = 3;
f(4).F2freq = [1 2 0 0];

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
temp3 = repmat(F3,1,4);
temp3 = temp3';

CatB_train_feature_set = [temp temp2 temp3 zeros(length(temp),1)];%3 features + category label

%%combine 2 sets
Cat_train_set = [CatA_train_feature_set; CatB_train_feature_set];
%%plot
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
img_name = ['jfj_stimuli_dimension_train_',num2str(ii,'%03d'),'.jpg'];
saveas(h,img_name)
pause
end

%%save training stimuli parameters
csvwrite(fname_train,Cat_train_set)
%% New stimuli
%Each level in F3 appears 4 times 
CatA_train_feature_set_new = [
    1 1 2
    2 1 2
    3 3 2
    4 3 2];

CatB_train_feature_set_new = [
    1 3 2
    2 3 2
    3 1 2
    4 1 2];

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

img_name = ['jfj_stimuli_dimension_traintest_',num2str(ii,'%03d'),'.jpg'];
saveas(h,img_name)
pause
end

figure(3);scatter3(New_set(:,1),New_set(:,2),New_set(:,3),120,'fill')
img_name = ['jfj_stimuli_dimension_test_',num2str(ii,'%03d'),'.jpg'];
saveas(h,img_name)
%% save stimuli parameters
csvwrite(fname,Cat)
%parameters for three features, category label, and train/test label

