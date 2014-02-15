function [ CONF,error ] = summarizeResults( C1,C2 )

    correct_class1 = length(find(C1 == 1));
    incorrect_class1 = length(find(C1 == -1));
    incorrect_class2 = length(find(C2 == 1));
    correct_class2 = length(find(C2 == -1));

    CONF = [ correct_class1,incorrect_class1 ; incorrect_class2,correct_class2 ];
    error = ( incorrect_class1 + incorrect_class2 ) / length( [C1;C2] );

end

