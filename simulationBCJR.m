clear all; close all; clc
matlabpool open;
% Initialization
EbN0dB = 3.5 : 0.5 : 3.5;
EbN0P = 10.^ (EbN0dB./10);
frameLength = 2000;
numberOfCharacters = 2000* 10.^ceil(EbN0dB-2);
codeRate = 2.14/2.46;   % CodeRate for C12
SER = zeros(1, length(EbN0dB));

for i = 1 : length(EbN0dB)
    % Generate the random source
    [ source ] = randomSource( numberOfCharacters(i), frameLength );
    % Initialization
    EditDistance = zeros(1, size(source,1));
    EbN0 = EbN0P(i);
    
%     parfor k = 1 : size(source,1)
    for k = 1 : size(source,1)
        % Encode symbol sequence into bit sequence
        [ bitSequence ] = C12Encoder( source(k, :) );
        % Modulation and add Gaussian noise
        [ seqAWGN ] = BPSKAndAddNoise( bitSequence, EbN0, codeRate );
        % BCJR decoding
        channelLLR = zeros(1, length(seqAWGN));
        [ sourceLLR ] = BCJRDecoder( seqAWGN, EbN0, channelLLR );
        % Estimate the symbol sequence from bit sequence
        bitSeq = sourceLLR < 0;
        [ symbolSeq ] = seqEstimation( bitSeq );
        if length(symbolSeq) == length(source(k, :))
            if xor(symbolSeq, source(k, :)) == 0
                continue;
            end
        end
        [ EditDistance(k) ] = symbolErrorRate( symbolSeq, source(k, :) );
    end
    
    SER(i) = sum(EditDistance) / numberOfCharacters(i);
end

%%
figure(1);
semilogy(EbN0dB, SER, '-o');

grid on;
hold on;




%Ad12 = [0 7.00 22.76 64.48 151.61 303.44 511.91 745.60 930.61 1012.37];
Bd12 = [0 20.51 90.54 292.72 746.37 1564.48 2737.29 4084.06 5210.94 5758.34];

%Ad15 = 1.14 2.79 13.36 59.791 195.75 493.56 987.32 1593.52 2096.88 2262.00];
Bd15 = [1.14 8.94 65.68 322.76 1117.64 2917.66 5968.94 9778.34 12993.70 14100.80];

Ps12 = 0:0.01:13;
Ps15 = 0:0.01:13;

rate12 = 2.14 / 2.46;
rate15 = 2.14 / 2.37;

t = 1;

for n = 0:0.01:13
    Ps = 0;
    ndb = 10^(n/10);
    for d = 2:10                            %calculate Ps12
        Pd = 0.5 * erfc (sqrt (d * ndb));   %calculate Pd
        Pstemp = Bd12(d) * Pd;
        Ps = Ps + Pstemp;
    end    
    Ps12(t)= Ps;
    Ps = 0;
    for d = 1:10                            %calculate  Ps15
        Pd = 0.5 * erfc (sqrt (d * ndb));   %calculate  Pd
        Pstemp = Bd15(d) * Pd;
        Ps = Ps + Pstemp;
    end
    Ps15(t)= Ps;
    t = t + 1;
end
n = 0:0.01:13;
figure(1);
semilogy (n - 10*log10(rate12),Ps12); title('Approximative upper bound and BCJR decoder simulation curve for code C12'); 
xlabel('Eb/N0');ylabel('Symbol Error Rate');
grid on;
hold off;
matlabpool close;