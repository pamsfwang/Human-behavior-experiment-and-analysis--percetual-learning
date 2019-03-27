%Simulation of same/diff calibration task
%If we would like to have true accuracy at 75%, what are the minimum trial number & subject number?
%randomly sample from binomial distribution
%Shao-Fang Wang 2018
clear all
clc

trialNum = 20;
exp_accuracy = 0.75;
subNum = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100];
zvalue =1.960; %confidence interval 95%
%%
time = 1000;

for iter = 1:length(subNum)
    tempSubNum = subNum(iter);
    fprintf('Working on subnum: %d\n',tempSubNum)
    for it = 1:time
        for is = 1:tempSubNum
            temp = binornd(trialNum,exp_accuracy);
            %a binomial random variable is the number of successes in a
            %binomial experiment
            %binomial probability is the probability that a binomial
            %experiment has a particular number of successes
            %enerates random numbers from the binomial distribution with parameters specified by the number of trials, N, and probability of success for each trial, P
            sim_accuracy(is)=temp/trialNum;
        end
        medianX(it) = median(sim_accuracy);
        meanX(it) = mean(sim_accuracy);
        s(it) = std(sim_accuracy);
        upperconf(it) = meanX(it)+zvalue*(s(it)/tempSubNum);
        lowerconf(it)= meanX(it)-zvalue*(s(it)/tempSubNum);
        clear sim_accuracy
    end
    conf_inter_time(iter,3)=mean(upperconf);
    conf_inter_time(iter,2)=mean(lowerconf);
    conf_inter_time(iter,1)=tempSubNum;
    simmedian(iter,:) = medianX;
    simmean(iter,:) = meanX;
    simsd(iter,:) = s;
    
    clear tempSubNum meanX s medianX
end

%PLOT
figure(1);
boxplot(conf_inter_time(:,2:3)')
refline([0 exp_accuracy]);
%xticks(subNum)
xticklabels({'5','10','15','20','25','30','35','40','45','50','55','60','65','70','75','80','85','90','95','100'})

figure(2);
boxplot(simmean')
refline([0 exp_accuracy]);
%xticks(subNum)
xticklabels({'5','10','15','20','25','30','35','40','45','50','55','60','65','70','75','80','85','90','95','100'})


