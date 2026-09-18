function RLCGUI

    projectDir=fileparts(mfilename('fullpath'));
    if ~isempty(projectDir)
        addpath(projectDir);
    end

    fig=figure('Name','Magnetically Coupled RLC Transient Simulator', 'NumberTitle','off', ...
        'MenuBar','none', 'ToolBar','figure', 'Units','normalized', ...
        'Position',[0.04 0.055 0.92 0.87], 'Color',[0.94 0.94 0.94], 'Resize','on');

    uicontrol(fig,'Style','text', 'Units','normalized','Position',[0.01 0.955 0.98 0.035], ...
        'String','MAGNETICALLY COUPLED RLC TRANSIENT SIMULATOR', 'FontSize',14,'FontWeight','bold', ...
        'BackgroundColor',get(fig,'Color'));

    leftPanel=uipanel(fig,'Title','Simulation Inputs','FontWeight','bold', 'Units','normalized', ...
        'Position',[0.015 0.03 0.27 0.94]);

    axCurrent=axes('Parent',fig, 'Units','normalized', 'Position',[0.355 0.57 0.60 0.30]);
    grid(axCurrent,'on');
    title(axCurrent,'Transient Current Response');
    xlabel(axCurrent,'Time (s)');
    ylabel(axCurrent,'Current (A)');

    axVoltage=axes('Parent',fig,'Units','normalized', 'Position',[0.355 0.18 0.60 0.30]);
    grid(axVoltage,'on');
    title(axVoltage,'Capacitor Voltage Response');
    xlabel(axVoltage,'Time (s)');
    ylabel(axVoltage,'Voltage (V)');

    axSource=axes('Parent',fig, 'Units','normalized','Position',[0.355 0.53 0.60 0.12],'Visible','off');

    lastSourceTime=[];
    lastSource1=[];

    statusText=uicontrol(fig,'Style','text','Units','normalized','Position',[0.355 0.025 0.60 0.045], ...
        'HorizontalAlignment','left','String','Status: Ready','FontWeight','bold','BackgroundColor',get(fig,'Color'));

    circuitPanel=uipanel(leftPanel,'Title','Circuit Parameters (SI Units)', 'FontWeight','bold','Units','normalized', ...
        'Position',[0.035 0.69 0.93 0.27]);

    h.R1=makeEdit(circuitPanel,'R1 (ohm)', '10',  0.82, []);
    h.R2=makeEdit(circuitPanel,'R2 (ohm)', '10', 0.68, []);
    h.L1=makeEdit(circuitPanel,'L1 (H)','0.01', 0.54, @updateMutualDisplay);
    h.L2=makeEdit(circuitPanel,'L2 (H)','0.01', 0.40, @updateMutualDisplay);
    h.C1=makeEdit(circuitPanel,'C1 (F)','0.0001',0.26, []);
    h.C2=makeEdit(circuitPanel,'C2 (F)','0.0001',0.12, []);

    uicontrol(circuitPanel,'Style','text', 'Units','normalized','Position',[0.04 0.005 0.08 0.10],'String','k','HorizontalAlignment','left', ...
        'BackgroundColor',get(circuitPanel,'BackgroundColor'));
    h.k=uicontrol(circuitPanel,'Style','edit', 'Units','normalized','Position',[0.11 0.015 0.14 0.10], ...
        'String','0.5','BackgroundColor','white','Callback',@updateMutualDisplay);

    uicontrol(circuitPanel,'Style','text','Units','normalized','Position',[0.28 0.005 0.15 0.10], ...
        'String','Polarity','HorizontalAlignment','left', 'BackgroundColor',get(circuitPanel,'BackgroundColor'));
    h.polarity=uicontrol(circuitPanel,'Style','popupmenu','Units','normalized','Position',[0.42 0.015 0.26 0.11], ...
        'String',{'Aiding (+1)','Opposing (-1)'},'Value',1,'BackgroundColor','white', ...
        'Callback',@updateMutualDisplay);

    uicontrol(circuitPanel,'Style','text','Units','normalized','Position',[0.70 0.005 0.10 0.10],'String','M (H)','HorizontalAlignment','left', ...
        'BackgroundColor',get(circuitPanel,'BackgroundColor'));
    h.M=uicontrol(circuitPanel,'Style','edit', 'Units','normalized','Position',[0.80 0.015 0.16 0.10], ...
        'String','','Enable','inactive','BackgroundColor',[0.92 0.92 0.92]);
    h.parameterSweepButton=uicontrol(leftPanel,'Style','pushbutton', 'Units','normalized',...
        'Position',[0.06 0.655 0.40 0.03],'String','PARAMETER SWEEP','FontSize',8,'Callback',@parameterSweepGUI);

    h.metricsButton=uicontrol(leftPanel,'Style','pushbutton','Units','normalized',...
        'Position',[0.50 0.655 0.28 0.03],'String','METRICS','FontSize',8,'Callback',@calculateMetricsGUI);
    initPanel=uipanel(leftPanel,'Title','Initial Conditions', 'FontWeight','bold','Units','normalized', ...
        'Position',[0.035 0.49 0.93 0.15]);
    h.i10=makeEdit2Col(initPanel,'i1(0) A','0', 0.60, 0.04);
    h.i20=makeEdit2Col(initPanel,'i2(0) A','0', 0.60, 0.52);
    h.vC10=makeEdit2Col(initPanel,'vC1(0) V','0',0.16, 0.04);
    h.vC20=makeEdit2Col(initPanel,'vC2(0) V','0',0.16, 0.52);
    sourcePanel=uipanel(leftPanel, 'Title','Source 1', 'FontWeight','bold', 'Units','normalized', ...
        'Position',[0.035 0.255 0.93 0.22]);
