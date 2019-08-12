%specify training features 
F1 = [1,2,3,4];
F2 = [1,2,3,4];
F3 = [0,2,5,7];

%template
temp = zeros(12,3);
temp(1:4,1)=F1';
temp(5:8,2)=F2';
temp(9:12,3)=F3';

csvwrite('stimuli_param_temp_unique.csv',temp)