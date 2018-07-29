%Jiefeng's stimuli set
%file name
fname = 'wp_stimuli_param.csv';
fname_train = 'wp_stimuli_param_train.csv';
fname_test = 'wp_stimuli_param_test.csv';
%Patterns
f(1).pattern = [0 0 0 1];
f(2).pattern = [0 0 1 0];
f(3).pattern = [0 0 1 1];
f(4).pattern = [0 1 0 0];
f(5).pattern = [0 1 0 1];
f(6).pattern = [0 1 1 0];
f(7).pattern = [0 1 1 1];
f(8).pattern = [1 0 0 0];
f(9).pattern = [1 0 0 1];
f(10).pattern = [1 0 1 0];
f(11).pattern = [1 0 1 1];
f(12).pattern = [1 1 0 0];
f(13).pattern = [1 1 0 1];
f(14).pattern = [1 1 1 0];


%%categoryA
f(1).Afreq=17;
f(2).Afreq=7;
f(3).Afreq=24;
f(4).Afreq=2;
f(5).Afreq=10;
f(6).Afreq=3;
f(7).Afreq=17;
f(8).Afreq=2;
f(9).Afreq=3;
f(10).Afreq=2;
f(11).Afreq=5;
f(12).Afreq=2;
f(13).Afreq=4;
f(14).Afreq=2;

temp = [];
for ii = 1:length(f)%feature identity
    for ifreq = 1:f(ii).Afreq %first feature frequency
       temp = [temp; f(ii).pattern];
    end
end

CatA_train_feature_set = [temp ones(length(temp),1)];%3 features + category label

%%category B
f(1).Bfreq=2;
f(2).Bfreq=2;
f(3).Bfreq=2;
f(4).Bfreq=7;
f(5).Bfreq=2;
f(6).Bfreq=3;
f(7).Bfreq=2;
f(8).Bfreq=17;
f(9).Bfreq=3;
f(10).Bfreq=10;
f(11).Bfreq=4;
f(12).Bfreq=24;
f(13).Bfreq=5;
f(14).Bfreq=17;

temp = [];
for ii = 1:length(f)%feature identity
    for ifreq = 1:f(ii).Bfreq %first feature frequency
       temp = [temp; f(ii).pattern];
    end
end

CatB_train_feature_set = [temp zeros(length(temp),1)];%3 features + category label

%%combine 2 sets
Cat_train_set = [CatA_train_feature_set; CatB_train_feature_set];
%%plot
% c = [0.9 0.4 0.4];%color for category A (red)
% c2 = [0.4 0.4 0.9]; % color for category B (blue)
% C = [];
%     for ii = 1:size(CatA_train_feature_set,1)
%         C = [C; c];
%     end
% 
%     for ii = 1:size(CatB_train_feature_set,1)
%         C = [C; c2];
%     end
%     
% for ii = 10:10:100
% h=figure(1);scatter3(Cat_train_set(:,2)*2,Cat_train_set(:,3)*3,Cat_train_set(:,4)*4,120,C,'fill')
% view(ii,30)
% img_name = ['wp_stimuli_dimension_train_',num2str(ii,'%03d'),'.jpg'];
% %saveas(h,img_name)
% pause
% end

%%save training stimuli parameters
csvwrite(fname_train,Cat_train_set)
%% New stimuli
%Each level in F3 appears 4 times 
%% save stimuli parameters
%csvwrite(fname,Cat)
%parameters for three features, category label, and train/test label