uicontrol(sourcePanel,'Style','text', 'Units','normalized','Position',[0.04 0.77 0.28 0.13], ...
        'String','Type','HorizontalAlignment','left', 'BackgroundColor',get(sourcePanel,'BackgroundColor'));
    h.sourceType=uicontrol(sourcePanel,'Style','popupmenu', 'Units','normalized','Position',[0.32 0.78 0.62 0.14], ...
        'String',{'none','step','sine','pulse'}, 'Value',2,'BackgroundColor','white','Callback',@sourceTypeChanged);
    h.sourceAmp=makeEdit2Col(sourcePanel,'Amplitude (V)','10',0.51,0.04);
    h.sourceFreq=makeEdit2Col(sourcePanel,'Frequency (Hz)','100',0.51,0.52);
    h.sourcePhase=makeEdit2Col(sourcePanel,'Phase (deg)','0',0.13,0.04);
    h.sourceDuty=makeEdit2Col(sourcePanel,'Duty (0-1)','0.5',0.13,0.52);
    uicontrol(sourcePanel,'Style','text', 'Units','normalized','Position',[0.04 0.00 0.28 0.11], ...
        'String','Start time (s)','HorizontalAlignment','left','BackgroundColor',get(sourcePanel,'BackgroundColor'));
    h.sourceStart=uicontrol(sourcePanel,'Style','edit', ...
        'Units','normalized','Position',[0.32 0.015 0.22 0.11], ...
        'String','0','BackgroundColor','white');
    h.showSource=uicontrol(sourcePanel,'Style','checkbox', ...
        'Units','normalized','Position',[0.58 0.005 0.38 0.13], 'String','Show Input Source Waveform', ...
        'Value',0,'BackgroundColor',get(sourcePanel,'BackgroundColor'),'Callback',@toggleSourceWaveform);
simPanel=uipanel(leftPanel,'Title','Simulation Settings','FontWeight','bold','Units','normalized', ...
        'Position',[0.035 0.025 0.93 0.215]);
uicontrol(simPanel,'Style','text','Units','normalized','Position',[0.04 0.75 0.28 0.14], ...
        'String','Solver','HorizontalAlignment','left', 'BackgroundColor',get(simPanel,'BackgroundColor'));
