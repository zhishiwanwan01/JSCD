%%
clc; clear all; close all;
%% Initialization
EbN0dB = 0.5 : 0.5 : 3;   % EbN0 in dB
EbN0P = 10.^ (EbN0dB./10);  % EbN0 in power
codeRate = 2.14/2.46;   % Code rate of source encoding
% Number of symbols to be transmitted
charactersNum = [2000 4000 6000 6000 10000 10000];
frameLength = 2000;  % Length of frame
SER = zeros(1, length(EbN0dB));     % Symbol error ratio
codeRateForAWGN = 8/14*2.14/2.46;
iterationNum = 0;
%%
for i = 1 : length(EbN0dB)
    % Generate the random source
    [ source ] = randomSource( charactersNum(i), frameLength);
    % Initialization
    EditDistance = zeros(1, size(source,1));
    EbN0 = EbN0P(i);    
    
    for j = 1 : size(source, 1)
        % Source encode for input symbols to bits
        [ bitSequence ] = C12Encoder( source(j, :) );
        allZeroSeq = zeros(1, length(bitSequence));
        % Interleaving
        interleaveIndex = randperm(length(bitSequence));
        interleavedSeq = bitSequence(interleaveIndex);
        % Channel encode for input source encoded bits
        [ convolutionalCodeSeq ] = convolutionalEncoder( interleavedSeq );
        % Puncturing
        [ puncturedCode ] = punctureBlock( convolutionalCodeSeq );
        % Modulation and add Gaussian noise
        [ seqAWGN ] = ...
            BPSKAndAddNoise( puncturedCode, EbN0, codeRateForAWGN );
        % Initialization for iteration
        sourceLLR = zeros( 1, length(bitSequence)+ 4 );
        % Iterative decoding
        for k = 1 : iterationNum+ 1
            % Channel APP Decoder
            [ channelLLR ] = ...
                channelAPPDecoder( seqAWGN, EbN0, sourceLLR );
            % Remove the sourceLLR before sending the channelLLR to source
            % decoder
            newChannelLLR = channelLLR - sourceLLR;
            % Deinterleaving            
            deInterleavedChannelLLR = channelLLR(1:end-4);
            deInterleavedChannelLLR(interleaveIndex) = ...
                deInterleavedChannelLLR;            
            % A switch to decide to soft decoding or hard decoding
            if k == iterationNum+ 1
                break;
            else
                % Bit-level VLC-APP Decoder
                [ tempSourceLLR ] = ...
                    BCJRDecoder( allZeroSeq, ...
                                        EbN0, deInterleavedChannelLLR );
                % Remove the channelLLR before sending the sourceLLR to
                % channel decoder
                newSourceLLR = tempSourceLLR - deInterleavedChannelLLR;
                % Interleaving
                interleavedSourceLLR = newSourceLLR(interleaveIndex);
                % Additional bits for channel decoding
                sourceLLR = ...
                    [interleavedSourceLLR, zeros(1,4)];                
            end            
        end
        % Bit-level VLC-APP Decoder
        [ SourceLLRForHardDecision ] = ...
            BCJRDecoder( allZeroSeq, ...
                        EbN0, deInterleavedChannelLLR );
        % Estimate the symbol sequence from bit sequence
        decodedBitSeq =  double(SourceLLRForHardDecision < 0);
        [ symbolSeq ] = seqEstimation( decodedBitSeq );
        if length(symbolSeq) == length(source(j, :))
            if xor(symbolSeq, source(j, :)) == 0
                continue;
            end
        end
        [ EditDistance(j) ] = symbolErrorRate( symbolSeq, source(j, :) );
    end
    % Symbol error rate
    SER(i) = sum(EditDistance) / charactersNum(i);
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
% matlabpool close;