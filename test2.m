clc;clear all;
% test for convolutional coding and decoding;
% bitSeq = [1 0 1 0 1 0 0 1 0];
bitSeq = double(randn(1,50000) > 0);
% [ newBitSeq ] = extraInputForConvolutionalCode( bitSeq );
% [ convolutionalCodeSeq ] = convolutionalEncoder( newBitSeq );
[ convolutionalCodeSeq ] = convolutionalEncoder( bitSeq );
unPuncturedCode = convolutionalCodeSeq ;
[ puncturedCode ] = punctureBlock( unPuncturedCode );
% BPSK
EbN0 = 8;
codeRate = 8/14;
[ seqAWGN ] = BPSKAndAddNoise( puncturedCode, EbN0, codeRate );
sourceLLR = zeros(1, length(bitSeq)+4);
inputSequence = seqAWGN;
[ channelLLR ] = channelAPPDecoder( inputSequence, EbN0, sourceLLR );
decodedSeq = channelLLR < 0;
error = sum(xor(decodedSeq(1:end-4), bitSeq));
find(decodedSeq(1:end-4) ~= bitSeq)
%%
% seq = bitSeq;
% bitSeq = newBitSeq;
% [innerInput(end-4:end);D1(end-4:end);D2(end-4:end);D3(end-4:end);D4(end-4:end)];