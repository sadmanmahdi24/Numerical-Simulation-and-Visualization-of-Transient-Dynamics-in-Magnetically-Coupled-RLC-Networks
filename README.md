# Numerical-Simulation-and-Visualization-of-Transient-Dynamics-in-Magnetically-Coupled-RLC-Networks
A MATLAB toolkit and GUI for simulating, analyzing, and visualizing the transient dynamics of two magnetically coupled series RLC circuits. Built for EEE 212 (Numerical Technique Laboratory) at BUET.
# Magnetically Coupled RLC Transient Simulator

A MATLAB toolkit and GUI for simulating, analyzing, and visualizing the transient dynamics of two magnetically coupled series RLC circuits. Built for **EEE 212 (Numerical Technique Laboratory)** at BUET.

## Overview

Two RLC loops interact through a mutual inductance `M = k*sqrt(L1*L2)`. The system is modeled as a 4-state ODE (`i1`, `i2`, `vC1`, `vC2`), solved numerically, and explored through an interactive GUI.

## Features

- **State-space circuit model** with matrix-based coupled inductor solving (`Lmat \ rhs`)
- **Custom Euler and RK4 solvers**, validated against MATLAB's `ode45`
- **Solver comparison** — accuracy and runtime of Euler vs. RK4 vs. ode45
- **Convergence study** — error vs. step size across multiple `dt` values
- **Energy analysis** — magnetic, capacitive, and dissipated (resistive) energy, with an energy-balance check
- **Parameter sweep** — study sensitivity to `k`, `R1`, `R2`, `L1`, `L2`, `C1`, `C2`
- **Configurable source types** — step, sinusoidal, and pulse excitation
- **Interactive GUI** (`RLCGUI.m`) for circuit setup, simulation, metrics, and plotting — no code editing required

## Project Structure

| File | Purpose |
|---|---|
| `main.m` | Scripted example run (no GUI) |
| `runCoupledRLC.m` | Entry point — runs `main.m` then launches the GUI |
| `RLCGUI.m` | Full interactive GUI |
| `coupledRLC_derivative.m` | State-derivative function (the ODE right-hand side) |
| `calculateMutualInductance.m` | Computes `M` and `Delta = L1*L2 - M^2` from `k` |
| `sourceVoltage.m` | Step / sine / pulse source waveform generator |
| `eulerSolver.m` / `rk4Solver.m` | Manually implemented fixed-step ODE solvers |
| `solverComparison.m` | Compares Euler, RK4, and `ode45` |
| `convergenceStudy.m` | Step-size convergence analysis |
| `parameterSweep.m` | Sweeps a chosen circuit parameter |
| `calculateEnergy.m` / `calculateMetrics.m` | Energy and performance metrics |
| `trapezoidalIntegration.m` | Numerical integration for dissipated energy |
| `numericalDerivative.m` | Central-difference derivative estimator |
| `newtonInterpolation.m` | Newton's divided-difference interpolation |

## Getting Started

```matlab
runCoupledRLC
```

This runs a default step-response simulation and opens the GUI, where you can adjust circuit parameters, source type, solver, and time step, then run simulations, compare solvers, sweep parameters, and view energy plots.

## Governing Equations

```
L1 di1/dt + M di2/dt + R1 i1 + vC1 = Vs1(t)
M di1/dt + L2 di2/dt + R2 i2 + vC2 = Vs2(t)
dvC1/dt = i1/C1
dvC2/dt = i2/C2
```

solved at each RK4 stage via:

```
[L1 M; M L2] \ [Vs1 - R1*i1 - vC1; Vs2 - R2*i2 - vC2]
```

## Course Context

Developed as a numerical-methods project connecting linear algebra, ODE solvers (Euler/RK4), numerical integration/differentiation, and convergence analysis to a practical electrical-engineering system (transformers, resonant converters, wireless power transfer, coupled filters).

## Authors

Md. Sabir Hossain, Sadman Mahdi, Tasnim Karim — Dept. of EEE, BUET
