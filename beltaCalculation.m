function [ belta ] = beltaCalculation( gama )
%BELTACALCULATION calculates the value of belta based on the corresponding
%game and decoding trellis
%   belta is calculated based on the equation:
%   belta_k-1(s') = sum(belta_k(s)* gama_k(s', s))

% Initialization
belta = zeros(length(gama)+1, 6);
belta(end, 1) = 1;

% Calculate belta
for k = length(belta)-1 : -1 : 1
<<<<<<< HEAD
    gama_0 = gama(1, k);
    gama_1 = gama(2, k);

    belta(k, :) = [belta(k+1, 2), belta(k+1, 1), belta(k+1, 1), ...
        belta(k+1, 1), belta(k+1, 1), belta(k+1, 1)] .* ...
            [gama_0, gama_0, gama_1, gama_0, gama_1, gama_0];
    belta(k, :) = belta(k, :) + [belta(k+1, 3:6), 0, 0] .* ...
=======
    gama_0 = gama(1, k-1);
    gama_1 = gama(2, k-1);
    
    belta(k, :) = [belta(k+1, 2), repmat(belta(k+1, 1), 1, 5)] .* ...
        [gama_0, gama_0, gama_1, gama_0, gama_1, gama_0];
    belta(k, :) = belta(k, :) + [belta(kb+1, 3:6), 0, 0] .* ...
>>>>>>> origin/master
        [gama_1, gama_1, gama_0, gama_1, 0, 0];
    
    % Delete some value in belta due to the start of the trellis
    if k <= 5
        belta(5, 6) = 0;
        belta(4, 4:5) = 0;
        belta(3, 2:3) = 0; belta(3, 6) = 0;
        belta(2, 4:6) = 0; belta(2, 1) = 0;
        belta(1, 2:6) = 0;
    end
    
    % Normalization
    belta(k, :) = belta(k, :) ./ sum(belta(k, :));    
end

end