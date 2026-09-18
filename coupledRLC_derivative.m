function dxdt=coupledRLC_derivative(t,x,params,source1,source2)
i1=x(1);
i2=x(2);
vC1=x(3);
vC2=x(4);
Vs1=sourceVoltage(t,source1);
Vs2=sourceVoltage(t,source2);
A=Vs1-params.R1*i1-vC1;
B=Vs2-params.R2*i2-vC2;
dIdt=[params.L1,params.M;params.M,params.L2]\[A;B];
di1dt=dIdt(1);
di2dt=dIdt(2);
dvC1dt=i1/params.C1;
dvC2dt=i2/params.C2;
dxdt=[di1dt;di2dt;dvC1dt;dvC2dt];
end