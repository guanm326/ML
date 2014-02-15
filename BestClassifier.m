function [ C1,C2 ] = BestClassifier( Test1,Test2 )

    load('myData.mat') %load custom data
    HamTrainData = [ HamTrain;HamTest ];
    SpamTrainData = [ SpamTrain;SpamTest ];
    [C1,C2] = LinearMSE( HamTrainData,SpamTrainData,Test1,Test2 );
end






