function [ channelLLR ] = LLRForChannelDecoding( alpha, belta, ...
                                                    newGama1, newGama2 )
%LLRFORCHANNELDECODING calculates the value of LLR during the process of
%channel decoding.
% Initialization
belta_18 = [belta(2:end, 1:8); belta(2:end, 1:8)];
belta_18 = reshape(belta_18, size(belta,1)-1, []);
belta_916 = [belta(2:end, 9:16); belta(2:end, 9:16)];
belta_916 = reshape(belta_916, size(belta,1)-1, []);

newAlpha = alpha(1:end-1, :);

tempJointProbability1 = newAlpha .* newGama1 .* belta_18;
tempJointProbability2 = newAlpha .* newGama2 .* belta_916;

index0 = 1:16;
index1 = [2 3 6 7 10 11 14 15];
index0(index1) = [];

jointProbability0 = sum(tempJointProbability1(:, index0),2) + ...
    sum(tempJointProbability2(:, index1),2);
jointProbability1 = sum(tempJointProbability1(:, index1),2) + ...
    sum(tempJointProbability2(:, index0),2);

jointProbability = [jointProbability0'; jointProbability1'];

% Normalization
jointProbability = jointProbability ./ repmat(sum(jointProbability), 2, 1);

% Calculation of LLR
channelLLR = log(jointProbability(1, :)./ jointProbability(2, :));
end

