function results = parameterSweep(params,sim,source1,source2,x0,parameter,values)

results.parameter=values;
results.peakCurrent=zeros(size(values));
results.peakVoltage=zeros(size(values));
for n=1:length(values)
    p=params;
    switch parameter
        case 'k'
            p.k=values(n);
            [p.M,p.Delta]=calculateMutualInductance(p.L1,p.L2,p.k,p.p);
        case 'R1'
            p.R1=values(n);
        case 'R2'
            p.R2=values(n);
        case 'L1'
            p.L1=values(n);
        case 'L2'
            p.L2=values(n);
        case 'C1'
            p.C1=values(n);
        case 'C2'
            p.C2=values(n);
    end
    [~,x]=rk4Solver(p,sim,source1,source2,x0);
    results.peakCurrent(n)=max(abs(x(:,2)));
    results.peakVoltage(n)=max(abs(x(:,4)));
end
end
