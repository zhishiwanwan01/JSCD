function [ symbolSeq ] = seqEstimation( bitSeq )
%SEQESTIMATION estimate the symbol sequence based on the coding table
%   Given bit sequence and corresponding coding table, estimate the symbol
%   sequence.

% Initialization
symbolSeq = -ones(size(bitSeq));
i = 1; 
j = 1;

% Estimation
while(i < length(bitSeq))
    if i == length(bitSeq) - 1
        if(bitSeq(i))   % [1]
            symbolSeq(j) = 2;   % [1 1] >> 2
            break
        else            % [0]
            symbolSeq(j) = 1;   % [0 0] >> 1
            break    
        end
    elseif i == length(bitSeq) - 2
        if(bitSeq(i))   % [1]
            symbolSeq(j) = 4;   % [1 0 1] >> 4
            break
        else            % [0]
            symbolSeq(j) = 3;   % [0 1 0] >> 3
            break    
        end
    elseif i == length(bitSeq) - 3
        if(xor(bitSeq(i:end), [0 1 1 0]) == 0)
            symbolSeq(j) = 5;   % [0 1 1 0] >> 5
            break
        else
            if(bitSeq(i))
                if(bitSeq(i+2)) 
                    symbolSeq(j) = 2;   % [1 1 1 1] >> [2 2]
                    symbolSeq(j+1) = 2;
                    break
                else
                    symbolSeq(j) = 2;   % [1 1 0 0] >> [2 1]
                    symbolSeq(j+1) = 1;
                    break
                end
            else
                if(bitSeq(i+2))
                    symbolSeq(j) = 1;   % [0 0 1 1] >> [1 2]
                    symbolSeq(j+1) = 2;
                    break
                else
                    symbolSeq(j) = 1;   % [0 0 0 0] >> [1 1]
                    symbolSeq(j+1) = 1;
                    break
                end
            end
        end
    else
        if(bitSeq(i))   % [1]
            if(bitSeq(i+1))   % [1 1]
                symbolSeq(j) = 2;   % [1 1] >> 2
                j = j + 1;
                i = i + 2;
                continue
            else            % [1 0]
                symbolSeq(j) = 4;   % [1 0 1] >> 4
                j = j + 1;
                i = i + 3;
                continue
            end
        else            % [0]
            if(bitSeq(i+1)) % [0 1]
                if(bitSeq(i+2)) % [0 1 1]
                    symbolSeq(j) = 5;   % [0 1 1 0] >> 5
                    j = j + 1;
                    i = i + 4;
                    continue
                else            % [0 1 0]
                    symbolSeq(j) = 3;   % [0 1 0] >> 3
                    j = j + 1;
                    i = i + 3;
                    continue
                end
            else            % [0 0]
                symbolSeq(j) = 1;   % [0 0] >> 1
                j = j + 1;
                i = i + 2;
                continue                
            end            
        end        
    end
end

% Delete meaningless symbol
symbolSeq(symbolSeq == -1) = [];
end