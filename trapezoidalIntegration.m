function result=trapezoidalIntegration(x,y)
if length(x)~=length(y)
    error('x and y arrays must be of the same length.');
end
n=length(x);
result=0;
for i=1:(n-1)
    h=x(i+1)-x(i);
    area=(h/2)*(y(i)+y(i+1));
    result=result+area;
end
end