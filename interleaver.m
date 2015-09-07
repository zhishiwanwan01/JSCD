function [ interleavedSeq, index ] = interleaver( origSeq )
%INTERLEAVER is used to re-arrange the order of the sequence randomly
%   [ interleavedSeq, index ] = interleaver( origSeq ) is used to generate
%   the interleaved sequence and corrisponding index.

index = randperm(length(origSeq));
interleavedSeq = origSeq(index);
end

