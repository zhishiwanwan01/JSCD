clc; clear all;
matlabpool open;
EbN0 = 6:0.5:6;
BER = zeros(1,length(EbN0));
% index = [1 1 1 10 10 100 100 300 500 1000 2000 2400 2700 3000 4000];
index = 1000;
for k = 1 : length(EbN0)
    bitError = zeros(1,index(k));
    EbN0P = EbN0(k);
    tempIndex = index(k);
    for i = 1 : tempIndex
        bitSeq = double(randn(1,50000) > 0);
        [ convolutionalCodeSeq ] = convolutionalEncoder( bitSeq );
        unPuncturedCode = convolutionalCodeSeq ;
        [ puncturedCode ] = punctureBlock( unPuncturedCode );
        % BPSK
        codeRate = 8/14;
        [ seqAWGN ] = BPSKAndAddNoise( puncturedCode, EbN0P, codeRate );
        sourceLLR = zeros(1, length(bitSeq)+4);
        inputSequence = seqAWGN;
        [ channelLLR ] = channelAPPDecoder( inputSequence, EbN0P, sourceLLR );
        decodedSeq = channelLLR < 0;
        bitError(i) = sum(xor(decodedSeq(1:end-4), bitSeq)) / 50000;
    end
    BER(k) = sum(bitError);
end
semilogy(EbN0, BER);
grid on;
matlabpool close;