clear all
clc
%specify levels for each feature
%three features in total
newfName = 'uniqueF1F2_3levels_candidates';
F1_level = [10 25 40];
F2_level = [40 25 10];
F1_level_num = length(F1_level);
F2_level_num = length(F2_level);


mtr = ones(F2_level_num,F1_level_num);
start = F1_level_num;
step = [1,2,3];

%total = [3,5,7];
total = [3,5,7];%sum for each level
F3Set = 6;%2 train cat; 2 test cat; 2 memory test
F3traintestSet = 4;%2 train cat; 2 test cat
%%%
%% Generating F3 sets
F3 = [repmat(15,1,sum(total)*F3traintestSet)];
F3 = F3(randperm(length(F3)));
F3traintestGroup = reshape(F3,length(F3)/F3traintestSet,F3traintestSet)';
for ii = 1:F3traintestSet
ff3(ii).orig = F3traintestGroup(ii,:);
end

%% Generating possible category feature frequencies and calculate opt behavior
%F1:
for currLevel = 1:3%loop through each level -- all possible ways to sum up as total
if sum(mtr(:,currLevel)) ~= total(currLevel)
    partitions_mtr = partitions(total(currLevel));

    f = 1;
    for irow = 1:size(partitions_mtr,1)
        row = partitions_mtr(irow,:);
        for ii = 1:size(row,2)
            if row(ii)>0
                com(ii).row = repmat(ii,1,row(ii));
            end
        end

        if length([com(:).row])==F1_level_num
            partition_results(currLevel).mtr(f,:) = [com(:).row];
            f=f+1;
        end
        clear com row
    end
end
end


%generate all possible mtrs
first = ones(1,3);
index = 1;
for l2 = 1:size(partition_results(2).mtr,1)
second = partition_results(2).mtr(l2,:);
for l3 = 1:size(partition_results(3).mtr,1)
    third = partition_results(3).mtr(l3,:);
    final(index).mtr = [first;second;third];
    index = index+1;
end
end

%calculate best performance
c = 1;
for ifinal = 1:length(final)
final(ifinal).sumrow = sum(final(ifinal).mtr);
final(ifinal).sumcol = sum(final(ifinal).mtr,2);

temp = flipud(fliplr(final(ifinal).mtr));%mtr for the other category
totalnum = temp+final(ifinal).mtr;

cat1prob = temp./totalnum;
cat2prob = final(ifinal).mtr./totalnum;

for irow = 1:size(cat1prob,1)
    for icol = 1:size(cat1prob,2)
        larger_prob(irow,icol) = max(cat1prob(irow,icol),cat2prob(irow,icol));
        larger_prob(irow,icol) = larger_prob(irow,icol)*totalnum(irow,icol);
    end
end
totalprob = sum(sum(larger_prob));
final(ifinal).optimal = totalprob/sum(sum(totalnum));

if isequal(final(ifinal).sumrow,total)
    candidate(c).mtrCatA = final(ifinal).mtr;
    candidate(c).mtrCatB = temp;
    candidate(c).optima_per = final(ifinal).optimal;
    c = c+1;
end
clear temp
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate parameter list
for c = 1:length(candidate)
newdir = [newfName,num2str(c,'%02d')];
if ~exist(newdir)
    mkdir(newdir)
    cd(newdir)
else
    cd(newdir)
end
%% Generate category features for training and testing sets
paramA = [];
paramB = [];
for irow = 1:size(candidate(c).mtrCatA,1)
    tempF2 = F2_level(irow);
    for icol = 1:size(candidate(c).mtrCatA,2)
        tempF1 = F1_level(icol);
        temp = [tempF1 tempF2];
        paramA = [paramA; repmat(temp,candidate(c).mtrCatA(irow,icol),1)];

        paramB = [paramB; repmat(temp,candidate(c).mtrCatB(irow,icol),1)];
    end
end

%% Category A training and testing sets
paramATrain = [];
paramATest = [];
paramANovel = [];
%candidate(c).paramA = [paramA Atemp3];%F3(randperm(size(temp2,1)));

%%%majorA
majorA = F1_level(3);
majorIndex = find(paramA(:,1)==majorA);

f1temp = [majorA-1 majorA majorA+1];
for ifeature = 1:length(F1_level)
    tempf = F1_level(ifeature);
    tempfreq = sum(paramA(majorIndex,2)==tempf);
    if tempfreq>1
        f2temp = [tempf-2 tempf-1 tempf tempf+1];
    else
        f2temp = [tempf];
    end
    t = 1;
    for i1 = 1:length(f1temp)
        for i2 = 1:length(f2temp)
            tempcom(t,:)=[f1temp(i1) f2temp(i2)];
            t = t+1;
        end
    end
    tempcom = tempcom(randperm(size(tempcom,1)),:);
    ind = randsample(size(tempcom,1),tempfreq*2);
    paramATrain = [paramATrain;tempcom(ind(1:tempfreq),:)];
    paramATest = [paramATest;tempcom(ind((tempfreq+1):tempfreq*2),:)];
    clear tempcom
