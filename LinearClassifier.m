function [ C1,C2 ] = LinearClassifier( a,Test1,Test2 )

    C1 = Test1 * transpose(a);
    C1(find( C1>0 )) = 1;
    C1(find( C1<0 )) = -1;

    
    C2 = Test2 * transpose(a);
    C2(find( C2>0 )) = 1;
    C2(find( C2<0 )) = -1;
    
end

