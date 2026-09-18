function metrics = calculateMetrics(t,x,params)
i1=x(:,1);
i2=x(:,2);
vC1=x(:,3);
vC2=x(:,4);

metrics.peak_i1=max(abs(i1));
metrics.peak_i2=max(abs(i2));
metrics.peak_vC1=max(abs(vC1));
metrics.peak_vC2=max(abs(vC2));
metrics.final_i1=i1(end);
metrics.final_i2=i2(end);
M=params.M;
metrics.energy_L=0.5*params.L1*i1.^2+0.5*params.L2*i2.^2+M.*i1.*i2;

metrics.energy_C=0.5*params.C1*vC1.^2+0.5*params.C2*vC2.^2;

power_loss=params.R1*i1.^2+params.R2*i2.^2;

metrics.energy_R=zeros(size(t));
for k = 2:length(t)
    metrics.energy_R(k)=metrics.energy_R(k-1)+trapezoidalIntegration(t(k-1:k),power_loss(k-1:k));
end
metrics.energy_total=metrics.energy_L+metrics.energy_C;
metrics.max_energy=max(metrics.energy_total);
metrics.total_energy_dissipated=metrics.energy_R(end);
metrics.energy_balance_error=abs(metrics.max_energy-metrics.energy_total(end)-metrics.energy_R(end));
end