h.solver=uicontrol(simPanel,'Style','popupmenu', 'Units','normalized','Position',[0.32 0.76 0.62 0.15], ...
        'String',{'Euler','RK4','ode45'},'Value',2,'BackgroundColor','white');

    h.dt=makeEdit2Col(simPanel,'dt (s)','1e-5',0.47,0.04);
    h.tEnd=makeEdit2Col(simPanel,'tEnd (s)','0.05',0.47,0.52);
    h.runButton=uicontrol(simPanel,'Style','pushbutton','Units','normalized', ...
        'Position',[0.03 0.05 0.21 0.18], 'String','RUN','FontWeight','bold', 'Callback',@runSimulation);
    h.compareButton=uicontrol(simPanel,'Style','pushbutton','Units','normalized','Position',[0.51 0.05 0.21 0.18], ...
        'String','COMPARE SOLVERS','FontWeight','bold','Callback',@compareSolvers);
    h.energyButton=uicontrol(simPanel,'Style','pushbutton', 'Units','normalized','Position',[0.27 0.05 0.21 0.18], ...
        'String','ENERGY ANALYSIS','FontWeight','bold','Callback',@energyAnalysis);
    h.resetButton=uicontrol(simPanel,'Style','pushbutton','Units','normalized','Position',[0.75 0.05 0.21 0.18], ...
        'String','RESET','Callback',@resetGUI);
    sourceTypeChanged();
    updateMutualDisplay();
    function editHandle=makeEdit(parent,labelText,defaultValue,y,callbackFcn)
        uicontrol(parent,'Style','text','Units','normalized','Position',[0.04 y 0.28 0.075],'String',labelText,'HorizontalAlignment','left', ...
            'BackgroundColor',get(parent,'BackgroundColor'));
        editHandle=uicontrol(parent,'Style','edit', ...
            'Units','normalized','Position',[0.32 y+0.01 0.62 0.075],'String',defaultValue,'BackgroundColor','white');
        if ~isempty(callbackFcn)
            set(editHandle,'Callback',callbackFcn);
        end
    end

    function editHandle=makeEdit2Col(parent,labelText,defaultValue,y,x0)
        uicontrol(parent,'Style','text', ...
            'Units','normalized','Position',[x0 y 0.27 0.15], ...
            'String',labelText,'HorizontalAlignment','left', ...
            'BackgroundColor',get(parent,'BackgroundColor'));
        editHandle=uicontrol(parent,'Style','edit', ...
            'Units','normalized','Position',[x0+0.27 y+0.01 0.17 0.16], ...
            'String',defaultValue,'BackgroundColor','white');
    end

    function val=readNumber(editHandle,fieldName)
        val=str2double(get(editHandle,'String'));
        if ~isscalar(val) || ~isfinite(val)
            error('%s must be a finite numeric value.',fieldName);
        end
    end

    function p=getPolarity()
        if get(h.polarity,'Value') == 1
            p=1;
        else
            p=-1;
        end
    end

    function params=getCircuitParameters()
        params.R1=readNumber(h.R1,'R1');
        params.R2=readNumber(h.R2,'R2');
        params.L1=readNumber(h.L1,'L1');
        params.L2=readNumber(h.L2,'L2');
        params.C1=readNumber(h.C1,'C1');
        params.C2=readNumber(h.C2,'C2');
        params.k=readNumber(h.k,'k');
        params.p=getPolarity();

        [params.M,params.Delta]=calculateMutualInductance( ...
            params.L1,params.L2,params.k,params.p);
    end

    function sim=getSimulationSettings()
        sim.dt=readNumber(h.dt,'dt');
        sim.tEnd=readNumber(h.tEnd,'tEnd');

        solverItems=get(h.solver,'String');
        sim.solver=solverItems{get(h.solver,'Value')};
    end

    function source1=getSource1()
        sourceItems=get(h.sourceType,'String');
        source1.type=sourceItems{get(h.sourceType,'Value')};

        switch source1.type
            case 'none'

            case 'step'
                source1.V0=readNumber(h.sourceAmp,'Source amplitude');
                source1.tstart=readNumber(h.sourceStart,'Source start time');

            case 'sine'
                source1.Vm=readNumber(h.sourceAmp,'Source amplitude');
                source1.f=readNumber(h.sourceFreq,'Source frequency');
                source1.phase=readNumber(h.sourcePhase,'Source phase');

            case 'pulse'
                source1.V0=readNumber(h.sourceAmp,'Source amplitude');
                source1.f=readNumber(h.sourceFreq,'Source frequency');
                source1.duty=readNumber(h.sourceDuty,'Pulse duty cycle');
                source1.tstart=readNumber(h.sourceStart,'Source start time');
        end
    end

    function source2=getSource2()
        source2.type='none';
    end

    function x0=getInitialConditions()
        x0=[ ...
            readNumber(h.i10,'i1(0)'); ...
            readNumber(h.i20,'i2(0)'); ...
            readNumber(h.vC10,'vC1(0)'); ...
            readNumber(h.vC20,'vC2(0)')];
    end

    function validateInputs(params,sim,source1)
        if params.R1 < 0 || params.R2 < 0
            error('R1 and R2 cannot be negative.');
        end
        if params.L1 <= 0 || params.L2 <= 0
            error('L1 and L2 must be greater than zero.');
        end
        if params.C1 <= 0 || params.C2 <= 0
            error('C1 and C2 must be greater than zero.');
        end
        if params.k < 0 || params.k >= 1
            error('Coupling coefficient k must satisfy 0 <= k < 1.');
        end
        if params.p ~= 1 && params.p ~= -1
            error('Polarity must be +1 or -1.');
        end
        if sim.dt <= 0
            error('Time step dt must be greater than zero.');
        end
        if sim.tEnd <= 0
            error('Simulation end time must be greater than zero.');
        end
        if sim.dt >= sim.tEnd
            error('dt must be smaller than tEnd.');
        end

        switch source1.type
            case 'sine'
                if source1.f <= 0
                    error('Sine-source frequency must be greater than zero.');
                end
            case 'pulse'
                if source1.f <= 0
                    error('Pulse-source frequency must be greater than zero.');
                end
                if source1.duty < 0 || source1.duty > 1
                    error('Pulse duty cycle must satisfy 0 <= duty <= 1.');
                end
        end
    end

    function [t,x]=runSolver(params,sim,source1,source2,x0)
        switch lower(sim.solver)
            case 'euler'
                [t,x]=eulerSolver(params,sim,source1,source2,x0);

            case 'rk4'
                [t,x]=rk4Solver(params,sim,source1,source2,x0);

            case 'ode45'
                f=@(tt,xx) coupledRLC_derivative( ...
                    tt,xx,params,source1,source2);
                tspan=(0:sim.dt:sim.tEnd).';
                [t,x]=ode45(f,tspan,x0(:));

            otherwise
                error('Unknown numerical solver: %s',sim.solver);
        end
    end

    function runSimulation(varargin)
        try
            set(statusText,'String','Status: Running simulation...');
            drawnow;

            params=getCircuitParameters();
            sim=getSimulationSettings();
            source1=getSource1();
            source2=getSource2();
            x0=getInitialConditions();

            validateInputs(params,sim,source1);
            set(h.M,'String',sprintf('%.6g',params.M));

            [t,x]=runSolver(params,sim,source1,source2,x0);

            lastSourceTime=t;
            lastSource1=source1;

            plotMainResults(t,x);
            updateSourceWaveformPlot();

            if params.p == 1
                polarityName='Aiding';
            else
                polarityName='Opposing';
            end

            status=sprintf(['Status: Completed | Solver: %s | %s coupling | ' ...
                'M=%.4g H | Peak |i1|=%.4g A | Peak |i2|=%.4g A'], ...
                sim.solver,polarityName,params.M, ...
                max(abs(x(:,1))),max(abs(x(:,2))));
            set(statusText,'String',status);

        catch ME
            set(statusText,'String','Status: Simulation failed.');
            errordlg(ME.message,'Simulation Error','modal');
        end
    end

    function plotMainResults(t,x)
        i1=x(:,1);
        i2=x(:,2);
        vC1=x(:,3);
        vC2=x(:,4);

        cla(axCurrent);
        p1=plot(axCurrent,t,i1,'LineWidth',1.2);
        hold(axCurrent,'on');
        p2=plot(axCurrent,t,i2,'LineWidth',1.2);
        hold(axCurrent,'off');
        grid(axCurrent,'on');
        xlabel(axCurrent,'Time (s)');
        ylabel(axCurrent,'Current (A)');
        title(axCurrent,'Transient Current Response');
        legend(axCurrent,[p1 p2],{'i_1','i_2'},'Location','best');

        cla(axVoltage);
        p3=plot(axVoltage,t,vC1,'LineWidth',1.2);
        hold(axVoltage,'on');
        p4=plot(axVoltage,t,vC2,'LineWidth',1.2);
        hold(axVoltage,'off');
        grid(axVoltage,'on');
        xlabel(axVoltage,'Time (s)');
        ylabel(axVoltage,'Voltage (V)');
        title(axVoltage,'Capacitor Voltage Response');
        legend(axVoltage,[p3 p4],{'V_{C1}','V_{C2}'},'Location','best');
    end

    function toggleSourceWaveform(varargin)
        showWaveform=get(h.showSource,'Value') == 1;

        if showWaveform
            set(axSource,'Position',[0.355 0.685 0.60 0.215], ...
                'Visible','on');
            set(axCurrent,'Position',[0.355 0.405 0.60 0.215]);
            set(axVoltage,'Position',[0.355 0.125 0.60 0.215]);
            updateSourceWaveformPlot();
        else
            set(axSource,'Visible','off');
            set(axCurrent,'Position',[0.355 0.56 0.60 0.36]);
            set(axVoltage,'Position',[0.355 0.105 0.60 0.36]);
        end
    end

    function updateSourceWaveformPlot()
        if get(h.showSource,'Value') ~= 1
            set(axSource,'Visible','off');
            return;
        end

        try
            if ~isempty(lastSourceTime) && ~isempty(lastSource1)
                tSource=lastSourceTime;
                sourceToPlot=lastSource1;
            else
                simPreview=getSimulationSettings();
                sourceToPlot=getSource1();
                tSource=(0:simPreview.dt:simPreview.tEnd).';
            end

            Vs1=sourceVoltage(tSource,sourceToPlot);

            cla(axSource);
            plot(axSource,tSource,Vs1,'LineWidth',1.2);
            grid(axSource,'on');
            xlabel(axSource,'Time (s)');
            ylabel(axSource,'V_{s1} (V)');
            title(axSource,'Input Source 1 Waveform');
            set(axSource,'Visible','on');

        catch ME
            cla(axSource);
            set(axSource,'Visible','on');
            title(axSource,'Input Source 1 Waveform');
            xlabel(axSource,'Time (s)');
            ylabel(axSource,'V_{s1} (V)');
            text(axSource,0.5,0.5,['Unable to display source: ' ME.message], ...
                'Units','normalized','HorizontalAlignment','center');
        end
    end

    function energyAnalysis(varargin)
        try
            params=getCircuitParameters();
            sim=getSimulationSettings();
            source1=getSource1();
            source2=getSource2();
            x0=getInitialConditions();

            validateInputs(params,sim,source1);
            [t,x]=runSolver(params,sim,source1,source2,x0);

            i1=x(:,1);
            i2=x(:,2);
            vC1=x(:,3);
            vC2=x(:,4);

            M=params.M;
            E_C=0.5*params.C1*(vC1.^2) + 0.5*params.C2*(vC2.^2);
            E_L=0.5*params.L1*(i1.^2) + 0.5*params.L2*(i2.^2) + M.*(i1.*i2);
            E_total=E_C + E_L;

            eFig=figure('Name','Energy Analysis','NumberTitle','off',...
                'Units','normalized','Position',[0.15 0.15 0.7 0.65]);

            ax=axes('Parent',eFig,'Position',[0.1 0.15 0.82 0.75]);
            plot(ax,t,E_L,'LineWidth',1.2);
            hold(ax,'on');
            plot(ax,t,E_C,'LineWidth',1.2);
            plot(ax,t,E_total,'LineWidth',1.5);
            hold(ax,'off');
            grid(ax,'on');
            xlabel(ax,'Time (s)');
            ylabel(ax,'Energy (J)');
            title(ax,'Stored Energy in Coupled RLC Network');
            legend(ax,{'Magnetic Energy','Capacitor Energy','Total Energy'},'Location','best');

            set(statusText,'String','Status: Energy analysis completed.');

        catch ME
            errordlg(ME.message,'Energy Analysis Error','modal');
        end
    end

    function compareSolvers(varargin)
        try
            set(statusText,'String','Status: Comparing Euler, RK4 and ode45...');
            drawnow;

            params=getCircuitParameters();
            sim=getSimulationSettings();
            source1=getSource1();
            source2=getSource2();
            x0=getInitialConditions();

            validateInputs(params,sim,source1);
            set(h.M,'String',sprintf('%.6g',params.M));

            results=solverComparison(params,sim,source1,source2,x0);
            showComparisonFigure(results);

            status=sprintf(['Status: Comparison complete | Euler max rel. error=%.3e | ' ...
                'RK4 max rel. error=%.3e'], ...
                results.maxRelErr_euler,results.maxRelErr_rk4);
            set(statusText,'String',status);

        catch ME
            set(statusText,'String','Status: Solver comparison failed.');
            errordlg(ME.message,'Solver Comparison Error','modal');
        end
    end

    function showComparisonFigure(results)
        cmpFig=figure( ...
            'Name','Solver Comparison - Euler vs RK4 vs ode45', ...
            'NumberTitle','off', ...
            'MenuBar','none', ...
            'ToolBar','figure', ...
            'Units','normalized', ...
            'Position',[0.10 0.08 0.80 0.80], ...
            'Color',[0.94 0.94 0.94]);

        uicontrol(cmpFig,'Style','text', ...
            'Units','normalized', ...
            'Position',[0.05 0.94 0.90 0.04], ...
            'String','SOLVER COMPARISON: Euler and RK4 relative to ode45', ...
            'FontSize',12,'FontWeight','bold', ...
            'BackgroundColor',get(cmpFig,'Color'));

        labels={'i_1 (A)','i_2 (A)','V_{C1} (V)','V_{C2} (V)'};
        titles={'Primary Current i_1','Secondary Current i_2', ...
                  'Capacitor Voltage V_{C1}','Capacitor Voltage V_{C2}'};
        positions=[0.08 0.57 0.38 0.31; ...
                     0.55 0.57 0.38 0.31; ...
                     0.08 0.19 0.38 0.31; ...
                     0.55 0.19 0.38 0.31];

        for stateIndex=1:4
            ax=axes('Parent',cmpFig,'Units','normalized', ...
                'Position',positions(stateIndex,:));
            plot(ax,results.t,results.x_euler(:,stateIndex),'LineWidth',1.0);
            hold(ax,'on');
            plot(ax,results.t,results.x_rk4(:,stateIndex),'LineWidth',1.0);
            plot(ax,results.t,results.x_ode45(:,stateIndex),'LineWidth',1.0);
            hold(ax,'off');
            grid(ax,'on');
            xlabel(ax,'Time (s)');
            ylabel(ax,labels{stateIndex});
            title(ax,titles{stateIndex});
            legend(ax,{'Euler','RK4','ode45'},'Location','best');
        end

        tableData={ ...
            'Euler', sprintf('%.4e',results.maxRelErr_euler), results.time_euler; ...
            'RK4',   sprintf('%.4e',results.maxRelErr_rk4),   results.time_rk4; ...
            'ode45', 'Reference',                            results.time_ode45};

        uitable('Parent',cmpFig, ...
            'Units','normalized', ...
            'Position',[0.19 0.025 0.62 0.105], ...
            'Data',tableData, ...
            'ColumnName',{'Solver','Max Relative Error','Execution Time (s)'}, ...
            'RowName',[]);
    end

    function sourceTypeChanged(varargin)
        sourceItems=get(h.sourceType,'String');
        sourceType=sourceItems{get(h.sourceType,'Value')};

        set([h.sourceAmp h.sourceFreq h.sourcePhase h.sourceDuty h.sourceStart], ...
            'Enable','off');

        switch sourceType
            case 'none'
            case 'step'
                set([h.sourceAmp h.sourceStart],'Enable','on');
            case 'sine'
                set([h.sourceAmp h.sourceFreq h.sourcePhase],'Enable','on');
            case 'pulse'
                set([h.sourceAmp h.sourceFreq h.sourceDuty h.sourceStart], ...
                    'Enable','on');
        end

        lastSourceTime=[];
        lastSource1=[];
        if isfield(h,'showSource') && get(h.showSource,'Value') == 1
            updateSourceWaveformPlot();
        end
    end

    function updateMutualDisplay(varargin)
        try
            L1=readNumber(h.L1,'L1');
            L2=readNumber(h.L2,'L2');
            k=readNumber(h.k,'k');
            p=getPolarity();
            [M,~]=calculateMutualInductance(L1,L2,k,p);
            set(h.M,'String',sprintf('%.6g',M));
        catch
            set(h.M,'String','Invalid');
        end
    end

    function resetGUI(varargin)
        set(h.R1,'String','10');
        set(h.R2,'String','10');
        set(h.L1,'String','0.01');
        set(h.L2,'String','0.01');
        set(h.C1,'String','0.0001');
        set(h.C2,'String','0.0001');
        set(h.k,'String','0.5');
        set(h.polarity,'Value',1);

        set(h.i10,'String','0');
        set(h.i20,'String','0');
        set(h.vC10,'String','0');
        set(h.vC20,'String','0');

        set(h.sourceType,'Value',2);
        set(h.sourceAmp,'String','10');
        set(h.sourceFreq,'String','100');
        set(h.sourcePhase,'String','0');
        set(h.sourceDuty,'String','0.5');
        set(h.sourceStart,'String','0');

        set(h.solver,'Value',2);
        set(h.dt,'String','1e-5');
        set(h.tEnd,'String','0.05');
        set(h.showSource,'Value',0);

        lastSourceTime=[];
        lastSource1=[];
        cla(axSource);
        set(axSource,'Visible','off');
        set(axCurrent,'Position',[0.355 0.56 0.60 0.36]);
        set(axVoltage,'Position',[0.355 0.105 0.60 0.36]);

        cla(axCurrent);
        grid(axCurrent,'on');
        title(axCurrent,'Transient Current Response');
        xlabel(axCurrent,'Time (s)');
        ylabel(axCurrent,'Current (A)');

        cla(axVoltage);
        grid(axVoltage,'on');
        title(axVoltage,'Capacitor Voltage Response');
        xlabel(axVoltage,'Time (s)');
        ylabel(axVoltage,'Voltage (V)');

        sourceTypeChanged();
        updateMutualDisplay();
        set(statusText,'String','Status: Ready');
    end

    function parameterSweepGUI(varargin)
        try
            params=getCircuitParameters();
            sim=getSimulationSettings();
            source1=getSource1();
            source2=getSource2();
            x0=getInitialConditions();

            validateInputs(params,sim,source1);

            paramList={'k','R1','R2','L1','L2','C1','C2'};
            [selIdx,ok]=listdlg( ...
                'ListString',paramList, ...
                'SelectionMode','single', ...
                'PromptString','Select parameter to sweep:', ...
                'Name','Parameter Sweep', ...
                'ListSize',[220 150]);
            if ~ok
                return;
            end
            parameter=paramList{selIdx};
            currentVal=params.(parameter);

            prompt={'Start value:','End value:','Number of points:'};
            dlgTitle=sprintf('Sweep range for %s (current=%.6g)',parameter,currentVal);
            defaultAns={num2str(0.5*currentVal),num2str(1.5*currentVal),'10'};
            answer=inputdlg(prompt,dlgTitle,[1 45],defaultAns);
            if isempty(answer)
                return;
            end

            startVal=str2double(answer{1});
            endVal=str2double(answer{2});
            nPoints=round(str2double(answer{3}));

            if ~isfinite(startVal) || ~isfinite(endVal)
                error('Sweep start and end values must be finite numbers.');
            end
            if ~isfinite(nPoints) || nPoints < 2
                error('Number of points must be an integer of at least 2.');
            end
            if any(strcmp(parameter,{'k'})) && (startVal < 0 || endVal >= 1)
                error('Coupling coefficient k must stay within 0 <= k < 1.');
            end
            if any(strcmp(parameter,{'R1','R2'})) && (startVal < 0 || endVal < 0)
                error('Resistance values cannot be negative.');
            end
            if any(strcmp(parameter,{'L1','L2','C1','C2'})) && (startVal <= 0 || endVal <= 0)
                error('%s must stay strictly positive over the sweep range.',parameter);
            end

            values=linspace(startVal,endVal,nPoints);

            set(statusText,'String',sprintf('Status: Running parameter sweep on %s...',parameter));
            drawnow;

            results=parameterSweep(params,sim,source1,source2,x0,parameter,values);

            showParameterSweepFigure(results,parameter);

            set(statusText,'String', ...
                sprintf('Status: Parameter sweep on %s completed (%d points).',parameter,nPoints));

        catch ME
            set(statusText,'String','Status: Parameter sweep failed.');
            errordlg(ME.message,'Parameter Sweep Error','modal');
        end
    end

    function showParameterSweepFigure(results,parameter)
        swFig=figure( ...
            'Name',sprintf('Parameter Sweep - %s',parameter), ...
            'NumberTitle','off', ...
            'MenuBar','none', ...
            'ToolBar','figure', ...
            'Units','normalized', ...
            'Position',[0.15 0.12 0.62 0.72], ...
            'Color',[0.94 0.94 0.94]);

        uicontrol(swFig,'Style','text', ...
            'Units','normalized', ...
            'Position',[0.05 0.94 0.90 0.045], ...
            'String',sprintf('PARAMETER SWEEP: %s',upper(parameter)), ...
            'FontSize',12,'FontWeight','bold', ...
            'BackgroundColor',get(swFig,'Color'));

        ax1=axes('Parent',swFig,'Units','normalized', ...
            'Position',[0.10 0.56 0.85 0.34]);
        plot(ax1,results.parameter,results.peakCurrent,'-o', ...
            'LineWidth',1.2,'MarkerFaceColor','auto');
        grid(ax1,'on');
        xlabel(ax1,parameter);
        ylabel(ax1,'Peak |i_2| (A)');
        title(ax1,sprintf('Peak Secondary Current vs %s',parameter));

        ax2=axes('Parent',swFig,'Units','normalized', ...
            'Position',[0.10 0.10 0.85 0.34]);
        plot(ax2,results.parameter,results.peakVoltage,'-o', ...
            'LineWidth',1.2,'Color',[0.85 0.33 0.10]);
        grid(ax2,'on');
        xlabel(ax2,parameter);
        ylabel(ax2,'Peak V_{C2} (V)');
        title(ax2,sprintf('Peak Secondary Capacitor Voltage vs %s',parameter));
    end

    function calculateMetricsGUI(varargin)
        try
            set(statusText,'String','Status: Calculating metrics...');
            drawnow;
            params=getCircuitParameters();
            sim=getSimulationSettings();
            source1=getSource1();
            source2=getSource2();
            x0=getInitialConditions();
            validateInputs(params,sim,source1);

            [t,x]=runSolver(params,sim,source1,source2,x0);
            metrics=calculateMetrics(t,x,params);

            msg=sprintf([ ...
                'Peak i1=%.4f A\n' ...
                'Peak i2=%.4f A\n' ...
                'Peak VC1=%.4f V\n' ...
                'Peak VC2=%.4f V\n\n' ...
                'Final i1=%.4f A\n' ...
                'Final i2=%.4f A\n\n' ...
                'Max Stored Energy=%.6f J\n' ...
                'Total Energy Dissipated=%.6f J\n' ...
                'Energy Balance Error=%.3e J'], ...
                metrics.peak_i1,metrics.peak_i2, ...
                metrics.peak_vC1,metrics.peak_vC2, ...
                metrics.final_i1,metrics.final_i2, ...
                metrics.max_energy, ...
                metrics.total_energy_dissipated, ...
                metrics.energy_balance_error);
            msgbox(msg,'Metrics');
            set(statusText,'String','Status: Metrics calculated.');
        catch ME
            set(statusText,'String','Status: Metrics calculation failed.');
            errordlg(ME.message,'Metrics Error','modal');
        end
    end

end