%Shao-Fang Wang 2018
%file name
fname = 'stimuli_param_60features.csv';
fname_train = 'stimuli_param_60features_train.csv';
fname_test = 'stimuli_param_60features_test.csv';
%specify training features 
F1 = [1,2,3,4];
F2 = [1,2,3,4];
%F3 = [0,1,3,4];
%F3 = 0:0.1:7.7;
%F3 = F3(randperm(length(F3))); %randomise the list

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

tt = zeros(52,length(F1+F2));
%%feature01
temp = [];
for ii = 1:length(F1)%feature identity
    for ifreq = 1:f(ii).F1freq %first feature frequency
       temp = [temp; F1(ii)];
    end
end

n = 1;
for ii = 1:length(temp)
    tt(n,temp(ii))=1;
    n = n+1;
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


n = 1;
for ii = 1:length(temp2)
    tt(n,temp2(ii)+length(F1))=1;
    n = n+1;
end

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

n = 27;
for ii = 1:length(temp)
    tt(n,temp(ii))=1;
    n = n+1;
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

n = 27;
for ii = 1:length(temp2)
    tt(n,temp2(ii)+length(F1))=1;
    n = n+1;
end

%%feature03
temp3 = eye(52);

%%parameters for CatB
Cat_train_set = [tt temp3];
Cat_labels = zeros(52,1);
Cat_labels(1:26)=1;

%%save training stimuli parameters
csvwrite(fname_train,[Cat_train_set,Cat_labels])

%% New stimuli
%specify new features:
tnew = zeros(26,8);
CatA_train_feature_set_new = [
    1 F2(1); ...
    1 F2(2); ...
    1 datasample([F2(3),F2(4)],1); ...
    2 F2(1); ...
    2 F2(1); ...
    2 F2(2); ...
    2 F2(2); ...
    2 datasample([F2(3),F2(4)],1); ...
    3 F2(1); ...
    3 F2(2); ...
    3 datasample([F2(3),F2(4)],1); ...
    4 datasample([F2(1),F2(2)],1); ...
    4 datasample([F2(3),F2(4)],1)];



n = 1;
temp = CatA_train_feature_set_new(:,1);
for ii = 1:length(temp)
    tnew(n,temp(ii))=1;
    n = n+1;
end

n = 1;
temp2 = CatA_train_feature_set_new(:,2)
for ii = 1:length(temp2)
    tnew(n,temp2(ii)+length(F1))=1;
    n = n+1;
end


%%%
CatB_train_feature_set_new = [
    1 datasample([F2(1),F2(2)],1); ...
    1 datasample([F2(3),F2(4)],1); ...
    2 F2(3); ...
    2 F2(4); ...
    2 datasample([F2(1),F2(2)],1); ...
    3 F2(3); ...
    3 F2(3); ...
    3 F2(4); ...
    3 F2(4); ...
    3 datasample([F2(1),F2(2)],1); ...
    4 F2(3); ...
    4 F2(4); ...
    4 datasample([F2(1),F2(2)],1)];


n = 14;
temp = CatB_train_feature_set_new(:,1);
for ii = 1:length(temp)
    tnew(n,temp(ii))=1;
    n = n+1;
end

n = 14;
temp2 = CatB_train_feature_set_new(:,2)
for ii = 1:length(temp2)
    tnew(n,temp2(ii)+length(F1))=1;
    n = n+1;
end

%feature03
temp3new = eye(26);
New_set = [tnew temp3new];
New_labels = zeros(26,1);
New_labels(1:13)=1;
%%save training stimuli parameters
csvwrite(fname_test,[tnew New_labels])

%%% labels for train and test stimuli sets
Cat_train_set = [Cat_train_set ones(size(Cat_train_set,1),1)];
New_set = [[tnew New_labels] zeros(size(New_set,1),1)];
%Cat = [Cat_train_set; New_set];

%%%Plot
% for ii = 10:10:100
% h=figure(2);scatter3(Cat(:,1),Cat(:,2),Cat(:,3),120,C,'fill')
% view(ii,30)
% img_name = ['stimuli_dimension_train_test_',num2str(ii,'%03d'),'.jpg'];
% %saveas(h,img_name)
% pause
% end
% 
% h=figure(3);scatter3(New_set(:,1),New_set(:,2),New_set(:,3),120,'fill')
% img_name = ['stimuli_dimension_test.jpg'];
% saveas(h,img_name)
%% save stimuli parameters
csvwrite(fname,Cat)
%parameters for three features, category label, and train/test label

