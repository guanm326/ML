function [ C1,C2 ] = classifyKnn( Train1,Train2,Test1,Test2,k )
    % Main Function that will take Full Training Data from Spam 
    % and Ham to train KNN and apply it on the Test Datas
    
    %Classify Ham 
    C1 = zeros(size(Test1,1),1);
    for i=1:size(Test1,1),
        newSample = Test1(i,1:size(Test1,2));
        C1(i) = classifyKnnHelper(newSample,Train1,Train2,k);
    end
    
    %Classify Spam
    C2 = zeros(size(Test2,1),1);
    for i=1:size(Test2,1),
        newSample = Test2(i,1:size(Test2,2));
        C2(i) = classifyKnnHelper(newSample,Train1,Train2,k);
    end
    C1(find(C1 == 2)) = -1;
    C2(find(C2 == 2)) = -1;
    
end

function [ class ] = classifyKnnHelper( newSample,ham,spam,k )
    %Takes a set of Training Data and New Sample and Returns the Class 
    %it belongs to
    
    numClass1 = size( ham, 1 );
    numClass2 = size( spam, 1 );
    totalSamples = numClass1 + numClass2;
    combinedSamples = [ham; spam];

    trueClass = [zeros(numClass1,1)+1 ; zeros(numClass2,1)+2; ];

    testMatrix = repmat( newSample, totalSamples, 1 );

    absDiff = abs( combinedSamples - testMatrix );
    absDiff = absDiff.^2;
    dist = sum( absDiff,2 );
    [ Y,I ] = sort( dist ); %Y = Sorted Distances, I = sorted Index
    neighborsInd = I(1:k); %gets the closest neighbors index
    neighbors = trueClass( neighborsInd ); %class of neighbor

    %counts the number of neighbors that belong to each class
    class1 = find( neighbors == 1 );
    class2 = find( neighbors == 2 ); 
    joint = [size(class1,1) ; size(class2,1)]; 

    [value class] = max(joint);
    
end
