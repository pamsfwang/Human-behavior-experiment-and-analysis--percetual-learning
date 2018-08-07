%generate sequence of presentation
%calibration: feature01:0,3,6; feature02:0,3,6; feature03:0,3,6
%

total = combntns(1:9,2);
index = randsample(size(total,1),size(total,1)/2);
temp = total(index,1);
temp2 = total(index,2);
total(index,1)=temp2;
total(index,2)=temp;
newtotal = total(randindex,:);


order = [];
for ii = 1:size(newtotal,1)
   order = [order newtotal(ii,:)]; 
end