end

minA = F1_level(1);
minIndex = find(paramA(:,1)==minA);
f1temp = [minA-6 minA+6];
for ifeature = 1:length(F1_level)
    tempf = F1_level(ifeature);
    tempfreq = sum(paramA(minIndex,2)==tempf);
    f2temp = [tempf-6 tempf+6];

    t = 1;
    for i1 = 1:length(f1temp)
        for i2 = 1:length(f2temp)
            tempcom(t,:)=[f1temp(i1) f2temp(i2)];
            t = t+1;
        end
    end

    tempcom = tempcom(randperm(size(tempcom,1)),:);
    ind = randsample(size(tempcom,1),tempfreq*2);
    paramATrain = [paramATrain;tempcom(ind(1:tempfreq),:)];
    paramATest = [paramATest;tempcom(ind((tempfreq+1):tempfreq*2),:)];
    clear tempcom
end

medtempA = F1_level(2);
medIndex = find(paramA(:,1)==medtempA);
f1temp = [medtempA-3 medtempA medtempA+3];
for ifeature = 1:length(F1_level)
    tempf = F1_level(ifeature);
    tempfreq = sum(paramA(medIndex,2)==tempf);
    if tempfreq>1
        f2temp = [tempf-3 tempf tempf+3];
    else
        f2temp = [tempf];
    end

    t = 1;
    for i1 = 1:length(f1temp)
        for i2 = 1:length(f2temp)
            tempcom(t,:)=[f1temp(i1) f2temp(i2)];
            t = t+1;
        end
    end

    tempcom = tempcom(randperm(size(tempcom,1)),:);
    ind = randsample(size(tempcom,1),tempfreq*2);
    paramATrain = [paramATrain;tempcom(ind(1:tempfreq),:)];
    paramATest = [paramATest;tempcom(ind((tempfreq+1):tempfreq*2),:)];
    clear tempcom
end

%%%%%
%% Category B
paramBTrain = [];
paramBTest = [];

majorB = F1_level(1);
majorIndex = find(paramB(:,1)==majorB);
f1temp = [9 10 11];

for ifeature = 1:length(F1_level)
    tempf = F1_level(ifeature);
    tempfreq = sum(paramB(majorIndex,2)==tempf);
    if tempfreq>1
        f2temp = [tempf-2 tempf-1 tempf tempf+1];
    else
        f2temp = [tempf];
    end

    t = 1;
    for i1 = 1:length(f1temp)
        for i2 = 1:length(f2temp)
            tempcom(t,:)=[f1temp(i1) f2temp(i2)];
            t = t+1;
        end
    end

    tempcom = tempcom(randperm(size(tempcom,1)),:);
    ind = randsample(size(tempcom,1),tempfreq*2);
    paramBTrain = [paramBTrain;tempcom(ind(1:tempfreq),:)];
    paramBTest = [paramBTest;tempcom(ind((tempfreq+1):tempfreq*2),:)];
    clear tempcom
end

%%%%%
minB = F1_level(3);
minIndex = find(paramB(:,1)==minB);

f1temp = [minB-6 minB+6];
for ifeature = 1:length(F1_level)
    tempf = F1_level(ifeature);
    tempfreq = sum(paramB(minIndex,2)==tempf);

    f2temp = [tempf-6 tempf+6];

    t = 1;
    for i1 = 1:length(f1temp)
        for i2 = 1:length(f2temp)
            tempcom(t,:)=[f1temp(i1) f2temp(i2)];
            t = t+1;
        end
    end

    tempcom = tempcom(randperm(size(tempcom,1)),:);
    ind = randsample(size(tempcom,1),tempfreq*2);
    paramBTrain = [paramBTrain;tempcom(ind(1:tempfreq),:)];
    paramBTest = [paramBTest;tempcom(ind((tempfreq+1):tempfreq*2),:)];
    clear tempcom
end

%%%%%%
medtempB = F1_level(2);
medIndex = find(paramB(:,1)==medtempB);

f1temp = [medtempB-3 medtempB medtempB+3];

for ifeature = 1:length(F1_level)
    tempf = F1_level(ifeature);
    tempfreq = sum(paramB(medIndex,2)==tempf);
    if tempfreq>1
        f2temp = [tempf-3 tempf tempf+3];
    else
        f2temp = [tempf];
    end

    t = 1;
    for i1 = 1:length(f1temp)
        for i2 = 1:length(f2temp)
            tempcom(t,:)=[f1temp(i1) f2temp(i2)];
            t = t+1;
        end
    end

    tempcom = tempcom(randperm(size(tempcom,1)),:);
    ind = randsample(size(tempcom,1),tempfreq*2);
    paramBTrain = [paramBTrain;tempcom(ind(1:tempfreq),:)];
    paramBTest = [paramBTest;tempcom(ind((tempfreq+1):tempfreq*2),:)];
    clear tempcom
end

%% Combininb feature 3

Atemp3 = ff3(1).orig;
Atemp3 = Atemp3(randperm(length(Atemp3)))';
candidate(c).paramA = [paramATrain Atemp3];

