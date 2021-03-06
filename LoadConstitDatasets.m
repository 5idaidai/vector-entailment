% Want to distribute this code? Have other questions? -> sbowman@stanford.edu
function [ trainDataset, testDatasetsCell, trainingLengths ] = LoadConstitDatasets (wordMap, relationMap, hyperParams)
% Load and combine all of the training and test data.
% This is slow. And can probably be easily improved if it matters.

% trainFilenames: Load these files as training data.
% testFilenames: Load these files as test data.
% splitFilenames: Split these files into train and test data.

% relationIndices: An optional matrix with three rows, one each for 
% train/test/split, indicating which set of relations the dataset uses.

if hyperParams.fragmentData
    trainDataset = hyperParams.trainFilenames;
else
    trainDataset = [];
end
testDatasets = {};
relationIndex = 1;

trainingLengths = [];

for i = 1:length(hyperParams.trainFilenames)
    Log(hyperParams.statlog, ['Loading training dataset ', hyperParams.trainFilenames{i}]);
    if isfield(hyperParams, 'relationIndices')
        relationIndex = hyperParams.relationIndices(1, i);
    end

    if ~hyperParams.fragmentData
        dataset = LoadConstitData(hyperParams.trainFilenames{i}, wordMap, relationMap, ...
                                  hyperParams, false, relationIndex);
        trainDataset = [trainDataset; dataset];
        trainingLengths = [trainingLengths; length(dataset)];
    else
        LoadConstitData(hyperParams.trainFilenames{i}, wordMap, relationMap, hyperParams, true, relationIndex);
    end
        
end

for i = 1:length(hyperParams.testFilenames)
    if isfield(hyperParams, 'relationIndices')
        relationIndex = hyperParams.relationIndices(2, i);
    else
        relationIndex = 1;
    end

    Log(hyperParams.statlog, ['Loading test dataset ', hyperParams.testFilenames{i}]);
    dataset = LoadConstitData(hyperParams.testFilenames{i}, wordMap, relationMap, hyperParams, false, relationIndex);
    testDatasets = [testDatasets, {dataset}];
end

for i = 1:length(hyperParams.splitFilenames)
    if isfield(hyperParams, 'relationIndices')
        relationIndex = hyperParams.relationIndices(3, i);
    else
        relationIndex = 1;
    end

    Log(hyperParams.statlog, ['Loading split dataset ', hyperParams.splitFilenames{i}]);
    dataset = LoadConstitData(hyperParams.splitFilenames{i}, wordMap, relationMap, hyperParams, false, relationIndex);
    length(dataset)

    lengthOfTestPortion = ceil(length(dataset) * hyperParams.testFraction);
    startOfTestPortion = 1 + (hyperParams.foldNumber - 1) * lengthOfTestPortion;
    endOfTestPortion = min(hyperParams.foldNumber * lengthOfTestPortion, length(dataset));
    % if isfield(hyperParams, 'truncateTest')
    %     endOfTestPortion = min(startOfTestPortion + 100, endOfTestPortion);
    % end
    testPortion = dataset(startOfTestPortion:endOfTestPortion);
    testDatasets = [testDatasets, {testPortion}];
    
    length(testPortion)
    % TODO - make fragment-safe
    if ~(isfield(hyperParams, 'specialAndOrMode') && i > 9)
        firstTrainPortion = dataset(1:(startOfTestPortion - 1));
        secondTrainPortion = dataset(endOfTestPortion + 1:length(dataset));
        trainPortion = [firstTrainPortion; secondTrainPortion];
        trainDataset = [trainDataset; trainPortion];
        trainingLengths = [trainingLengths; length(dataset)];
        length(trainPortion)
    else
        Log(hyperParams.statlog, ['Discarding train portion of split dataset ', hyperParams.splitFilenames{i}]);
    end
    % assert(length(testPortion) == lengthOfTestPortion);
    % assert(length(testPortion) + length(trainPortion) == length(dataset));
end

datasetNames = [hyperParams.testFilenames, hyperParams.splitFilenames];
testDatasetsCell = {datasetNames, testDatasets};
