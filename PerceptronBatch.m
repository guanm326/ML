function [ aBest ] = PerceptronBatch( Train1,Train2,k )

    alpha = 1;
    Train1 = [ ones(size(Train1,1),1), Train1 ]; %augment feature vector
    Train2 = [ -ones(size(Train2,1),1), -Train2 ];
    
    Z_train = [ Train1;Train2 ];
    
    a=ones(size(Z_train,2),1);
    weights = zeros( k,size(a,1) );
    error = weights(:,1);
    for i=1:k,
        weights(i,:) = a;
        b = Z_train * a; %results
        error(i) = sum(b<0,1);
        misclassified = Z_train( find(b < 0),: );
        a = transpose( transpose(a) + alpha*sum(misclassified,1) ); %new weight vector
    end
    target = find(error == min(error));
    aBest = weights(target(1),:);
    aBest = aBest(:,2:end);
end

