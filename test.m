%%
clc;clear all;close all;
%%
EbN0dB = 3;
EbN0P = 10.^ (EbN0dB./10);
EbN0 = EbN0P;
codeRate = 2.14/2.46;  
codeRateForAWGN = 8/14*2.14/2.46;
%%
numberOfCharacters = 2000;
frameLength = 2000;
[ source ] = randomSource( numberOfCharacters, frameLength );
%%
bitSequence = C12Encoder( source(1, :) );
allZeroSeq = zeros(1, length(bitSequence));
% Interleaving
interleaveIndex = randperm(length(bitSequence));
interleavedSeq = bitSequence(interleaveIndex);
% Convolutional Code
[ convolutionalCodeSeq ] = convolutionalEncoder( interleavedSeq );
% Puncturing
[ puncturedCode ] = punctureBlock( convolutionalCodeSeq );
[ seqAWGN ] = ...
            BPSKAndAddNoise( puncturedCode, EbN0, codeRateForAWGN );
sourceLLR = zeros( 1, length(bitSequence)+ 4 );
[ channelLLR ] = ...
                channelAPPDecoder( seqAWGN, EbN0, sourceLLR );
newChannelLLR = channelLLR - sourceLLR;
deInterleavedChannelLLR = channelLLR(1:end-4);
            deInterleavedChannelLLR(interleaveIndex) = ...
                deInterleavedChannelLLR;   
[ tempSourceLLR ] = ...
                    BCJRDecoder( allZeroSeq, ...
                                        EbN0, deInterleavedChannelLLR );
% Remove the channelLLR before sending the sourceLLR to
% channel decoder
newSourceLLR = tempSourceLLR - deInterleavedChannelLLR;
% Interleaving
interleavedSourceLLR = newSourceLLR(interleaveIndex);
% Additional bits for channel decoding
sourceLLR = ...
    [interleavedSourceLLR, zeros(1,4)]; 
%% test
resChannel = (deInterleavedChannelLLR < 0);
resSource = (tempSourceLLR < 0);
channelError = sum(xor(resChannel, bitSequence))
sourceError = sum(xor(resSource, bitSequence))
diffChannel = find(resChannel ~= bitSequence);
diffSource = find(resSource ~= bitSequence);

%% test 2
resChannelTestLLR = 200*(resChannel*2 -1);
[ sourceRes ] = ...
                    BCJRDecoder( allZeroSeq, ...
                                        EbN0, resChannelTestLLR );
binSourceRes = (sourceRes > 0);
sum(xor(binSourceRes, bitSequence))
%% test 3
symbolSeq = seqEstimation(resSource);
EditDistance = symbolErrorRate(symbolSeq, source(1,:));

%% test 5
% resGama = log(gama(1,:)./gama(2,:));
% ressGama = resGama>0;
% diffGama = sum(xor(ressGama, bitSequence));