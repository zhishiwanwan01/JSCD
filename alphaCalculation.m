function [ alpha ] = alphaCalculation( gama )
%ALPHACALCULATION calcultes the value of alpha based on the value of gama
%and decoding trellis.
%   [ alpha ] = alphaCalculation( gama ) calculates alpha by the equation: 
%   a_k(s) = sum(a_k-1(s')* gama_k(s', s))

% Initialization
alpha = zeros(length(gama)+1, 6);
alpha(1,1) = 1;

% Calculate alpha
for k = 2 : size(alpha, 1)
    gama_0 = gama(1, k-1);
    gama_1 = gama(2, k-1);
    
    alpha(k, 1) = alpha(k-1, 2:6) * ...
        [gama_0; gama_1; gama_0; gama_1; gama_0];   % alpha_0
    alpha(k, 2:6) = [alpha(k-1, 1), alpha(k-1, 1), alpha(k-1, 2:4)] .* ...
        [gama_0, gama_1, gama_1, gama_0, gama_1];   % alpha_1 -- alpha_5
    
    % Delete some value in alpha due to the end of the trellis
    if k >= length(alpha)-2
        alpha(end-2, 5:6) = 0;
        alpha(end-1, 1) = 0;
        alpha(end, 2:6) = 0;
    end
    
    % Normalization
    alpha(k, :) = alpha(k, :) ./ sum(alpha(k, :)); 
end
end