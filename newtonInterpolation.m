function y_val=newtonInterpolation(xdata,ydata,xval)
if length(xdata)~=length(ydata)
    error('xdata and ydata must be of the same length.');
end
N=length(xdata);
D=zeros(N,N);
D(:,1)=ydata(:);
for j=2:N
    for k=j:N
        D(k,j)=(D(k,j-1)-D(k-1,j-1))/(xdata(k)-xdata(k-j+1));
    end
end
y_val=zeros(size(xval));
for i=1:length(xval)
    xv=xval(i);
    sumval=D(1,1);
    p=1;
    for j=2:N
        p=p*(xv-xdata(j-1));
        sumval=sumval+D(j,j)*p;
    end
    y_val(i)=sumval;
end
end