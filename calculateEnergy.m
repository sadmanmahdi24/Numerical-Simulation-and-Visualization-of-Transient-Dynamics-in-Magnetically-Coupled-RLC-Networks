function [E_total,E_L,E_C]=calculateEnergy(params,i1,i2,vC1,vC2)
M=calculateMutualInductance(params);
E_C=0.5*params.C1*(vC1.^2)+0.5*params.C2*(vC2.^2);
E_L=0.5*params.L1*(i1.^2)+0.5*params.L2*(i2.^2)+M.*(i1.*i2);
E_total=E_C+E_L;
end