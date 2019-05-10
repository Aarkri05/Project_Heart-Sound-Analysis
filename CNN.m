
categories ={'AS', 'MR','MS', 'AS', 'MR','MS'};
trainData = imageDatastore(fullfile('E:\classify', categories(1:3)),  'IncludeSubfolders',true, 'LabelSource', 'foldernames');
testData = imageDatastore(fullfile('E:\classify\test', categories(4:6)),  'IncludeSubfolders',true, 'LabelSource', 'foldernames');
tb1 = countEachLabel(trainData);
%minSetCount = min(tb1{:,2});
tb2 = countEachLabel(testData);
%CNN
layers = [
    imageInputLayer([500 700 3])  
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer    
    maxPooling2dLayer(2,'Stride',2) 
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer 
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer];
opts = trainingOptions('sgdm',...
       'InitialLearnRate',0.001,...
       'LearnRateSchedule', 'piecewise',...
       'LearnRateDropFactor',0.1,...
       'LearnRateDropPeriod',8,...
       'L2Regularization',0.004,...
       'MaxEpochs',12,...
       'MiniBatchSize',5,...
       'Verbose',true,...
       'Plots','training-progress');

[trainedNet,traininfo]= trainNetwork(trainData,layers,opts);

YPred=classify(trainedNet,testData,'ExecutionEnvironment','cpu');
YTest = testData.Labels;
accuracy = sum(YPred == YTest)/numel(YTest);
plotconfusion(YTest,YPred);
