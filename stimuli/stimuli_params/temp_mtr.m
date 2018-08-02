
F1_level = [0 3 6];
F2_level = [6 3 0];


F1_level_num = length(F1_level);
F2_level_num = length(F2_level);

mtr = ones(F2_level_num,F1_level_num);
start = F1_level_num;
step = [1,2,3];

total = [3,6,9];

%F1:
for currLevel = 1:3
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


%generate all mtr
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
        end
    end
    totalprob = sum(sum(larger_prob));
    final(ifinal).optimal = totalprob/(size(cat1prob,1)*size(cat1prob,2));
    
    if isequal(final(ifinal).sumrow,total)
        candidate(c).mtrCatA = final(ifinal).mtr;
        candidate(c).mtrCatB = temp;
        candidate(c).optima_per = final(ifinal).optimal;
        c = c+1;
    end
    clear temp
end

%generate parameter list

F3 = 0:0.16:6;
F3 = F3(randperm(length(F3))); %randomise the list

for c = 1:length(candidate)
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
    candidate(c).paramA = paramA;
    candidate(c).paramB = paramB;
    %%feature03
    Atemp3 = datasample(F3,size(paramA,1),'Replace',false)';
    candidate(c).paramA = [paramA Atemp3];%F3(randperm(size(temp2,1)));
    
    lia = ismember(F3,Atemp3);
    F3_B = F3(lia==0);
    Btemp3 = datasample(F3_B,size(paramB,1),'Replace',false)';
    candidate(c).paramB = [paramB Btemp3];
    candidate(c).param = [candidate(c).paramA;candidate(c).paramB];
    
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
        %img_name = ['candidate' num2str(c) 'optimal' num2str(candidate(c).optima_per) 'stimuli_dimension_train',num2str(ii,'%03d','.jpg')];
        %saveas(h,img_name)
        pause
    end
    
    F3 = 0:0.16:6;
    F3 = F3(randperm(length(F3))); %randomise the list
    
    for c = 1:length(candidate)
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
        candidate(c).paramA = paramA;
        candidate(c).paramB = paramB;
        %%feature03
        Atemp3 = datasample(F3,size(paramA,1),'Replace',false)';
        candidate(c).paramA = [paramA Atemp3];%F3(randperm(size(temp2,1)));
        
        lia = ismember(F3,Atemp3);
        F3_B = F3(lia==0);
        Btemp3 = datasample(F3_B,size(paramB,1),'Replace',false)';
        candidate(c).paramB = [paramB Btemp3];
        
        
        candidate(c).param = [candidate(c).paramA;candidate(c).paramB];
        
        
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
            %img_name = ['stimuli_dimension_train_',num2str(ii,'%03d'),'.jpg'];
            %saveas(h,img_name)
            pause
        end
    end
    
    
    fname_train = ['candidate',num2str(c),'_optimal',num2str(round(candidate(1).optima_per,2)*100),'_stimuli_param_uniqueF3_train.csv'];
    save
    csvwrite(fname_test,New_set)
    
end



