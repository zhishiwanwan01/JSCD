function [ bitSequence ] = C12Encoder( symbolFrame )
%C12_ENCODER encodes input symbolFrame into bit sequence which contains 0
%and 1.
%   [ bitSequence ] = c12_Encoder( symbolFrame ) encoding the symbol
%   sequence based on the C12 coding table:
%   [1 >> 00, 2>> 11, 3 >> 010, 4 >> 101, 5 >> 0110]

% Initialization
bitSequence = repmat(symbolFrame, 4, 1);

% Encoding
% Encoding 1st bit for each symbol
bitSequence(1, xor(xor(symbolFrame == 1, symbolFrame == 3),...
    symbolFrame == 5)) = 0;
bitSequence(1, bitSequence(1, :) ~= 0) = 1;
% Encoding 2nd bit for each symbol
bitSequence(2, xor(symbolFrame == 1, symbolFrame == 4)) = 0;
bitSequence(2, bitSequence(2, :) ~= 0) = 1;
% Encoding 3rd bit for each symbol
bitSequence(3, xor(symbolFrame == 1, symbolFrame == 2)) = -1;
bitSequence(3, symbolFrame == 3) = 0;
bitSequence(3, xor(symbolFrame == 4, symbolFrame == 5)) = 1;
% Encoding 4th bit for each symbol
bitSequence(4, symbolFrame == 5) = 0;
bitSequence(4, bitSequence(4, :) ~= 0) = -1;

% Reshape bitSequence into 1 row vector and delete -1 bit
bitSequence = bitSequence(:)';
bitSequence(bitSequence == -1) = [];
end

