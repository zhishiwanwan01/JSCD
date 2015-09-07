function [ newBitSeq ] = extraInputForConvolutionalCode( bitSeq )
%EXTRAINPUTFORCONVOLUTIONALCODE is used for calculate the extra input bits
%to enable the convolutional codes goes to state 0 in the end;
[innerInput, D3, D4] = innerInputCalculation( bitSeq );
D1 = [0, innerInput(1:end-1)];
D2 = [0, 0, innerInput(1:end-2)];
tempBit = [D3(end)+D2(end), D2(end)+D1(end), ...
    D1(end)+innerInput(end), innerInput(end)];
tempBit = mod(tempBit, 2);
newBitSeq = [bitSeq, tempBit];
end

