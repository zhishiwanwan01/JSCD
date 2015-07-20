function [ source ] = randomSource( numberOfCharacters, frameLength )
%RANDOMSOURCE generates source characters with the given number and divide
%it into several frames.
%   [ source ] = randomSource( numberOfCharacters, frameLength ) generate
%   no.numberOfCharacters/frameLength sequences to be transamitted through 
%   a channel with random order.

% Initialize the probabilities of each symbols
probability = [0.33, 0.30, 0.18, 0.10, 0.09];

% Initialize source
source = [];

% Generate source with sorted sequence
for i = 1 : length(probability)
    source = [source; zeros(numberOfCharacters * probability(i),1) + i];
end

% Generate source with random sequence
source = source(randperm(length(source)));

% Divide this whole source into frames
source = reshape(source, [], frameLength);

end

