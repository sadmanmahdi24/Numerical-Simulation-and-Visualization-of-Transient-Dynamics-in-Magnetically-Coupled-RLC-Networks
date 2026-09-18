function dy = numericalDerivative(x, y)
    if length(x) ~= length(y)
        error('Error: x and y arrays must be of the same length.');
    end    
    n = length(x);
    dy = zeros(size(y)); 
    dy(1) = (y(2) - y(1)) / (x(2) - x(1));
    for i = 2:(n-1)
        dy(i) = (y(i+1) - y(i-1))/(x(i+1) - x(i-1));
    end
    dy(n)=(y(n)-y(n-1))/(x(n) - x(n-1));
end