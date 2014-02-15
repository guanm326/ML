function features = extractFeatures(fileName)
% extracts features from one file 'fileName' and stores them in the output 
% array.  'fileName' should be the complete name of the file, including
% directory, if file you want to extract features from is not in the same
% directory as function extractFeatures.m
% for assignment, these features are stored in samples/Spam/Ham/Test/Train/



%%%%%%%%%%%%%%%FEATURE TYPES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIRST SET OF FEATURES: frequency counts of specialWords.
% For each word in specialWords array, we count 
%(word count * 100)/(total number of words)
% SECOND SET OF FEATURES: frequency counts of specialCharacters.
% For each character in specialCharacters array, we count 
%(character count * 100)/(total number of characters)
% THIRD SET OF FEATURES: additional features (after the first 2 sets of features):  
% (a) The percentage of capital letters (out of all characters) in the text
% (b) The percentage of small letters (out of all characters) in the text
% (c) The percentage of digits (out of all characters) in the text
% (d) The percentage characters (out of all characters)  which are neither
%     digits nor characters 
% (e) The length of the longest string of capital letters
% (f) The average length of strings made up of capital letters 

specialCharacters = ['$';'%';'#';':';';';'[';']';'!';'(';')';'?';'<';'|';'+';'^'];
specialCharacters = double(specialCharacters);  %converts characters to numbers

specialWords = {'money';'free';'buy';'pharmacy';'prescription';'generic';'help';'make';'remove';'order';'mail';'receive';'business';'credit';'direct';'conference';'project';'addresses';'reply';'taken';'off';'mailing';'list';'confident';'hair';'loss';'product';'lonely';'drug';'drugs';'normal';'medications';'prescribed';'internet';
               'meds';'original';'message';'office';'Viagra';'Cialis';'urgent';'response';'assistance';'friend';'need';'transaction';'rate';'workplace';'WORKPLACE'
               'trial';'men';'girl';'girls';'penis';'growth';'loan';'urgent';'rolex';'pils';'enlargment';'supplement';'offer';'limited';'inch';
               'lowest';'bigger';'sex';'manhood';'prize';'claims';'naked';'honey';'stranger';'love';'blond';'orgasm';'hot';'profile'};


numFeatures = 99;  % total number of features           
currFeature = 1;
features = zeros(numFeatures,1);          %initializes output array 'features' to an empty array


%Now will open the file again for word counting
fid = fopen(fileName,'r');
if fid == -1 
    return;
end

wordsCell = textscan(fid,'%s');
words = lower(wordsCell{1});
numWords = size(words,1);

for i = 1:size(specialWords,1),
    count = 0;
    for j = 1:numWords,
         temp = strfind(char(words(j)),char(specialWords(i)));
         if temp > 0 
            count = count+1;
         end
    end;
    if ( numWords > 0)
        features(currFeature) = (count*100/numWords);
    end;
    currFeature = currFeature+1;
end
fclose(fid);

%%%%%%%%%%%%%%%%%% done with FIRST SET OF FEATURES (word counts)  %%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%open file again for counting characters %%%%%%%%%%%%%%%%%%%%%%%%
% We open file in the binary read mode, all characters are stored
% in array char. 

fid = fopen(fileName,'r');
if fid == -1 
    return;
end

chars = fread(fid);   %this array contains characters and is used for character counting
fclose(fid);

numChars = size(chars,1);
countArray=zeros(256,1);

for i = 1:numChars,
    if chars(i) > 0, 
        countArray(chars(i)) = countArray(chars(i)) + 1;
    end;
end;


for i = 1:size(specialCharacters,1)
    if (numChars > 0)
        features(currFeature) = countArray(specialCharacters(i))*100/numChars;
        currFeature = currFeature+1;
    end;
end;

%%%%%%%%%%%%%%%%%% done with SECOND SET OF FEATUERS( character counts) %%%%%%%%%%%%%%%%%%%%%%%

%Now we will count the percentage of capital letters in the text
%capitals go from 65 to 90 in ASCII codes
capLetters = sum(countArray(65:90));

features(currFeature) = capLetters*100/numChars;
currFeature = currFeature+1;

%Now we will count the percentage of small letters in the text
%capitals go from 97 to 122 in ASCII codes
smallLetters = sum(countArray(97:122));
features(currFeature) =  smallLetters*100/numChars;
currFeature = currFeature+1;

%Now we will count the percentage of digits in the text
%capitals go from 48 to 57 in ASCII codes
digits = sum(countArray(48:57));
features(currFeature) = digits*100/numChars;
currFeature = currFeature+1;


%Now we will count the percentage characters which are neither 
% digits nor characters 
features(currFeature) = (sum(countArray) - capLetters - smallLetters-digits)*100/numChars;
currFeature = currFeature+1;

%Now we will compute the length of the longest string of capital letters
numCapStrings = 0; 
I = find(chars > 64 & chars < 91);
totalLength   = size(I,1);
if ( totalLength > 0 ) 
    numCapStrings = 1; 
    currLength    = 1;
end;
maxLength     = 0;

for (i = 2:totalLength)
    if (I(i) ~= I(i-1)+1 )
        numCapStrings = numCapStrings+1;
        if  currLength > maxLength 
            maxLength = currLength;
        end
        currLength = 1;
    else
        currLength = currLength+1;
    end
end

features(currFeature) = maxLength;  %adds longest string of capital letters 
currFeature = currFeature+1;

if (numCapStrings > 0 )
    features(currFeature) = totalLength/numCapStrings;  %adds ratio capital letters string feature
end;
