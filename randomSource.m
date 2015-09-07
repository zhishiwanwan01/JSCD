function [ source ] = randomSource( numberOfCharacters, frameLength )
%RANDOMSOURCE generates source characters with the given number and divide
%it into several frames.
%   [ source ] = randomSource( numberOfCharacters, frameLength ) generate
%   no.numberOfCharacters/frameLength sequences to be transamitted through 
%   a channel with random order.

% Initialize the probabilities of each symbols
probability = [0.33, 0.30, 0.18, 0.10, 0.09];
numberOfEachSymbol = probability * numberOfCharacters;

% Initialize source
source = zeros(1,numberOfCharacters);

% Generate source with sorted sequence
startIndex = 1;
for i = 1 : length(probability)
    endIndex = startIndex + numberOfEachSymbol(i) - 1;
    source(startIndex : endIndex) = zeros(numberOfEachSymbol(i),1) + i;
    startIndex = endIndex + 1;
end

% Generate source with random sequence
source = source(randperm(length(source)));

% Divide this whole source into frames
source = reshape(source, [], frameLength);
end

