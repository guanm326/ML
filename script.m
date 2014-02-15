load('A1.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 2: KNN Tester
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Part 1:
%k = 1
[C1,C2] = classifyKnn( HamTrain,SpamTrain, HamTest,SpamTest,1 );
[ CONF1,error1 ] = summarizeResults(C1,C2)

%k = 3
[C1,C2] = classifyKnn( HamTrain,SpamTrain, HamTest,SpamTest,3 );
[ CONF3,error3 ] = summarizeResults(C1,C2)

%k = 10
[C1,C2] = classifyKnn( HamTrain,SpamTrain, HamTest,SpamTest,10 );
[ CONF10,error10 ] = summarizeResults(C1,C2)

%Part 2:

iter_index = 1:3:size(HamTest,2);
k=1;
%Ham 
C1 = zeros(1,length(iter_index));
for i = 1:size(HamTest,1),
    disp(i); 
	newSample = HamTest(i,1:size(HamTest,2));
    temp = zeros(1,length(iter_index));
    for j = 1:length(iter_index),
        start = iter_index(j);
        finish = iter_index(j)+2;
        
        temp(j) = knnTemp( newSample(1:size(newSample,1),start:finish),HamTrain(1:size(HamTrain,1),start:finish),SpamTrain(1:size(SpamTrain,1),start:finish),k );
        temp(find(temp == 2)) = -1;
    end
    C1 = [ C1;temp ];
end
C1 = C1(2:end,:);

%Spam
C2 = zeros(1,length(iter_index));
for i = 1:size(SpamTest,1),
    disp(i); 
    newSample = SpamTest(i,1:size(SpamTest,2));
    temp = zeros(1,length(iter_index));
    for j = 1:length(iter_index),
        start = iter_index(j);
        finish = iter_index(j)+2;
        
        temp(j) = knnTemp( newSample(1:size(newSample,1),start:finish),HamTrain(1:size(HamTrain,1),start:finish),SpamTrain(1:size(SpamTrain,1),start:finish),k );
        temp(find(temp == 2)) = -1;
    end
    C2 = [ C2;temp ];
    
end
C2 = C2(2:end,:);

%Error Calculation
error = zeros( length(iter_index),1 );
for k=1:length(iter_index),

    [ CONF,error_temp ] = summarizeResults( C1( 1:end,k ),C2( 1:end,k ) );
    
    error(k) = error_temp;
end

%Lowest Error Rate: 23.12% from Feature subset: 88,89,90
%Full Feature Test Error: 14.87%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 3: Linear Classifier Tester
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Part 3b
%Test Error: 0.1377%
[ C1_testMSE,C2_testMSE ] = LinearMSE( HamTrain,SpamTrain,HamTest,SpamTest )
[ CONF_testMSE,error1_testMSE ] = summarizeResults(C1_testMSE,C2_testMSE)

%Training Error: 0.1022%
[ C1_trainMSE,C2_trainMSE ] = LinearMSE( HamTrain,SpamTrain,HamTrain,SpamTrain )
[ CONF_trainMSE,error_trainMSE ] = summarizeResults(C1_trainMSE,C2_trainMSE)

%Part 3c
hamtrain = HamTrain;
hamtest = HamTest;
spamtrain = SpamTrain;
spamtest = SpamTest;
for i = 1:79,
    indexes = transpose([ repmat(i,1,21);i:i+20 ]);
    for j=1:size(indexes,1), 
        hamtrain = [ hamtrain,hamtrain(:,indexes(j,1)) .* hamtrain(:,indexes(j,2)) ];
        hamtest = [ hamtest,hamtest(:,indexes(j,1)) .* hamtest(:,indexes(j,2)) ];
        spamtrain = [ spamtrain,spamtrain(:,indexes(j,1)) .* spamtrain(:,indexes(j,2)) ];
        spamtest = [ spamtest,spamtest(:,indexes(j,1)) .* spamtest(:,indexes(j,2)) ];
    end
end

%Test Error: 0.1930%
[ C1_testMSE,C2_testMSE ] = LinearMSE( hamtrain,spamtrain,hamtest,spamtest )
[ CONF_testMSE,error1_testMSE ] = summarizeResults(C1_testMSE,C2_testMSE)

%Training Error: 0.0301%
[ C1_trainMSE,C2_trainMSE ] = LinearMSE( hamtrain,spamtrain,hamtrain,spamtrain )
[ CONF_trainMSE,error_trainMSE ] = summarizeResults(C1_trainMSE,C2_trainMSE)

%Discuss results, adding polynomial terms create a sort of increase curve
%fit to training data which yields suboptimal out of sample testing


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 4: Perceptron Batch Tester
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w_100 = PerceptronBatch(HamTrain,SpamTrain,100);
[C1_100,C2_100] = LinearClassifier( w_100,HamTest,SpamTest );
[ CONF_LinClass_100,error_LinClass_100 ] = summarizeResults(C1_100,C2_100)
%error = 0.4784

w_1000 = PerceptronBatch(HamTrain,SpamTrain,1000);
[C1_1000,C2_1000] = LinearClassifier( w_1000,HamTest,SpamTest );
[ CONF_LinClass_1000,error_LinClass_1000 ] = summarizeResults(C1_1000,C2_1000)
%error = 0.3709

w_10000 = PerceptronBatch(HamTrain,SpamTrain,10000); 
[C1_10000,C2_10000] = LinearClassifier( w_10000,HamTest,SpamTest );
[ CONF_LinClass_10000,error_LinClass_10000 ] = summarizeResults(C1_10000,C2_10000)
%error = 0.2663

w_100000 = PerceptronBatch(HamTrain,SpamTrain,100000);
[C1_100000,C2_100000] = LinearClassifier( w_100000,HamTest,SpamTest );
[ CONF_LinClass_100000,error_LinClass_100000 ] = summarizeResults(C1_100000,C2_100000)
%error = 0.1327

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 5: Adaboost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ features,thresholds,polarities,alphas ] = boost(HamTrain,SpamTrain,2);
CONF = ApplyBoost( features,thresholds,polarities,alphas,HamTest,SpamTest );

%Test Error: 20.15%
%Confusion Matrix:  38   427
                   %110   420


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 6: Competition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Part 1 (insert you own Data)
[ C1_custom,C2_custom ] = BestClassifier(Test1,Test2);
[ CONF_custom,error_custom ] = summarizeResults(C1_custom,C2_custom)

%Part 2
[ C1_customNew,C2_customNew ] = BestClassifier(hamNew,spamNew);
[ CONF_customNew,error_customNew ] = summarizeResults(C1_customNew,C2_customNew)

%New Data Error: 0.40%
%Confusion MAtrix:   77    42
                    %58    67

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 7: Bonus Question
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ C1,C2 ] = ExtraCreditClassifier( Test1,Test2 )




