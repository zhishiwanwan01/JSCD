function [ newStr1, newStr2 ] = removeSameSymbol( str1, str2 )
%REMOVESAMESYMBOL  remove the same symbols between str1 and str2
%   [ newStr1, newStr2 ] = removeSameSymbol( str1, str2 ) only remove the
%   same symbols from the start and end.

% Pad two strings to enable the function find which need the lengths of two
% arrays are the same
newStr1 = [str1, -ones(1,length(str2))];
newStr2 = [str2, -ones(1,length(str1))];

% Find the difference
differentIndex = find(newStr1 ~= newStr2);

% Delete the same symbols from the start
newStr1(1:differentIndex(1)) = [];
newStr2(1:differentIndex(1)) = [];

% Delete the paddings in the sequence
newStr1(newStr1 == -1) = [];
newStr2(newStr2 == -1) = [];
end