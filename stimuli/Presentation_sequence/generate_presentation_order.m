%generate sequence of presentation
%calibration: feature01:0,3,6; feature02:0,3,6; feature03:0,3,6
%

total = combntns(1:9,2);
index = randsample(size(total,1),size(total,1)/2);
temp = total(index,1);
temp2 = total(index,2);
total(index,1)=temp2;
total(index,2)=temp;

randomIndex = randperm(size(total,1));
newtotal = total(randomIndex,:);


featureLabel_pair = zeros(size(newtotal,1),2);
for ir = 1:size(newtotal,1)
    for ic = 1:2
        switch newtotal(ir,ic)
            case {1,2,3}
                featureLabel_pair(ir,ic)=1;
            case {4,5,6}
                featureLabel_pair(ir,ic)=2;
            case {7,8,9}
                featureLabel_pair(ir,ic)=3;
        end
        
    end
end

test = zeros(size(newtotal,1),1);
for ir = 1:size(newtotal,1)
    ic = 1;
    if ir+1 <size(newtotal,1)
    if featureLabel_pair(ir,ic)==featureLabel_pair(ir+1,ic)        
        test(ir)=test(ir)+1;
    end
    end
end


for ii = 1:10000
[newtotal,test1,test2]=presentation_sequence();
ord(ii).s = newtotal;
c1(ii)=sum(test1);
c2(ii)=sum(test2);
end


Index_candidate = find(c ==min(c));
for ic = 1:length(Index_candidate)
can(ic).s=ord(Index_candidate(ic)).s;
end





order = [];
for ii = 1:size(newtotal,1)
   order = [order newtotal(ii,:)]; 
end




%%%
featureLabel = zeros(1,length(order));
featureLabel(1,order==1)=1;
featureLabel(1,order==2)=1;
featureLabel(1,order==3)=1;

featureLabel(1,order==4)=2;
featureLabel(1,order==5)=2;
featureLabel(1,order==6)=2;

featureLabel(1,order==7)=3;
featureLabel(1,order==8)=3;
featureLabel(1,order==9)=3;


if sum(featureLabel==1)~=72/3
    error('Number of feature 1 is not correct\n')
elseif sum(featureLabel==2)~=72/3
    error('Number of feature 2 is not correct\n')
elseif sum(featureLabel==3)~=72/3
    error('Number of feature 3 is not correct\n')
end


%%

f1 = [1 2 3]
f2 = [4 5 6]
f3 = [7 8 9]

temp1= [f1';f1';f2'];
temp2=[f2';f3';f3'];

sequence = [temp1 temp2];

t1 = sequence(1:2:9,1);
t2 = sequence(1:2:9,2);


sequence_flip = sequence;
sequence_flip(1:2:9,1)=t2;
sequence_flip(1:2:9,2)=t1;




randomIndex = randperm(length(sequence_flip));
sequence_flip = sequence_flip(randomIndex,:);

%%%check feature
for ii = 1:2

check(ii).feature = zeros(length(sequence_flip),1);
check(ii).feature(sequence_flip(:,ii)==1)=1;
check(ii).feature(sequence_flip(:,ii)==2)=1;
check(ii).feature(sequence_flip(:,ii)==3)=1;

check(ii).feature(sequence_flip(:,ii)==4)=2;
check(ii).feature(sequence_flip(:,ii)==5)=2;
check(ii).feature(sequence_flip(:,ii)==6)=2;

check(ii).feature(sequence_flip(:,ii)==7)=3;
check(ii).feature(sequence_flip(:,ii)==8)=3;
check(ii).feature(sequence_flip(:,ii)==9)=3;
end


for iii = 1:length(check(2).feature)-1
    if check(2).feature(iii)==check(2).feature(iii+1)
        
        
        check(2).feature(iii)
        check(2).feature(iii+1)
        
        
    else
        
    end
    
    
end

