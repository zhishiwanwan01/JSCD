function [ alpha ] = alphaForChannelDecoding( newGama1, newGama2 )
%ALPHAFORCHANNELDECODING calculates the value of alpha in the process of
%channel decoding.

% Initialization
alpha = zeros(size(newGama1,1)+1, size(newGama1,2));
alpha(1,1) = 1;

% Calculation
for k = 2 : size(alpha, 1)    
    alpha_18 = alpha(k-1, :).* newGama1(k-1, :);
    alpha_916 = alpha(k-1, :).* newGama2(k-1, :);
    
    alpha(k, 1:8) = alpha_18(1:2:end)+ alpha_18(2:2:end);
    alpha(k, 9:16) = alpha_916(1:2:end)+ alpha_916(2:2:end);
    % Delete some value in alpha due to the end of the trellis
    if k > size(alpha, 1) - 4
        alpha(end-3, 9:end) = 0;
        alpha(end-2, 5:end) = 0;
        alpha(end-1, 3:end) = 0;
        alpha(end, 2:end) = 0;
    end    
    % Normalization
    alpha(k, :) = alpha(k, :) ./ sum(alpha(k, :)); 
end
end