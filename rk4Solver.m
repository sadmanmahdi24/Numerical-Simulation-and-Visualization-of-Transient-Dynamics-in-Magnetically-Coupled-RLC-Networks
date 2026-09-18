function [t,x_history]=rk4Solver(params,sim,source1,source2,x0)
dt=sim.dt;
tEnd=sim.tEnd;
t=(0:dt:tEnd)';
N=length(t);
x_history=zeros(N,4);
x_history(1,:)=x0(:)';
x_n=x0(:);
for n=1:(N-1)
    t_n=t(n);
    k1=coupledRLC_derivative(t_n,x_n,params,source1,source2);
    k2=coupledRLC_derivative(t_n+dt/2,x_n+dt*k1/2,params,source1,source2);
    k3=coupledRLC_derivative(t_n+dt/2,x_n+dt*k2/2,params,source1,source2);
    k4=coupledRLC_derivative(t_n+dt,x_n+dt*k3,params,source1,source2);
    x_next=x_n+(dt/6)*(k1+2*k2+2*k3+k4);
    x_history(n+1,:)=x_next';
    x_n=x_next;
end
end