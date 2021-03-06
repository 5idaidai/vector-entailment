% Want to distribute this code? Have other questions? -> sbowman@stanford.edu
function [softmaxGradient, softmaxDelta] = ...
    ComputeSoftmaxGradient (hyperParams, classifierParameters, ...
                            relationProbs, trueRelation, tensorOutput, relationRange)
% Compute the gradient for the softmax layer parameters, and the deltas to
% pass down.

% Note: Relation range specifies which relations are under consideration. If 
% relationRange covers the whole space of relations suported by the parameter
% matrix (i.e., relationRange = 1:size(classifierParameters, 1)), then this computes
% the gradient for a single normal softmax classifier. If this is not the case, then
% columns of the matrix that aren't included in relationRange are ignored, and assumed
% to not contribute to the output distribution.

% This configuration is used to allow for one trained network to be trained using examples
% which were labeled from label sets that don't correspond exactly to the label set used
% on the test data.

softmaxGradient = zeros(size(classifierParameters, 1), ...
    hyperParams.penultDim + 1);

partialSoftmaxGradient = zeros(length(relationRange), ...
    hyperParams.penultDim + 1);

% Compute node softmax error
assert(length(relationProbs) == length(relationRange), ...
	'Need one probability per possible class for this dataset.')
assert(length(trueRelation) == length(hyperParams.numRelations), ...
	'The relation label needs to be a vector with the correct relation in the position corresponding to the appropriate relatiotn set, and zeroes elsewhere.')
assert(sum(trueRelation > 0) == 1, ...
	'The relation label needs to be a vector with the correct relation in the position corresponding to the appropriate relatiotn set, and zeroes elsewhere.')

targetRelationProbs = zeros(length(relationProbs), 1);
targetRelationProbs(trueRelation(find(trueRelation > 0))) = 1;

softmaxDeltaFirstHalf = classifierParameters(relationRange, :)' * ...
                        (relationProbs - targetRelationProbs);

% Compute the nonlinearity and append the intercept
softmaxDeltaSecondHalf = hyperParams.classNLDeriv([1; tensorOutput]);
softmaxDelta = (softmaxDeltaFirstHalf .* softmaxDeltaSecondHalf);

for parametersIndex = relationRange
	relationNumber = parametersIndex - relationRange(1) + 1;
    softmaxGradient(parametersIndex, :) = -([1; tensorOutput] .* ...
        (targetRelationProbs(relationNumber) - relationProbs(relationNumber)))';
end

softmaxDelta = softmaxDelta(2:hyperParams.penultDim+1);

end