function results=solverComparison(params,sim,source1,source2,x0)
tic;
[t,x_euler]=eulerSolver(params,sim,source1,source2,x0);
time_euler=toc;
tic;
[~,x_rk4]=rk4Solver(params,sim,source1,source2,x0);
time_rk4=toc;
f=@(t,x)coupledRLC_derivative(t,x,params,source1,source2);
tic;
[~,x_ode45]=ode45(f,t,x0(:));
time_ode45=toc;
relErr_euler=relativeError(x_euler,x_ode45);
relErr_rk4=relativeError(x_rk4,x_ode45);
maxRelErr_euler=max(relErr_euler);
maxRelErr_rk4=max(relErr_rk4);
results.t=t;
results.x_euler=x_euler;
results.x_rk4=x_rk4;
results.x_ode45=x_ode45;
results.time_euler=time_euler;
results.time_rk4=time_rk4;
results.time_ode45=time_ode45;
results.relErr_euler=relErr_euler;
results.relErr_rk4=relErr_rk4;
results.maxRelErr_euler=maxRelErr_euler;
results.maxRelErr_rk4=maxRelErr_rk4;
fprintf('\n--- Solver Comparison (relative to ode45) ---\n');
fprintf('%-14s %-16s %-16s\n','Solver','Max Rel. Error','Exec Time (s)');
fprintf('%-14s %-16s %-16.6f\n','Euler',sprintf('%.4e',maxRelErr_euler),time_euler);
fprintf('%-14s %-16s %-16.6f\n','RK4',sprintf('%.4e',maxRelErr_rk4),time_rk4);
fprintf('%-14s %-16s %-16.6f\n','ode45','(reference)',time_ode45);
fprintf('\n');
end

function relErr=relativeError(x_test,x_ref)
absErr=max(abs(x_test-x_ref),[],1);
scale=max(abs(x_ref),[],1);
scale(scale==0)=1;
relErr=absErr./scale;
end