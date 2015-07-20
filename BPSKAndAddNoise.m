function [ sequenceAWGN ] = BPSKAndAddNoise( bitSequence, EbN0, codeRate )
%BPSKANDADDNOISE apply BPSK modulation and then add AWGN on bitSequence
%   Given parameters EbN0 and codeRate, generate AWGN and add it on 
%   bitSequence after BPSK modulation which changes bit 0 to -1 and
%   keeps 1s in that sequence.

% BPSK
bitSequence = bitSequence * 2 - 1;

% AWGN

end

