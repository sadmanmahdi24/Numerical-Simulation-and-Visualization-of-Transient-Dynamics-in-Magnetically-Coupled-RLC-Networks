function results=convergenceStudy(params,sim,source1,source2,x0,dtValues)
results.dt=dtValues;
results.error=zeros(size(dtValues));
simRef=sim;
simRef.dt=min(dtValues)/10;
[tRef,xRef]=rk4Solver(params,simRef,source1,source2,x0);
for n=1:length(dtValues)
    s=sim;
    s.dt=dtValues(n);
    [t,x]=rk4Solver(params,s,source1,source2,x0);
    err=0;
    for k=1:4
        xr=interp1(tRef,xRef(:,k),t);
        err=max(err,max(abs(x(:,k)-xr)));
    end
    results.error(n)=err;
end
end
