%%
clc;clear all;
%%
EbN0dB = 3.5;
EbN0P = 10.^ (EbN0dB./10);
EbN0 = EbN0P;
codeRate = 2.14/2.46;  
%%
numberOfCharacters = 100;
frameLength = 10;
[ source ] = randomSource( numberOfCharacters, frameLength );
symbolFrame = source(1, :);
<<<<<<< HEAD
%%
% bitSeq = [1 1 0 0 0 1 1 0 1 0];
conSeq = convolutionalEncoder(symbolFrame);
puncturedSeq = punctureBlock(conSeq);
% inputSequence = puncturedSeq;
[ seqAWGN ] = BPSKAndAddNoise( puncturedSeq, EbN0, codeRate );
sourceLLR = zeros(1, frameLength);
%%
% [ channelLLR ] = channelAPPDecoder( seqAWGN , EbN0, sourceLLR );
% inputSequence = seqAWGN;
EsN0 = EbN0;
[ gama ] = gamaForChannelDecoding( seqAWGN, EsN0, sourceLLR );
gama_00 = gama(1, :)';
gama_01 = gama(2, :)';
gama_10 = gama(3, :)';
gama_11 = gama(4, :)';

newGama1 = [gama_00, gama_11, gama_10, gama_01...
        gama_01, gama_10, gama_11, gama_00...
        gama_01, gama_10, gama_11, gama_00...
        gama_00, gama_11, gama_10, gama_01];
newGama2 = [gama_11, gama_00, gama_01, gama_10...
        gama_10, gama_01, gama_00, gama_11...
        gama_10, gama_01, gama_00, gama_11...
        gama_11, gama_00, gama_01, gama_10];
[ alpha ] = alphaForChannelDecoding( newGama1, newGama2 );
[ belta ] = beltaForChannelDecoding( newGama1, newGama2 );
[ channelLLR ] = LLRForChannelDecoding( alpha, belta, newGama1, newGama2 );
% [ bitSequence ] = C12Encoder( symbolFrame );
% [ symbolSeq ] = seqEstimation( bitSequence );
% xor(symbolFrame,symbolSeq )
=======
[ bitSequence ] = C12_Encoder( symbolFrame );
>>>>>>> origin/master
