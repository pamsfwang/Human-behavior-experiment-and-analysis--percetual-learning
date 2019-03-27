%specify levels for each feature
%three features in total
clear all
total = [2,4,5];%%real total: 2,4(catA),4(catB),5(catA),5(catB)
realtotal = [total,total(2),total(3)];
F3Set = 5;
F1_level = [1,2,3,4,5];
CatNum = 2;
newname = ['uniqueF2_F1_3levels_',num2str(total(1)),num2str(total(2)),num2str(total(3)),'candidate'];

F1_level_num = length(total);
F3 = 1:sum(realtotal)*3.5;
for ii = 1:F3Set
    ff3(ii).t = F3(ii:F3Set:F3(end));
    ff3(ii).t(1) = ff3(ii).t(1:F3Set:end);
    ff3(ii).t2 = ff3(ii).t(2:F3Set:end);
    ff3(ii).t3 = ff3(ii).t(3:F3Set:end);
    ff3(ii).t4 = ff3(ii).t(4:F3Set:end);
end

ff3(1).t(ii:F3Set:end)=ff3(2).t1;
ff3(2).t(ii:F3Set:end)=ff3(3).t1;
ff3(3).t(ii:F3Set:end)=ff3(4).t1;
ff3(4).t(ii:F3Set:end)=ff3(5).t1;
ff3(5).t(ii:F3Set:end)=ff3(1).t1;


ff3(1).t(2:F3Set:end)=ff3(3).t2;
ff3(2).t(2:F3Set:end)=ff3(4).t2;
ff3(3).t(2:F3Set:end)=ff3(5).t2;
ff3(4).t(2:F3Set:end)=ff3(1).t2;
ff3(5).t(2:F3Set:end)=ff3(2).t2;

ff3(1).t(3:F3Set:end)=ff3(4).t3;
ff3(2).t(3:F3Set:end)=ff3(5).t3;
ff3(3).t(3:F3Set:end)=ff3(1).t3;
ff3(4).t(3:F3Set:end)=ff3(2).t3;
ff3(5).t(3:F3Set:end)=ff3(3).t3;

ff3(1).t(4:F3Set:end)=ff3(5).t4;
ff3(2).t(4:F3Set:end)=ff3(1).t4;
ff3(3).t(4:F3Set:end)=ff3(2).t4;
ff3(4).t(4:F3Set:end)=ff3(3).t4;
ff3(5).t(4:F3Set:end)=ff3(4).t4;
    
%separate total numbers for each level
%all possible ways to sum up to each total number with constraints that the
%number of numbers in each possible way == the number of levels
for currLevel = 1:length(total)
    f = 1;
    partitions_mtr = partitions(total(currLevel));%col: frequence row: number
    for irow = 1:size(partitions_mtr,1)
        row = partitions_mtr(irow,:);
        for ii = 1:size(row,2)
            if row(ii)>0
                com(ii).row = repmat(ii,1,row(ii));
            end
        end
        
        if length([com(:).row])==CatNum
            partition_results(currLevel).mtr(f,:) = [com(:).row];
            f=f+1;
        end
        clear com row
        
    end
end


%generate all possible mtrs
index = 1;
for l1 = 1:size(partition_results(1).mtr,1)
    first = partition_results(1).mtr(l1,:);
    
    for l2 = 1:size(partition_results(2).mtr,1)
        second = partition_results(2).mtr(l2,:);
        
        for l3 = 1:size(partition_results(3).mtr,1)
            third = partition_results(3).mtr(l3,:);
            final(index).mtr = [first;second;third;fliplr(second);fliplr(third)];
            index = index+1;
        end
    end
end
% index = 1;
% for l1 = 1:size(partition_results(1).mtr,1)
%     first = partition_results(1).mtr(l1,:);
%
%     for l2 = 1:size(partition_results(2).mtr,1)
%         second = partition_results(2).mtr(l2,:);
%
%         for l3 = 1:size(partition_results(3).mtr,1)
%             third = partition_results(3).mtr(l3,:);
%
%             for l4 = 1:size(partition_results(4).mtr,1)
%                 forth = partition_results(4).mtr(l4,:);
%
%                 final(index).mtr = [first;second;third;forth];
%             index = index+1;
%             end
%         end
%     end
% end

% index = 1;
% for l1 = 1:size(partition_results(1).mtr,1)
%     first = partition_results(1).mtr(l1,:);
%
%     for l2 = 1:size(partition_results(2).mtr,1)
%         second = partition_results(2).mtr(l2,:);
%
%         for l3 = 1:size(partition_results(3).mtr,1)
%             third = partition_results(3).mtr(l3,:);
%
%             for l4 = 1:size(partition_results(4).mtr,1)
%                 forth = partition_results(4).mtr(l4,:);
%
%                 for l5 = 1:size(partition_results(5).mtr,1)
%                     fifth = partition_results(5).mtr(l5,:);
%
%                 final(index).mtr = [first;second;third;forth;fifth];
%             index = index+1;
%                 end
%             end
%         end
%     end
% end

