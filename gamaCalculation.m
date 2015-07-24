function [ gama ] = gamaCalculation( seqAWGN, EsN0 )
%GAMACALCULATION calcultes the value of gama(s',s) which is one of the
%three key parameters in BCJR decoding algorithm.
%   Given the sequence which is the output of channel and related decoding
%   trellis, calculate the probability gama according to the equation:
%   gama_k(s',s) = C_k*exp(u_k*L(u_k)/2)*exp(L_c/2*sum(x_kl*y_kl));

% Initialization
gama = zeros(2, length(seqAWGN));
gama(1, :) = exp(0.5*4*EsN0*(-1).*seqAWGN);
gama(2, :) = exp(0.5*4*EsN0.*seqAWGN);

end

