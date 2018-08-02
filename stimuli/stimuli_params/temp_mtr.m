F1_level_num = 3;
F2_level_num = 3;


mtr = ones(F2_level_num,F1_level_num);

start = F1_level_num;
step = [1,2,3];

for is = step
total = [start start+step(is) start+step(is)*2]
end



 if sum(mtr(1,:))= total(1)
     if sum(mtr(:,1))==total(1)
         
     end
 end
 
 
 %F1
 for currLevel = 2:3
 if sum(mtr(:,currLevel)) ~= total(currLevel)
     
     temp = partitions(total(currLevel));
     partitions_mtr = [];
     for is = 1:size(temp,2)
         partitions_mtr=[partitions_mtr temp(:,is)*is];
     end
     
     t = [];
     for in = 1:size(partitions_mtr,1)
         if sum(partitions_mtr(in,:)>0) == F1_level_num
             t = [t; partitions_mtr(in,find(partitions_mtr(in,:)>0))];
         end
     end
     partition_results(currLevel).mtr = unique(t, 'rows');
 end
 end
     
 
 
 %%
 in = 1;
 for irow = 1:size(temp,1)
     c = temp(irow,:);
     for ii = 1:size(c,2)
         if c(ii)>0
             t2(ii).k = repmat(ii,1,c(ii));
         end
     end
     
     t3(irow).k = [t2(:).k];
     clear t2
 end
  
 
 
 %%
first = ones(1,3);
index = 1;
 for ii = 1:size(partition_results(2).mtr,1)
     second = partition_results(2).mtr(ii,:);
     
     for i3 = 1:size(partition_results(3).mtr,1)
         third = partition_results(3).mtr(i3,:);

           ttt(index).mtr = [first;second;third];
           
           index = index+1;
     end
 end
 
 
 
     
     for t = 1:size(final,1)
         m(t).mtr = mtr;
         for il = 1:F1_level_num
             m(t).mtr(il,currLevel )=final(t,il);
         end
         
         if sum(m(t).mtr(:,currLevel)) == total(currLevel)
             fprintf('yes')
         end
         
     end


 
 
 %check
 
 
 
 
        
        
     
     
     

 