%calculate best performance
c = 1;
for ifinal = 1:length(final)
    final(ifinal).sumrow = sum(final(ifinal).mtr);
    final(ifinal).sumcol = sum(final(ifinal).mtr,2);
    
    %temp = flipud(fliplr(final(ifinal).mtr));%mtr for the other category
    totalnum = sum(final(ifinal).mtr,2);
    
    cat1prob = final(ifinal).mtr(:,1)./totalnum;
    cat2prob = final(ifinal).mtr(:,2)./totalnum;
    
    for irow = 1:size(cat1prob,1)
        for icol = 1:size(cat1prob,2)
            larger_prob(irow,icol) = max(cat1prob(irow,icol),cat2prob(irow,icol));
            larger_prob(irow,icol) = larger_prob(irow,icol)*totalnum(irow,icol);
        end
    end
    totalprob = sum(sum(larger_prob));
    final(ifinal).optimal = totalprob/sum(sum(totalnum));
    
    if isequal(final(ifinal).sumcol,realtotal')
        candidate(c).mtrCatA = final(ifinal).mtr(:,1);
        candidate(c).mtrCatB = final(ifinal).mtr(:,2);
        candidate(c).optima_per = final(ifinal).optimal;
        c = c+1;
    end
    clear temp
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generate parameter list
for c = 1:length(candidate)
    newdir = [newname,num2str(c,'%02d')];
    if ~exist(newdir)
        mkdir(newdir)
        cd(newdir)
    else
        cd(newdir)
    end
    
    paramA = [];
    paramB = [];
    for irow = 1:size(candidate(c).mtrCatA,1)
        frequencyA = candidate(c).mtrCatA(irow);
        frequencyB = candidate(c).mtrCatB(irow);
        tempF1 = F1_level(irow);
        tempA = repmat(tempF1,frequencyA,1);
        tempB = repmat(tempF1,frequencyB,1);
        paramA = [paramA; tempA];
        paramB = [paramB; tempB];
        
        clear tempA tempB
    end
    %candidate(c).paramA = paramA;
    %candidate(c).paramB = paramB;
    %%feature03
    Atemp3 = ff3(1).t;%datasample(F3,size(paramA,1),'Replace',false)';
    Btemp3 = ff3(2).t;
    
    Atemp3 = Atemp3(randperm(length(Atemp3)))';
    candidate(c).paramA = [paramA Atemp3];%F3(randperm(size(temp2,1)));
    
    Btemp3 = Btemp3(randperm(length(Btemp3)))';
    candidate(c).paramB = [paramB Btemp3];
    
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
    
    
    h=figure(1);scatter(candidate(c).param(:,1),candidate(c).param(:,2),120,C,'fill')
    title(['candidate ' num2str(c) ' optimal ' num2str(candidate(c).optima_per) ' stimuli dimension train '])
    img_name = ['candidate' num2str(c) 'optimal' num2str(candidate(c).optima_per) 'stimuli_dimension_train.jpg'];
    saveas(h,img_name)
    
    %% Testing stimuli
    Newtemp3A = ff3(3).t;
    Newtemp3B = ff3(4).t;
    
    NewparamA = [candidate(c).paramA(:,1) Newtemp3A(randperm(length(Newtemp3A)))'];
    NewparamB = [candidate(c).paramB(:,1) Newtemp3B(randperm(length(Newtemp3B)))'];
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
    h=figure(2);scatter(candidate(c).allparam(:,1),candidate(c).allparam(:,2),120,C,'fill')
    img_name = ['candidate ' num2str(c) ' optimal ' num2str(candidate(c).optima_per) ' stimuli_dimension_train_test_.jpg'];
    saveas(h,img_name)
    
    %
    fname_train = ['candidate',num2str(c),'_optimal',num2str(round(candidate(c).optima_per,2)*100),'_stimuli_param_uniqueF3_train.csv'];
    %     save
    csvwrite(fname_train,candidate(c).paramlabels)
    
    fname_test = ['candidate',num2str(c),'_optimal',num2str(round(candidate(c).optima_per,2)*100),'_stimuli_param_uniqueF3_test.csv'];
    %     save
    csvwrite(fname_test,candidate(c).Newparamlabels)
end

save('uniqueF3_F1F2_3levels_candidates','candidate')
cd ../


