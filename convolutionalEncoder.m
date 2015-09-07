function [ convolutionalCodeSeq ] = convolutionalEncoder( bitSeq )
%CONVOLUTIONALENCODER encode a bit sequence into convolutional code.
%   [ convolutionalCodeSeq ] = convolutionalEncoder( bitSeq ) will encode
%   bit sequence into recursive Recursive Systematic Convolutional code
%   with Gs(t) = [1, R1(t) = (1 + t + t^2 + t^4) / (1 + t^3 + t^4),
%   R2(t) = (1 + t^2 + t^3 + t^4) / (1 + t^3 + t^4),
%   R3(t) = (1 + t + t^3 + t^4) / (1 + t^3 + t^4)]

% Calculate the value in each register for each time k;
[innerInput, D3, D4] = innerInputCalculation( bitSeq );
D1 = [0, innerInput(1:end-1)];
D2 = [0, 0, innerInput(1:end-2)];

% Add extra bits to enable the trellis to go to the state 0 at the end
tempBit = [D3(end)+D2(end), D2(end)+D1(end), ...
    D1(end)+innerInput(end), innerInput(end)];
tempBit = mod(tempBit, 2);
D4 = [D4, D3(end), D2(end), D1(end), innerInput(end)];
D3 = [D3, D2(end), D2(end), innerInput(end), 0];
D2 = [D2, D1(end), innerInput(end), 0, 0];
D1 = [D1, innerInput(end), 0, 0, 0];
bitSeq = [bitSeq, tempBit];
innerInput = [innerInput, 0, 0, 0, 0];

% Calculate the output convolutional code based on the values in each
% register for each time k;
convolutionalCodeSeq = zeros(4, length(bitSeq));
convolutionalCodeSeq(1, :) = bitSeq;
convolutionalCodeSeq(2, :) = sum([innerInput; D1; D2; D4], 1);
convolutionalCodeSeq(3, :) = sum([innerInput; D2; D3; D4], 1);
convolutionalCodeSeq(4, :) = sum([innerInput; D1; D3; D4], 1);
convolutionalCodeSeq = mod(convolutionalCodeSeq, 2);
end

