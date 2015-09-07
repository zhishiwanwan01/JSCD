function [ origSeq ] = deinterleaver( interleavedSeq, index )
%DEINTERLEAVER deinterleave the interleaved sequence based on the input
%index
%   [ origSeq ] = deinterleaver( interleavedSeq, index ) recover the
%   original sequence from interleaved sequence based on the gived index.

origSeq(index) = interleavedSeq;
end

