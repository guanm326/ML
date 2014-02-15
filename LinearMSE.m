function [ C1,C2 ] = LinearMSE( Train1,Train2,Test1,Test2 )
    %Linear Classification with Minimum Square Error
    
    %Augmented Feature Vector for training
    Train1 = [ ones(size(Train1,1),1), Train1 ];
    Train2 = [ -ones(size(Train2,1),1), -Train2 ];
    
    Z_train = [ Train1;Train2 ];
    b = ones(size(Z_train,1),1);
    a = Z_train\b; %weight vector
    
    %Augmented Feature Vector for testing
    Test1 = [ ones(size(Test1,1),1), Test1 ];
    Test2 = [ -ones(size(Test2,1),1), -Test2 ];
    
    Z = [ Test1;Test2 ];
    
    predictions = Z * a;
    index_class = Z(1:end,1);
    C1_index = find(index_class == 1);
    C2_index = find(index_class == -1);
    
    C1 = predictions(C1_index);
    C1_true = find(C1 > 0);
    C1_false = find(C1 < 0);
    C1(C1_true) = 1;
    C1(C1_false) = -1;

    C2 = predictions(C2_index);
    C2_true = find(C2 > 0);
    C2_false = find(C2 < 0);
    C2(C2_true) = -1;
    C2(C2_false) = 1;
    
end

