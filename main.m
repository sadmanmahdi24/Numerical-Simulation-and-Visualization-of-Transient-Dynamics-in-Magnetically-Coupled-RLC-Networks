clc;
clear;
close all;
params.R1=10;
params.R2=10;
params.L1=0.01;
params.L2=0.01;
params.C1=100e-6;
params.C2=100e-6;
params.k=0.5;
params.p=1;
[params.M,params.Delta]=calculateMutualInductance(params.L1,params.L2,params.k,params.p);
sim.dt=1e-5;
sim.tEnd=0.05;
sim.solver='RK4';
source1.type='step';
source1.V0=10;
source1.tstart=0;
source2.type='none';
x0=[0;0;0;0];
[t,x]=rk4Solver(params,sim,source1,source2,x0);
metrics=calculateMetrics(t,x,params)

