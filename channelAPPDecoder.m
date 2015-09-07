function [ channelLLR ] = ...
    channelAPPDecoder( inputSequence, EbN0, sourceLLR )
%CHANNELAPPDECODER generates the log-likelihood ratio of input sequence

EsN0 = 2* EbN0;
[ gama ] = gamaForChannelDecoding( inputSequence, EsN0, sourceLLR );
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
% alphaPrime = alpha';
% beltaPrime = belta';
end

