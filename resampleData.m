function  [Cnew1,Cnew2] = resampleData(C1,C2,d)
%C1 and C2 are 2 classes, samples are piled as rows 
%d(1:size(C1,1)) holds the weights for C1, 
%d(size(C1,1)+1:size(C2,1) holds the weights for C2
%sum of weights in d is 1
%This function will draw k samples according to the weight distribution
%in d, and output the samples in Cnew1,Cnew2. 
%Cnew1 will have samples of class1, Cnew2 will have samples of class2.
%The number of rows in Cnew1,Cnew2, in general,will be different from that
%in C1 and C2


k = size(C1,1)+size(C2,1);

%%%%First do some checking of the input

if size(C1,2) ~= size(C2,2)
    error('in resampleData number of columns(=num features) must be the same in C1 and C2','');
end;

if abs(sum(d) - 1) > 0.001
    error('in resampleData sum of d is not 1','');
end;

if size(d,1) ~= size(C1,1)+size(C2,1)
    error('in resampleData number of rows in d has to be equal to num. rows in C1 + num. rows in C2','');
end;

if ~(k > 0)
    error('in resampleData: k, number of samples to draw has to be larger than 0',' ');
end;
%%% Done checking the input 

R = rand(k,1);                                  %generates k random samples (uniformly) in (0,1)
C=[C1;C2];
cumD = cumsum(d);                               

Cnew1 = [];
Cnew2 = [];

for i = 1:k,
    Smaller = find(cumD < R(i));
    
    index = size(Smaller,1)+1;
    sample = C(index,:);
    if index > size(C1,1)
        Cnew2 = [Cnew2;sample];
    else
        Cnew1 = [Cnew1;sample];
    end;
end;