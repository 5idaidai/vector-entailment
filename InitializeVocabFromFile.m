function [ vocab, fullVocab, fullWordmap ] = InitializeVocabFromFile(wordMap, loc, initScale)
% Initialize the embedding matrix from an existing vector source.

% This will only initialize words that are specified in wordMap.
% If a word is in wordMap but not in the initialization fine, it will be initialized randomly.

wordlist = wordMap.keys();

if isempty(loc)
    % Load the old two-file GloVe vectors.
    fid = fopen('sick_data/words_25d.txt');
    words = textscan(fid,'%s','Delimiter','\n');
    words = words{1};
    fclose(fid);
    fullVocab = dlmread('sick_data/vectors_25d.txt', ' ', 0, 1);
else
    % Load a single vector file.
    fid = fopen(loc);
    words = textscan(fid,'%s %*[^\n]'); % Take only first column.
    words = words{1};
    fclose(fid);
    fullVocab = dlmread(loc, ' ', 0, 1); 
end

fullWordmap = containers.Map(words,2:length(words) + 1);

x = size(wordlist, 2);

% Standard deviation of the loaded vectors (pooled across all units).
dataStd = std(fullVocab(:));

% Rescale the loaded vectors into the same neighborhood as the random ones.
loadScale = initScale / dataStd;

vocab = rand(x, size(fullVocab, 2)) .* (2 * initScale) - initScale;

for wordlistIndex = 1:length(wordlist)
    if fullWordmap.isKey(wordlist{wordlistIndex})
        loadedIndex = fullWordmap(wordlist{wordlistIndex});
    elseif fullWordmap.isKey(strrep(wordlist{wordlistIndex}, '_', '-'))
        loadedIndex = fullWordmap(strrep(wordlist{wordlistIndex}, '_', '-'));
    elseif strcmp(wordlist{wordlistIndex}, 'n''t') && isempty(loc)
        loadedIndex = fullWordmap('not');
        disp('Mapped not.');
    else
        loadedIndex = 0;
        disp(['Word could not be loaded: ', wordlist{wordlistIndex}]);
    end
    if loadedIndex > 0
        % Copy in the loaded vector
        vocab(wordMap(wordlist{wordlistIndex}), :) = fullVocab(loadedIndex, :) .* loadScale;
    end % Else: We keep the randomly initialized entry
end

end