function [ LLR ] = LLRCalculation( alpha, belta, gama )
%LLRCALCULATION calculate the value of loglikelihood ratio(LLR).
%   Given the value of alpha, belta, and game, joint probability p(s',s,y)
%   can be calculated by the equation:
%   p(s',s,y) = alpha_k-1(s')* gama_k(s',s)* belta_k(s).
%   Then, LLR can be calculated by the equation:
%   LLR = sum(p0(s',s,y))/sum(p1(s',s,y)).

% Initializaton
newAlpha = alpha(1:end-1, :)';
newBelta = belta(2:end, :)';
jointProbability = zeros(size(gama));

% Calculation of joint probability
jointProbability(1, :) = sum([newAlpha(1:4, :); newAlpha(6, :)] .* ...
                        repmat(gama(1, :), 5, 1) .* ...
                        [newBelta(2, :); newBelta(1, :); newBelta(5, :); 
                        repmat(newBelta(1, :), 2, 1)]);
jointProbability(2, :) = sum(newAlpha(1:5, :) .* ...
                        repmat(gama(2, :), 5, 1) .*...
                        [newBelta(3:4, :); newBelta(1, :); 
                        newBelta(6, :); newBelta(1, :)]); 

% Normalization
jointProbability = jointProbability ./ repmat(sum(jointProbability), 2, 1);

% Calculation of LLR
LLR = log(jointProbability(1, :)./ jointProbability(2, :));
end