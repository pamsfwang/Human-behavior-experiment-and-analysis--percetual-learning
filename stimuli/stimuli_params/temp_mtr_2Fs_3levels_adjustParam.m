clear all
clc
%specify levels for each feature
%three features in total
F1_level = [10 30 50];
F2_level = [50 30 10];
F1_level_num = length(F1_level);
F2_level_num = length(F2_level);

mtr = ones(F2_level_num,F1_level_num);
start = F1_level_num;
step = [1,2,3];

%total = [3,5,7];
total = [3,5,7];%sum for each level
F3Set = 6;%2 train cat; 2 test cat; 2 memory test
F3traintestSet = 4;
%%%
%% Generating F3 sets
F3 = [repmat(15,1,15) repmat(20,1,15),repmat(25,1,15) repmat(30,1,15)];
F3 = F3(randperm(length(F3)));
F3traintestGroup = reshape(F3,length(F3)/F3traintestSet,F3traintestSet)';
for ii = 1:F3traintestSet
    ff3(ii).orig = F3traintestGroup(ii,:);
end
% F3 = 1:(sum(total)*6);
% F3group = reshape(F3,length(F3)/F3Set,F3Set);
% index = ismember(F3,F3group(:,[1 F3Set])');
% F3traintest = F3(index==0);
% 
% 
% F3traintestGroup = reshape(F3traintest,length(F3traintest)/F3traintestSet,F3traintestSet)
% 
% for ii = 1:F3traintestSet
%     ff3(ii).orig = F3traintest(ii:F3traintestSet:end);
%     ff3(ii).t(1).x = ff3(ii).orig(1:F3traintestSet:end);
%     ff3(ii).t(2).x = ff3(ii).orig(2:F3traintestSet:end);
%     ff3(ii).t(3).x = ff3(ii).orig(3:F3traintestSet:end);
% end

% sets = [
%     2,3,4,1;
%     3,4,1,2;
%     4,1,2,3];
% 
% sets = sets(randperm(size(sets,1)),:);
% 
% for in = 1:size(sets,1)
%     index = sets(in,:);
%     ff3(1).orig(in:F3traintestSet:end)=ff3(index(1)).t(in).x;
%     ff3(2).orig(in:F3traintestSet:end)=ff3(index(2)).t(in).x;
%     ff3(3).orig(in:F3traintestSet:end)=ff3(index(3)).t(in).x;
%     ff3(4).orig(in:F3traintestSet:end)=ff3(index(4)).t(in).x;
% end
% 
% for ii = 1:F3traintestSet
%     testmtr(:,ii)=ff3(ii).orig';
% end
% anova1(testmtr)

close all
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
    newdir = ['uniqueF3_F1F2_3levels_candidate',num2str(c,'%02d')];
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
    
    %%%unique combination of category features
    newparamA = paramA(:,1)*1000+paramA(:,2);
    newparamB = paramB(:,1)*1000+paramB(:,2);
    uniqCombo = unique(newparamA);
    for ic = 1:length(uniqCombo)
        uniqCombo(ic,2)=sum(newparamA==uniqCombo(ic,1))*2;%training + testing
        uniqCombo(ic,3)=sum(newparamB==uniqCombo(ic,1))*2;
    end
    
    paramATrain = [];
    paramATest = [];
    
    paramBTrain = [];
    paramBTest = [];
    
    for ic = 1:length(uniqCombo)
        %feature levels
        tempf1 = floor(uniqCombo(ic,1)/1000);
        tempf2 = uniqCombo(ic,1)-floor(uniqCombo(ic,1)/1000)*1000;
        fprintf('feature levels: %d %d\n',tempf1,tempf2)
        %%%When number of two categories are the same
        if uniqCombo(ic,2)==uniqCombo(ic,3)
            Catparam = [];
            t = 1;
            for ii = [tempf1-6 tempf1+6] %feature01
                for i2 = [tempf2-6 tempf2+6] %feature02
                    Catparam(t,:)=[ii i2];
                    t = t+1;
                end
            end
            
            
            Catparam = Catparam(randperm(length(Catparam)),:);
            totalindex = 1:size(Catparam,1);
            
            totalfreq = uniqCombo(ic,2)+uniqCombo(ic,3);
            index = randsample(size(Catparam,1),totalfreq);
            CatAIndex = index(randsample(totalfreq,uniqCombo(ic,2)));
            CatBIndex = index(ismember(index,CatAIndex)==0);
            
            tempATrain = Catparam(CatAIndex(1:uniqCombo(ic,2)/2),:);
            tempATest = Catparam(CatAIndex(uniqCombo(ic,2)/2+1:end),:);
            
            tempBTrain = Catparam(CatBIndex(1:uniqCombo(ic,3)/2),:);
            tempBTest = Catparam(CatBIndex(uniqCombo(ic,3)/2+1:end),:);
            
            paramATrain = [paramATrain; tempATrain];
            paramATest = [paramATest; tempATest];
            
            paramBTrain = [paramBTrain; tempBTrain];
            paramBTest = [paramBTest; tempBTest];
            
            
        end
        %%%When number of two categories are the different
        if uniqCombo(ic,2)~=uniqCombo(ic,3)
            majorNum = max(uniqCombo(ic,2),uniqCombo(ic,3));
            minorNum = min(uniqCombo(ic,2),uniqCombo(ic,3));
            %%%the larger category
            majorCat = [];
            t = 1;
            for ii = tempf1-1:tempf1+1 %feature01
                for i2 = tempf2-1:tempf2+1 %feature02
                    majorCat(t,:)=[ii i2];
                    t = t+1;
                end
            end
            majorCat = majorCat(randperm(length(majorCat)),:);
            totalindex = 1:size(majorCat,1);
            
            index = randsample(size(majorCat,1),majorNum);
            trainIndex = index(randsample(majorNum,majorNum/2));
            testIndex = index(ismember(index,trainIndex)==0);
            tempTrain = majorCat(trainIndex,:);
            tempTest = majorCat(testIndex,:);
            
            clear index trainIndex testindex totalindex
            %%%%%%
            %%%the smaller category
            minorCat = [];
            t = 1;
            for ii = [tempf1-3 tempf1+3] %feature01
                for i2 = [tempf2-3 tempf2+3]%feature02
                    minorCat(t,:)=[ii i2];
                    t = t+1;
                end
            end
            
            minorCat = minorCat(randperm(length(minorCat)),:);
            totalindex = 1:size(minorCat,1);
            
            index = randsample(size(minorCat,1),minorNum);
            trainIndex = index(randsample(minorNum,minorNum/2));
            testIndex = index(ismember(index,trainIndex)==0);
            tempminorTrain = minorCat(trainIndex,:);
            tempminorTest = minorCat(testIndex,:);
            
            if uniqCombo(ic,2)>uniqCombo(ic,3)%A is the major category
                paramATrain = [paramATrain; tempTrain];
                paramATest = [paramATest; tempTest];
                
                paramBTrain = [paramBTrain; tempminorTrain];
                paramBTest = [paramBTest; tempminorTest];
            else % B is the major category
                
                paramATrain = [paramATrain; tempminorTrain];
                paramATest = [paramATest; tempminorTest];
                
                paramBTrain = [paramBTrain; tempTrain];
                paramBTest = [paramBTest; tempTest];
            end
            
        end
    end
    
    %% Combine with object feature
    %%feature03
    Atemp3 = ff3(1).orig;
    Atemp3 = Atemp3(randperm(length(Atemp3)))';
    candidate(c).paramA = [paramATrain Atemp3];%F3(randperm(size(temp2,1)));
    
    Btemp3 = ff3(2).orig;
    Btemp3 = Btemp3(randperm(length(Btemp3)))';
    candidate(c).paramB = [paramBTrain Btemp3];
    
    candidate(c).param = [candidate(c).paramA;candidate(c).paramB];
    
    %%%%
    Catlabels = zeros(size(candidate(c).param,1),1);
    Catlabels(1:length(Atemp3))=1;
    
    candidate(c).paramlabels = [candidate(c).param Catlabels eye(size(Catlabels,1))];
    
    
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
    
    for ii = 10:10:100
        h=figure(1);scatter3(candidate(c).param(:,1),candidate(c).param(:,2),candidate(c).param(:,3),120,C,'fill')
        view(ii,30)
        title(['candidate ' num2str(c) ' optimal ' num2str(candidate(c).optima_per) ' stimuli dimension train ',num2str(ii,'%03d')])
        img_name = ['candidate' num2str(c) 'optimal' num2str(candidate(c).optima_per) 'stimuli_dimension_train',num2str(ii,'%03d'),'.jpg'];
        %saveas(h,img_name)
        pause
    end
    
    
    %%
    Newtemp3A = ff3(3).orig;
    Newtemp3B = ff3(4).orig;
    
    NewparamA = [paramA Newtemp3A(randperm(length(Newtemp3A)))'];
    NewparamB = [paramB Newtemp3B(randperm(length(Newtemp3B)))'];
    
    
    candidate(c).NewparamA = NewparamA;
    candidate(c).NewparamB = NewparamB;
    candidate(c).Newparam = [NewparamA;NewparamB];
    
    
    NewCatlabels = zeros(size(candidate(c).Newparam,1),1);
    NewCatlabels(1:length(NewparamA))=1;
    
    candidate(c).Newparamlabels = [candidate(c).Newparam NewCatlabels eye(size(NewCatlabels,1))];
    
    
    %%%%%plot
    colorNew1 = [0.6 0.2 0.3];%color for category A (red)
    colorNew2 = [0.3 0.2 0.6]; % color for category B (blue)
    %C = [];
    for ii = 1:size(NewparamA,1)
        C = [C; colorNew1];
    end
    
    for ii = 1:size(NewparamB,1)
        C = [C; colorNew2];
    end
    
    %%% labels for train and test stimuli sets
    candidate(c).allparam = [candidate(c).param ones(size(candidate(c).param,1),1); candidate(c).Newparam zeros(size(candidate(c).Newparam,1),1)];
    
    %%%Plot
    for ii = 10:10:100
        h=figure(2);scatter3(candidate(c).allparam(:,1),candidate(c).allparam(:,2),candidate(c).allparam(:,3),120,C,'fill')
        view(ii,30)
        img_name = ['candidate ' num2str(c) ' optimal ' num2str(candidate(c).optima_per) ' stimuli_dimension_train_test_',num2str(ii,'%03d'),'.jpg'];
        saveas(h,img_name)
        %pause
    end%
    
    
    %%%Novel stimuli for memory tests
    noveltemp3 = [ff3(5).orig ff3(6).orig];%all object specific feature
    F1F2Novel = [paramA; paramB];
    NovelMemoryparam = [F1F2Novel noveltemp3(randperm(length(noveltemp3)))'];
    candidate(c).NovelMemoryparam = NovelMemoryparam;
    
    candidate(c).train_test_memory_param =  [candidate(c).param ones(size(candidate(c).param,1),1); ...
        candidate(c).Newparam zeros(size(candidate(c).Newparam,1),1);...
        candidate(c).NovelMemoryparam ones(size(candidate(c).NovelMemoryparam,1),1)*-1];
    
    colorNovelobject = [0.4,0.9,0.4];%color for novel object
    allC = C;
    for ii = 1:size(NovelMemoryparam,1)
        allC = [allC;colorNovelobject];
    end
    
    %%%plot
    for ii = 10:10:100
        h3=figure(3);scatter3(candidate(c).train_test_memory_param(:,1),candidate(c).train_test_memory_param(:,2),candidate(c).train_test_memory_param(:,3),100,allC,'fill')
        view(ii,30)
        img_name_novel = ['candidate ' num2str(c) ' optimal ' num2str(candidate(c).optima_per) ' stimuli_dimension_train_test_memory',num2str(ii,'%03d'),'.jpg'];
        saveas(h3,img_name_novel)
        %pause
    end%
    
    
    %%
    fname_train = ['candidate',num2str(c),'_optimal',num2str(round(candidate(c).optima_per,2)*100),'_stimuli_param_uniqueF3_train.csv'];
    %     save
    csvwrite(fname_train,candidate(c).paramlabels)
    
    fname_test = ['candidate',num2str(c),'_optimal',num2str(round(candidate(c).optima_per,2)*100),'_stimuli_param_uniqueF3_test.csv'];
    %     save
    csvwrite(fname_test,candidate(c).Newparamlabels)
    cd ../
end

save('uniqueF3_F1F2_3levels_candidates','candidate')


