function [allFeatures,index] = processDir(dirName,l)
% reads all sequences of l character in length from the files in the input
% directory. Stores them in a hashTable "allFeatures". The
% value associated with each key in hashTable is the number of occurences
% of this feature in each file in the given directory


tic
index = 0;
allFeatures = java.util.Hashtable;
currentFile = java.util.Hashtable;

D = dir(dirName);
numFiles = size(D,1);

for i = 1:numFiles,
    nextName = D(i).name;
    
    fid = fopen(strcat(dirName,'/',char(nextName)),'r');
    if fid == -1 
        continue;
    end
    
    CHARS = fread(fid,'uchar');
    for j = 1:size(CHARS,1)-l,
       toAdd = char(CHARS(j:j+l)'); 
       if currentFile.containsKey(toAdd) ~= 1 
            currentFile.put(toAdd,0);
            if allFeatures.containsKey(toAdd) ~= 1,
                allFeatures.put(toAdd,1);
            else
                count = allFeatures.remove(toAdd);
                allFeatures.put(toAdd,count+1);
            end;
        end;
        h = allFeatures.get(toAdd);
    end;
    currentFile.clear;
    index = index + 1
    fclose(fid);
 end;
toc    