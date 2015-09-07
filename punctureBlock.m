function [ puncturedCode ] = punctureBlock( unPuncturedCode )
%PUNCTUREBLOCK puncture the sequence to achieve higher code rate.
%   [ puncturedCode ] = punctureBlock( unPuncturedCode ) delete the bits in
%   the sequence in target sequence under the principle:
%   [1111 1111
%    1110 1110
%    0000 0000]

puncturedCode = unPuncturedCode(1:2, :);
puncturedCode(2, 4:4:end) = -1;
puncturedCode = puncturedCode(:).';
puncturedCode(puncturedCode == -1) = [];
end