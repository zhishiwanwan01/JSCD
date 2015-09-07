function [ EditDistance ] = symbolErrorRate( seq1, seq2 )
%SYMBOLERRORRATE calculates the levenshtein distance between sequence1 and
%sequence 2
%   Levenshtein distance is a string metric for measuring the difference
%   between two sequences. Informally, the Levenshtein distance between two
%   words is the minimum number of single-character edits(i.e. insertions, 
%   deletions or subsititutions) required to change one word into the
%   other.

% Remove the same symbols between two sequences to reduce the running time
[ newStr1, newStr2 ] = removeSameSymbol( seq1, seq2 );
[ str1, str2 ] = removeSameSymbol( fliplr(newStr1), fliplr(newStr2) );
str1 = fliplr(str1);
str2 = fliplr(str2);

% Initialization
resultMat = zeros(length(str1),length(str2));

% Calculte the Levenshtein distance matrix
EditDistanceMatrix = leven_dis2(str1 , str2, resultMat);
EditDistance = EditDistanceMatrix(end, end);
end

