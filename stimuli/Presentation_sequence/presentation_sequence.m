function [newtotal, test1,test2]=presentation_sequence()

total = combntns(1:9,2);
total
index = (datasample([1,2],1):2:size(total,1));
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

test1 = zeros(size(newtotal,1),1);
test2 = test1;
for ir = 1:size(newtotal,1)
    ic = 1;
    if ir+1 <size(newtotal,1)
        if featureLabel_pair(ir,ic)==featureLabel_pair(ir+1,ic)
            test1(ir)=test1(ir)+1;
        end
    end
    
    if ir+1 <size(newtotal,1)
        if featureLabel_pair(ir,2)==featureLabel_pair(ir+1,1)
            test2(ir)=test2(ir)+1;
        end
    end
    
end
end