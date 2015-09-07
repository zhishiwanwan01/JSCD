function [ belta ] = beltaForChannelDecoding( newGama1, newGama2 )
%BELTAFORCHANNELDECODING calculates the value of belta in the process of
%channel decoding.

% Initialization
belta = zeros(size(newGama1,1)+1, size(newGama1,2));
belta(end, 1) = 1;

% Calculation
for k = size(belta, 1)-1 : -1 : 1    
    tempBelta_18 = [belta(k+1, 1:8);belta(k+1, 1:8)];
    tempBelta_18 = tempBelta_18(:)';
    tempBelta_916 = [belta(k+1, 9:16);belta(k+1, 9:16)];
    tempBelta_916 = tempBelta_916(:)';
    
    belta(k, :) = tempBelta_18.* newGama1(k, :) + ...
        tempBelta_916.* newGama2(k, :);
    % Delete some value in belta due to the end of the trellis
    if k <= 4        
        belta(4, 2:2:end) = 0;
        belta(3, [2:4 6:8 10:12 14:end]) = 0;
        belta(2, [2:8 10:end]) = 0;
        belta(1, 2:end) = 0;
    end    
    % Normalization
    belta(k, :) = belta(k, :) ./ sum(belta(k, :));  
end
end
