function [ gama ] = ...
    gamaForChannelDecoding( inputSequence, EsN0, sourceLLR )
%GAMAFORCHANNELDECODING calculates the value of gama during the process of
%channel decoding.

% Initialization
prioriProbability = exp( abs(sourceLLR)/2 );
Lc = 4* EsN0;

% Reshape the input sequence to ease the calculation of gama
cutPoint = floor(length(inputSequence)/7)*7;
leftSeq = inputSequence(1: cutPoint);
rightSeq = inputSequence(cutPoint+1 : end);
newSeq = reshape(leftSeq, 7, []);
NewSeq = [newSeq; zeros(1, size(newSeq,2))];
newInputSeq = [NewSeq(:)', rightSeq];
newInputSeq = reshape(newInputSeq, 2, []);

gama = zeros(4, size(newInputSeq,2));
% Calculation
gama(1, :) = prioriProbability .* ...
    exp(0.5*Lc.* [-1 -1]* newInputSeq); % Trace output is 0 0.
gama(2, :) = prioriProbability .* ...
    exp(0.5*Lc.* [-1 1]* newInputSeq); % Trace output is 0 1.
gama(3, :) = prioriProbability .* ...
    exp(0.5*Lc.* [1 -1]* newInputSeq); % Trace output is 1 0.
gama(4, :) = prioriProbability .* ...
    exp(0.5*Lc.* [1 1]* newInputSeq); % Trace output is 1 1.

end