Btemp3 = ff3(2).orig;
Btemp3 = Btemp3(randperm(length(Btemp3)))';
candidate(c).paramB = [paramBTrain Btemp3];


AtempTest3 = ff3(3).orig;
AtempTest3 = AtempTest3(randperm(length(AtempTest3)))';
candidate(c).NewparamA = [paramATest AtempTest3];

BtempTest3 = ff3(4).orig;
BtempTest3 = BtempTest3(randperm(length(Btemp3)))';
candidate(c).NewparamB = [paramBTest BtempTest3];

%%
candidate(c).param = [candidate(c).paramA;candidate(c).paramB];

%%%%
Catlabels = zeros(size(candidate(c).param,1),1);
Catlabels(1:length(Atemp3))=1;
candidate(c).paramlabels = [candidate(c).param Catlabels eye(size(Catlabels,1))];

%% Plot training sets
%%%Plot
color1 = [0.9 0.4 0.4];%color for category A (red)
color2 = [0.4 0.4 0.9]; % color for category B (blue)
C = [];
for ii = 1:size(candidate(c).paramA,1)
    C = [C; color1];
end

for ii = 1:size(candidate(c).paramB,1)
    C = [C; color2];
end

h=figure(1);scatter(candidate(c).param(:,1),candidate(c).param(:,2),120,C,'fill')
title(['candidate ' num2str(c) ' optimal ' num2str(candidate(c).optima_per) ' stimuli dimension train ',num2str(ii,'%03d')])
img_name = ['candidate' num2str(c) 'optimal' num2str(candidate(c).optima_per) 'stimuli_dimension_train',num2str(ii,'%03d'),'.jpg'];
saveas(h,img_name)

%% Testing sets
candidate(c).Newparam = [candidate(c).NewparamA;candidate(c).NewparamB];

NewCatlabels = zeros(size(candidate(c).Newparam,1),1);
NewCatlabels(1:length(candidate(c).NewparamA))=1;
candidate(c).Newparamlabels = [candidate(c).Newparam NewCatlabels eye(size(NewCatlabels,1))];
%%% labels for train and test stimuli sets
candidate(c).allparam = [candidate(c).param ones(size(candidate(c).param,1),1); candidate(c).Newparam zeros(size(candidate(c).Newparam,1),1)];

%%%%%plot
colorNew1 = [0.6 0.2 0.3];%color for category A (red)
colorNew2 = [0.3 0.2 0.6]; % color for category B (blue)
%C = [];
for ii = 1:size(candidate(c).NewparamA,1)
    C = [C; colorNew1];
end

for ii = 1:size(candidate(c).NewparamB,1)
    C = [C; colorNew2];
end

%%%Plot
h=figure(2);scatter(candidate(c).allparam(:,1),candidate(c).allparam(:,2),120,C,'fill')
img_name = ['candidate ' num2str(c) ' optimal ' num2str(candidate(c).optima_per) ' stimuli_dimension_train_test_',num2str(ii,'%03d'),'.jpg'];
saveas(h,img_name)

%%%Novel stimuli for memory tests
% noveltemp3 = [ff3(5).orig ff3(6).orig];%all object specific feature
% F1F2Novel = [paramA; paramB];
% NovelMemoryparam = [F1F2Novel noveltemp3(randperm(length(noveltemp3)))'];
% candidate(c).NovelMemoryparam = NovelMemoryparam;
% 
% candidate(c).train_test_memory_param =  [candidate(c).param ones(size(candidate(c).param,1),1); ...
%     candidate(c).Newparam zeros(size(candidate(c).Newparam,1),1);...
%     candidate(c).NovelMemoryparam ones(size(candidate(c).NovelMemoryparam,1),1)*-1];
% 
% colorNovelobject = [0.4,0.9,0.4];%color for novel object
% allC = C;
% for ii = 1:size(NovelMemoryparam,1)
%     allC = [allC;colorNovelobject];
% end
% 
% %%%plot
% for ii = 10:10:100
%     h3=figure(3);scatter3(candidate(c).train_test_memory_param(:,1),candidate(c).train_test_memory_param(:,2),candidate(c).train_test_memory_param(:,3),100,allC,'fill')
%     view(ii,30)
%     img_name_novel = ['candidate ' num2str(c) ' optimal ' num2str(candidate(c).optima_per) ' stimuli_dimension_train_test_memory',num2str(ii,'%03d'),'.jpg'];
%     saveas(h3,img_name_novel)
%     %pause
% end%


%%
fname_train = ['candidate',num2str(c),'_optimal',num2str(round(candidate(c).optima_per,2)*100),'_stimuli_param_uniqueF1F2_train.csv'];
%     save
csvwrite(fname_train,candidate(c).paramlabels)

fname_test = ['candidate',num2str(c),'_optimal',num2str(round(candidate(c).optima_per,2)*100),'_stimuli_param_uniqueF1F2_test.csv'];
%     save
csvwrite(fname_test,candidate(c).Newparamlabels)
cd ../
end

save(newfName,'candidate')



