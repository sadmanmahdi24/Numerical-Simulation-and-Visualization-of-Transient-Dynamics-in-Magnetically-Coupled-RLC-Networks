function Vs=sourceVoltage(t,source)
if ~isfield(source,'type')
    error('source struct must have a type field.');
end
switch source.type
    case 'none'
        Vs=zeros(size(t));
    case 'step'
        if ~isfield(source,'V0')
            error('Step source requires field V0.');
        end
        tstart=getDefault(source,'tstart',0);
        Vs=source.V0*double(t>=tstart);
    case 'sine'
        if ~isfield(source,'Vm')||~isfield(source,'f')
            error('Sine source requires fields Vm and f.');
        end
        phaseDeg=getDefault(source,'phase',0);
        phaseRad=deg2rad(phaseDeg);
        Vs=source.Vm*sin(2*pi*source.f*t+phaseRad);
    case 'pulse'
        if ~isfield(source,'V0')||~isfield(source,'f')||~isfield(source,'duty')
            error('Pulse source requires fields V0, f, and duty.');
        end
        tstart=getDefault(source,'tstart',0);
        T=1/source.f;
        tShifted=t-tstart;
        phaseInCycle=mod(tShifted,T);
        isHigh=(tShifted>=0)&(phaseInCycle<source.duty*T);
        Vs=source.V0*double(isHigh);
    otherwise
        error('Unknown source type: %s',source.type);
end
end

function val=getDefault(s,field,defaultVal)
if isfield(s,field)
    val=s.(field);
else
    val=defaultVal;
end
end