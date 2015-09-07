function [ LLR ] = BCJRDecoder( seqAWGN, EbN0, channelLLR )
%BCJRDecoder generates the log-likelyhood ratio(LLR) of each bit for input
%sequence based on C12 code table and MAP algorithm
%   [ LLR ] = BCJRDecoder( seqAWGN, EbN0 ) calculates the LLR by computing
%   the value of gama alpha and belta; then Based on these three value, LLR
%   is calculated according to some equations.

EsN0 = EbN0;
[ gama ] = gamaCalculation( seqAWGN, EsN0, channelLLR );
[ alpha ] = alphaCalculation( gama );
[ belta ] = beltaCalculation( gama );
[ LLR ] = LLRCalculation( alpha, belta, gama );
end

