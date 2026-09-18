function [t,x_history]=eulerSolver(params,sim,source1,source2,x0)
dt=sim.dt;
tEnd=sim.tEnd;
t=(0:dt:tEnd)';
N=length(t);
x_history=zeros(N,4);
x_history(1,:)=x0(:)';
x_n=x0(:);
for n=1:(N-1)
    t_n=t(n);
    dxdt=coupledRLC_derivative(t_n,x_n,params,source1,source2);
    x_next=x_n+dt*dxdt;
    x_history(n+1,:)=x_next';
    x_n=x_next;
end
end
