% Want to distribute this code? Have other questions? -> sbowman@stanford.edu
classdef Tree < handle
    % Represents a single binary branching syntactic tree with three 
    % representations at each node:
    % - The index with which the feature vector can be looked up - if leaf
    % - The text with which the tree can be displayed.
    % - The features at the node.
    
    properties (Hidden)
        daughters = []; % 2 x 1 vector of trees
        text = 'NO_TEXT';
        features = []; % DIM x 1 vector
        mask = []; % Used in dropout
        featuresPreNL = [];
        wordIndex = -1; % -1 => Not a lexical item node.
        transformInnerActivations = []; % Stored activations for the embedding tranform layers.
        type = 0; % 0 - predicate or predicate + neg
                  % 1 - quantifier
                  % 2 - neg
                  % 3 - quantifier phrase           
    end
    
    methods(Static)
        function t = printAllProperties(obj)
            disp(obj.text)
            disp(obj.features)
            disp(obj.featuresPreNL)
            disp(obj.wordIndex)
            disp(obj.transformInnerActivations)
            disp(obj.type)
            disp('(')
            for daughterInd = 1:length(obj.daguhters)
                printAllProperties(obj.daguhters(daughterInd))
            end
            disp(')')
        end

        function t = makeTree(iText, wordMap)
            assert(~isempty(iText), 'Bad tree input text.');
            % tyingMap = GetTyingMap(wordMap); % DEPRECATED
            
            C = textscan(iText, '%s', 'delimiter', ' ');
            C = C{1};
            
            stack = cell(length(C));
            stackTop = 0;
            
            for i = 1:length(C)
                if ~strcmp(C{i}, '(') && ~strcmp(C{i}, ')')
                    % Turn words into leaf nodes
                    stack{stackTop + 1} = Tree.makeLeaf(C{i}, wordMap);
                    stackTop = stackTop + 1;
                elseif strcmp(C{i}, ')')
                    % Merge at the ends of constituents
                    r = stack{stackTop};
                    l = stack{stackTop - 1};
                    stack{stackTop - 1} = Tree.mergeTrees(l, r);
                    stackTop = stackTop - 1;
                end
            end
            
            t = stack{stackTop};
            stackTop = stackTop - 1;
            
            % Merge in any residual words to the left
            while stackTop > 0
                p = stack{stackTop};
                stackTop = stackTop - 1;
                
                t = Tree.mergeTrees(p, t);
            end

            assert((length(t.daughters) > 0 || t.wordIndex ~= -1), 'Bad tree!')
        end
        
        function t = makeLeaf(iText, wordMap)
            t = Tree();
            t.text = lower(iText);
            if wordMap.isKey(t.text)
                t.wordIndex = wordMap(t.text);
            elseif all(ismember(t.text, '0123456789.-'))
                disp(['Collapsing number ' t.text]);
                t.wordIndex = wordMap('*NUM*');               
            else
                nextTry = strtok(t.text,':');
                if wordMap.isKey(nextTry)
                    t.wordIndex = wordMap(nextTry);
                else
                    if rand > 0.99 % Downsample what gets logged.
                        disp(['Failed to map word ' t.text]);
                    end
                    t.wordIndex = wordMap('*UNK*');
                end
            end
            assert(t.wordIndex ~= -1, 'Bad leaf!')
        end
        
        function t = mergeTrees(l, r)
            t = Tree();
            t.text = strcat(l.text, ' ', r.text);
            t.daughters = [l r];
            if l.type == 1
                t.type = 2;
            else
                t.type = l.type;
            end
                
        end
        
    end
    methods
        
        function resp = isLeaf(obj)
            resp = (isempty(obj.daughters));
        end
        
        function ld = getLeftDaughter(obj)
            if (~isempty(obj.daughters))
                ld = obj.daughters(1);
            else
                ld = 0;
            end
        end
        
        function rd = getRightDaughter(obj)
            if (length(obj.daughters) > 1)
                rd = obj.daughters(2);
            else
                rd = 0;
            end
        end
        
        function t = getText(obj)
            if isLeaf(obj)
                t = obj.text;
            else
                t = [obj.getLeftDaughter().getText(), ' ', obj.getRightDaughter().getText()];
            end
        end
        
        function f = getFeatures(obj)
            % Returns the saved features for the tree.
            f = obj.features;
        end
        
        function type = getType(obj)
            type = obj.type;
        end
        
        function i = getWordIndex(obj)
            i = obj.wordIndex;
        end
        
        function updateFeatures(obj, wordFeatures, compMatrices, ...
                                compMatrix, compBias,  embeddingTransformMatrix, embeddingTransformBias, compNL, dropout)
            % Recomputes features using fresh parameters.

            if (~isempty(obj.daughters))
                for daughterIndex = 1:length(obj.daughters)
                    obj.daughters(daughterIndex).updateFeatures(...
                        wordFeatures, compMatrices, compMatrix, compBias, embeddingTransformMatrix, embeddingTransformBias, ...
                        compNL, dropout);
                end
                
                lFeatures = obj.daughters(1).features;
                rFeatures = obj.daughters(2).features;
                
                if size(compBias, 2) <= 1 % if not untied
                    typeInd = 1;
                else
                    'Tying may not be supported...'
                    typeInd = obj.daughters(1).getType();
                end
               
                if length(compMatrices) ~= 0
                    [obj.features, obj.featuresPreNL] = ComputeTensorLayer(...
                        lFeatures, rFeatures, compMatrices(:,:,:,typeInd),...
                        compMatrix(:,:,typeInd), compBias(:,typeInd), compNL);
                elseif length(compMatrix) ~= 0
                    [obj.features, obj.featuresPreNL] = ComputeRNNLayer(lFeatures, rFeatures,...
                        compMatrix(:,:,typeInd), compBias(:,typeInd), compNL);
                else
                    obj.features = ComputeSummingLayer(lFeatures, rFeatures);
                end
            else
                if length(embeddingTransformMatrix) == 0
                    % We have no transform layer, so just use the word features.
                    obj.features = wordFeatures(obj.wordIndex, :)'; 
                else
                    % Run the transfrom layer.
                    obj.transformInnerActivations = embeddingTransformMatrix ...
                                                    * wordFeatures(obj.wordIndex, :)' + ...
                                                    embeddingTransformBias;

                    activations = compNL(obj.transformInnerActivations);

                    [obj.features, obj.mask] = Dropout(activations, dropout);

                end
            end
        end
        
        function [ upwardWordGradients, ...
                   upwardCompositionMatricesGradients, ...
                   upwardCompositionMatrixGradients, ...
                   upwardCompositionBiasGradients, ...
                   upwardEmbeddingTransformMatrixGradients, ...
                   upwardEmbeddingTransformBiasGradients ] = ...
            getGradient(obj, delta, wordFeatures, compMatrices, ...
                        compMatrix, compBias, embeddingTransformMatrix, embeddingTransformBias, ...
                        compNLDeriv, hyperParams)
            % Note: Delta should be a column vector.
            
            DIM = length(delta);
            EMBDIM = size(embeddingTransformMatrix, 2);
            NUMTRANS = size(embeddingTransformMatrix, 3);

            if size(compBias, 2) == 1 % Using tied composition parameters
                NUMCOMP = 1;
            elseif size(compBias, 2) == 0 % Using summing
                NUMCOMP = 0;
            else % Untied RNN
                NUMCOMP = 3; % TODO: Hardcoded for now, here and elsewhere.
            end

            upwardWordGradients = sparse([], [], [], ...
                size(wordFeatures, 1), size(wordFeatures, 2), 10);            
            
            if size(compMatrices, 1) == 0
                upwardCompositionMatricesGradients = zeros(0, 0, 0, NUMCOMP);
            else
                upwardCompositionMatricesGradients = zeros(DIM, DIM, DIM, NUMCOMP);
            end

            upwardCompositionMatrixGradients = zeros(DIM, 2 * DIM, NUMCOMP);
            upwardCompositionBiasGradients = zeros(DIM, NUMCOMP);
            upwardEmbeddingTransformMatrixGradients = zeros(DIM, EMBDIM, NUMTRANS);
            upwardEmbeddingTransformBiasGradients = zeros(DIM, NUMTRANS);

            if (~isempty(obj.daughters))
                if size(compBias, 2) == 1 % Check if using tied composition parameters
                    typeInd = 1;
                else
                    typeInd = obj.daughters(1).getType();
                end
                
                lFeatures = obj.daughters(1).features();
                rFeatures = obj.daughters(2).features();
                
                if length(compMatrices) ~= 0 % RNTN
                    [tempCompositionMatricesGradients, ...
                        tempCompositionMatrixGradients, ...
                        tempCompositionBiasGradients, compDeltaLeft, ...
                        compDeltaRight] = ...
                    ComputeTensorLayerGradients(lFeatures, rFeatures, ...
                          compMatrices(:,:,:,typeInd), ...
                          compMatrix(:,:,typeInd), ...
                          compBias(:,typeInd), delta, ...
                          compNLDeriv, obj.featuresPreNL);

                    upwardCompositionMatricesGradients(:,:,:,typeInd) = ...
                        tempCompositionMatricesGradients;
                    upwardCompositionMatrixGradients(:,:,typeInd) = ...
                        tempCompositionMatrixGradients;
                    upwardCompositionBiasGradients(:,typeInd) = ...
                        tempCompositionBiasGradients;
                elseif length(compMatrix) ~= 0 % RNN
                    [tempCompositionMatrixGradients, ...
                        tempCompositionBiasGradients, compDeltaLeft, ...
                        compDeltaRight] = ...
                    ComputeRNNLayerGradients(lFeatures, rFeatures, ...
                          compMatrix(:,:,typeInd), ...
                          compBias(:,typeInd), delta, ...
                          compNLDeriv, obj.featuresPreNL);

                    upwardCompositionMatrixGradients(:,:,typeInd) = ...
                        tempCompositionMatrixGradients;
                    upwardCompositionBiasGradients(:,typeInd) = ...
                        tempCompositionBiasGradients;
                else % Summing network
                    [compDeltaLeft, compDeltaRight] = ...
                      ComputeSummingLayerGradients(delta);                 
                end
                  
                % Take gradients from the left child
                [ incomingWordGradients, ...
                  incomingCompositionMatricesGradients, ...
                  incomingCompositionMatrixGradients, ...
                  incomingCompositionBiasGradients, ...
                  incomingEmbeddingTransformMatrixGradients, ...
                  incomingEmbeddingTransformBiasGradients ] = ...
                  obj.getLeftDaughter.getGradient( ...
                                compDeltaLeft, wordFeatures, ...
                                compMatrices, compMatrix, compBias,  embeddingTransformMatrix, embeddingTransformBias, ...
                                compNLDeriv, hyperParams);
                if hyperParams.trainWords
                    upwardWordGradients = upwardWordGradients + ...
                                          incomingWordGradients;
                end
                upwardCompositionMatricesGradients = ...
                    upwardCompositionMatricesGradients + ...
                    incomingCompositionMatricesGradients;
                upwardCompositionMatrixGradients = ...
                    upwardCompositionMatrixGradients + ...
                    incomingCompositionMatrixGradients;
                upwardCompositionBiasGradients = ...
                    upwardCompositionBiasGradients + ...
                    incomingCompositionBiasGradients;
                upwardEmbeddingTransformMatrixGradients = ...
                    upwardEmbeddingTransformMatrixGradients + ...
                    incomingEmbeddingTransformMatrixGradients;
                upwardEmbeddingTransformBiasGradients = ...
                    upwardEmbeddingTransformBiasGradients + ...
                    incomingEmbeddingTransformBiasGradients;
                
                % Take gradients from the right child
                [ incomingWordGradients, ...
                  incomingCompositionMatricesGradients, ...
                  incomingCompositionMatrixGradients, ...
                  incomingCompositionBiasGradients, ...
                  incomingEmbeddingTransformMatrixGradients, ...
                  incomingEmbeddingTransformBiasGradients ] = ...
                  obj.getRightDaughter.getGradient( ...
                                compDeltaRight, wordFeatures, ...
                                compMatrices, compMatrix, compBias,  embeddingTransformMatrix, embeddingTransformBias,...
                                compNLDeriv, hyperParams);
                if hyperParams.trainWords
                    upwardWordGradients = upwardWordGradients + ...
                                          incomingWordGradients;
                end
                upwardCompositionMatricesGradients = ...
                    upwardCompositionMatricesGradients + ...
                    incomingCompositionMatricesGradients;
                upwardCompositionMatrixGradients = ...
                    upwardCompositionMatrixGradients + ...
                    incomingCompositionMatrixGradients;
                upwardCompositionBiasGradients = ...
                    upwardCompositionBiasGradients + ...
                    incomingCompositionBiasGradients;
                upwardEmbeddingTransformMatrixGradients = ...
                    upwardEmbeddingTransformMatrixGradients + ...
                    incomingEmbeddingTransformMatrixGradients;
                upwardEmbeddingTransformBiasGradients = ...
                    upwardEmbeddingTransformBiasGradients + ...
                    incomingEmbeddingTransformBiasGradients;
            elseif hyperParams.trainWords
                % Compute gradients for embedding transform layers

                if NUMTRANS > 0
                    delta = delta .* obj.mask; % Take dropout into account
                    [upwardEmbeddingTransformMatrixGradients, ...
                          upwardEmbeddingTransformBiasGradients, delta] = ...
                          ComputeEmbeddingTransformGradients(embeddingTransformMatrix, embeddingTransformBias, ...
                              delta, wordFeatures(obj.wordIndex, :)', ...
                              obj.transformInnerActivations, compNLDeriv);
                end

                % Compute the word feature gradients
                upwardWordGradients(obj.getWordIndex, :) = ...
                    upwardWordGradients(obj.getWordIndex, :) + delta';
            elseif NUMTRANS > 0
                % Compute gradients for embedding transform layers
                delta = delta .* obj.mask; % Take dropout into account

                [upwardEmbeddingTransformMatrixGradients, ...
                      upwardEmbeddingTransformBiasGradients, ~] = ...
                      ComputeEmbeddingTransformGradients(embeddingTransformMatrix, embeddingTransformBias, ...
                          delta, wordFeatures(obj.wordIndex, :)', ...
                          obj.transformInnerActivations, compNLDeriv);
            end            
        end
    end
end