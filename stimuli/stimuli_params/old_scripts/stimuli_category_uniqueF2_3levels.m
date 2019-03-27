%Shao-Fang Wang 2018
%file name
fname = 'stimuli_param_uniqueF2.csv';
fname_train = 'stimuli_param_uniqueF2_train.csv';
fname_test = 'stimuli_param_uniqueF2_test.csv';
%specify training features 
F1 = [1,2,3,4,5];
F2endLevel=36;

%%%
F2 = 1:F2endLevel;
F201= 1:3:F2endLevel;
F202 = 2:3:F2endLevel;
F203 = 3:3:F2endLevel;

F201temp = F201(1:3:end);
F202temp = F202(1:3:end);
F203temp = F203(1:3:end);


F201temp2 = F201(2:3:end);
F202temp2 = F202(2:3:end);
F203temp2 = F203(2:3:end);


F201(1:3:end)=F202temp;
F202(1:3:end)=F203temp;
F203(1:3:end)=F201temp;

F201(2:3:end)=F203temp2;
F202(2:3:end)=F201temp2;
F203(2:3:end)=F202temp2;


F201 = F201(randperm(size(F201,2)));
F202 = F202(randperm(size(F202,2)));
F203 = F203(randperm(size(F203,2)));
%%
%category A: training
f(1).F1freq = 1;
f(2).F1freq = 4;
f(3).F1freq = 1;

%%feature01
temp = [];
for ii = 1:length(F1)%feature identity
    for ifreq = 1:f(ii).F1freq %first feature frequency
       temp = [temp; F1(ii)];
    end
end
%%feature02
temp3 = F201(1:length(F201)/2);%F3(randperm(size(temp2,1)));
Atemp3 = temp3';

%%parameters for CatA
CatA_train_feature_set = [temp Atemp3 ones(length(temp),1)];%3 features + category label

%%
%category B: training
%F1_freq = [4 6 10 6];
%F2_freq = [4 4 9 9];
f(1).F1freq = 1;
f(2).F1freq = 1;
f(3).F1freq = 4;


%%feature01
temp = [];
for ii = 1:length(F1)%feature identity
    for ifreq = 1:f(ii).F1freq %first feature frequency
       temp = [temp; F1(ii)];
    end
end

%%feature03
temp3 = F201((length(F201)/2)+1:end);
Btemp3 = temp3';

%%parameters for CatB
CatB_train_feature_set = [temp Btemp3 zeros(length(temp),1)];%3 features + category label

Cat_train_set = [CatA_train_feature_set; CatB_train_feature_set];

if sum(ismember(Atemp3,Btemp3))>0
    error('Feature 3 is not item unique across the two categories')
end
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
h=figure(1);scatter(Cat_train_set(:,1),Cat_train_set(:,2),120,C,'fill')
view(ii,30)
img_name = ['stimuli_dimension_train_',num2str(ii,'%03d'),'.jpg'];
%saveas(h,img_name)
pause
end

%%save training stimuli parameters
csvwrite(fname_train,Cat_train_set)

%% New stimuli
%specify new features:
%F1new = F1;
%F2new = 2;
lia= ismember(F3_B,Btemp3);
F3new = F3_B(lia==0);
F3new_subsetA = datasample(F3new,13);

CatA_train_feature_set_new = [
    1 F2(1) F3new_subsetA(1); ...
    1 F2(2) F3new_subsetA(2); ...
    1 datasample([F2(3),F2(4)],1) F3new_subsetA(3); ...
    2 F2(1) F3new_subsetA(4); ...
    2 F2(1) F3new_subsetA(5); ...
    2 F2(2) F3new_subsetA(6); ...
    2 F2(2) F3new_subsetA(7); ...
    2 datasample([F2(3),F2(4)],1) F3new_subsetA(8); ...
    3 F2(1) F3new_subsetA(9); ...
    3 F2(2) F3new_subsetA(10); ...
    3 datasample([F2(3),F2(4)],1) F3new_subsetA(11); ...
    4 datasample([F2(1),F2(2)],1) F3new_subsetA(12); ...
    4 datasample([F2(3),F2(4)],1) F3new_subsetA(13)];


lia = ismember(F3new,F3new_subsetA);
F3new_subsetB = F3new(lia==0);

CatB_train_feature_set_new = [
    1 datasample([F2(1),F2(2)],1) F3new_subsetB(1); ...
    1 datasample([F2(3),F2(4)],1) F3new_subsetB(2); ...
    2 F2(3) F3new_subsetB(3); ...
    2 F2(4) F3new_subsetB(4); ...
    2 datasample([F2(1),F2(2)],1) F3new_subsetB(5); ...
    3 F2(3) F3new_subsetB(6); ...
    3 F2(3) F3new_subsetB(7); ...
    3 F2(4) F3new_subsetB(8); ...
    3 F2(4) F3new_subsetB(9); ...
    3 datasample([F2(1),F2(2)],1) F3new_subsetB(10); ...
    4 F2(3) F3new_subsetB(11); ...
    4 F2(4) F3new_subsetB(12); ...
    4 datasample([F2(1),F2(2)],1) F3new_subsetB(13)];

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
%saveas(h,img_name)
pause
end

h=figure(3);scatter3(New_set(:,1),New_set(:,2),New_set(:,3),120,'fill')
img_name = ['stimuli_dimension_test.jpg'];
saveas(h,img_name)
%% save stimuli parameters
csvwrite(fname,Cat)
%parameters for three features, category label, and train/test label

