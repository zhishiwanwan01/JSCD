numberOfCharacters = 100;
frameLength = 10;
[ source ] = randomSource( numberOfCharacters, frameLength );
symbolFrame = source(1, :);
[ bitSequence ] = C12_Encoder( symbolFrame );