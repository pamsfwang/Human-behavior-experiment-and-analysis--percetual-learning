clear all
clc
%specify levels for each feature
%three features in total
newfName = 'uniqueF3_F1F2_3levels_Cattest_candidate';
F1_level = [10 15 20];
F2_level = [20 15 10];
F1_level_num = length(F1_level);
F2_level_num = length(F2_level);

mtr = ones(F2_level_num,F1_level_num);
start = F1_level_num;
step = [1,2,3];

total = [3,6,9];
%total = [3,5,7];%sum for each level
F3Set = 4;%2 train cat; 2 test cat; 2 memory test
%%%
F3 = 1:(sum(total)*F3Set);
for ii = 1:F3Set
    ff3(ii).orig = F3(ii:F3Set:end);
    ff3(ii).t(1).x = ff3(ii).orig(1:F3Set:end);
    ff3(ii).t(2).x = ff3(ii).orig(2:F3Set:end);
    ff3(ii).t(3).x = ff3(ii).orig(3:F3Set:end);
    ff3(ii).t(4).x = ff3(ii).orig(4:F3Set:end);
end

sets = [
    4,1,2,3;
    3,4,1,2;
    2,3,4,1];

%sets = sets(randperm(size(sets,1)),:);

for in = 1:size(sets,1)
    index = sets(in,:);
    ff3(1).orig(in:F3Set:end)=ff3(index(1)).t(in).x;
    ff3(2).orig(in:F3Set:end)=ff3(index(2)).t(in).x;
    ff3(3).orig(in:F3Set:end)=ff3(index(3)).t(in).x;
    ff3(4).orig(in:F3Set:end)=ff3(index(4)).t(in).x;
end

for ii = 1:F3Set
    testmtr(:,ii)=ff3(ii).orig';
end
anova1(testmtr)

close all
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
%generate parameter list
for c = 1:length(candidate)
    newdir = [newfName,num2str(c,'%02d')];
    if ~exist(newdir)
        mkdir(newdir)
        cd(newdir)
    else
        cd(newdir)
    end
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
    %candidate(c).paramA = paramA;
    %candidate(c).paramB = paramB;
    %%feature03
    Atemp3 = ff3(3).orig;
    Atemp3 = Atemp3(randperm(length(Atemp3)))';
    candidate(c).paramA = [paramA Atemp3];%F3(randperm(size(temp2,1)));
    
    Btemp3 = ff3(4).orig;
    Btemp3 = Btemp3(randperm(length(Btemp3)))';
    candidate(c).paramB = [paramB Btemp3];
    
    candidate(c).param = [candidate(c).paramA;candidate(c).paramB];
    
    %%%%
    Catlabels = zeros(size(candidate(c).param,1),1);
    Catlabels(1:length(Atemp3))=1;
    
    candidate(c).paramlabels = [candidate(c).param Catlabels eye(size(Catlabels,1))];
    
    clear t1 t2 t3 t12 t22 t32
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
        saveas(h,img_name)
        %pause
    end
    
    
    %% Novel objects for memory test
    Newtemp3A = ff3(1).orig;
    Newtemp3B = ff3(2).orig;
    
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
    
    %%
    fname_train = ['candidate',num2str(c),'_optimal',num2str(round(candidate(c).optima_per,2)*100),'_stimuli_param_uniqueF3_train.csv'];
    %     save
    csvwrite(fname_train,candidate(c).paramlabels)
    
    fname_test = ['candidate',num2str(c),'_optimal',num2str(round(candidate(c).optima_per,2)*100),'_stimuli_param_uniqueF3_test.csv'];
    %     save
    csvwrite(fname_test,candidate(c).Newparamlabels)
    cd ../
end

save(newfName,'candidate')



