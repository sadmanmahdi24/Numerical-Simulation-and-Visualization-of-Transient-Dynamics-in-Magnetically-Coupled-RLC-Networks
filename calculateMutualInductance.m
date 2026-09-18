function [M,Delta]=calculateMutualInductance(L1,L2,k,p)
if nargin<4||isempty(p)
    p=1;
end
if L1<=0||L2<=0
    error('L1 and L2 must be greater than 0.');
end
if k<0||k>=1
    error('Coupling coefficient k must be between 0 and 1.');
end
if p~=1&&p~=-1
    error('Polarity must be 1 or -1.');
end
M=p*k*sqrt(L1*L2);
Delta=L1*L2-M^2;
if Delta<=0
    error('Singular system: check k and L values.');
end
end