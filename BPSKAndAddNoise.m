function [ seqAWGN ] = BPSKAndAddNoise( bitSequence, EbN0, codeRate )
%BPSKANDADDNOISE apply BPSK modulation and then add AWGN on bitSequence
%   Given parameters EbN0 and codeRate, generate AWGN and add it on 
%   bitSequence after BPSK modulation which changes bit 0 to -1 and
%   keeps 1s in that sequence. Here EbN0 is measured in watts. codeRate is
%   equal to Rm * Rc where Rm equals to 1 and Rc equals to 2.14/2.46 for
%   C12.

% BPSK
seqBPSK = bitSequence * 2 - 1;

% AWGN
noiseSigma = sqrt(1./(2*codeRate*EbN0));
noise = noiseSigma * randn(1,length(seqBPSK));
seqAWGN = noise + seqBPSK;

end

