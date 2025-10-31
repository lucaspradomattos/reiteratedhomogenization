%% MAIN SCRIPT for 3D EFFECTIVE THERMAL CONDUCTIVITY CALCULATION
%
% Author: Lucas Prado Mattos
% Description: This script implements the Finite Element Method (FEM)
% to solve the "cell problem" for a 3D periodic unit cell (PUC)
% based on the theory of reiterated homogenization.
%
% Last updated: 2025-10-31
%
% *** CITATION ***
% If you use this code in your research, please cite the following paper:
%
% Mattos, L. P., Cruz, M. E., & Bravo-Castillero, J. (2018).
% Finite element computation of the effective thermal conductivity of
% two-dimensional multi-scale heterogeneous media.
% Engineering Computations, 35(5), 2107-2123.
% https://doi.org/10.1108/EC-11-2017-0444
%
% BibTeX Entry:
% @article{Mattos2018EC,
%   author   = {Lucas Prado Mattos and Manuel Ernani Cruz and Juli{\'a}n Bravo-Castillero},
%   title    = {Finite element computation of the effective thermal conductivity of two-dimensional multi-scale heterogeneous media},
%   journal  = {Engineering Computations},
%   volume   = {35},
%   number   = {5},
%   pages    = {2107-2123},
%   year     = {2018},
%   doi      = {10.1108/EC-11-2017-0444}
% }
%
% -------------------------------------------------------------------------
% Based on the Doctoral Thesis:
% "A COMPUTATIONAL APPROACH OF REITERATED HOMOGENIZATION APPLIED TO
% THREE-DIMENSIONAL HEAT CONDUCTION IN MATERIALS WITH MULTIPLE SCALES"
% -------------------------------------------------------------------------

clear all; close all; clc

%% 1. SET INPUT PARAMETERS
% -------------------------------------------------------------------------
PHI=0.2;       % Target global volume fraction of the inclusion phase
SIGMA=100;     % Conductivity ratio (contrast): k_inclusion / k_matrix
DIRECTION=1;   % Macroscopic direction of heat flow (1, 2 or 3)

tic            % Start timer
Nnl=4;         % Number of nodes per element (linear tetrahedron)
filename=['bi_08_h_1.vol']; % Input mesh file (NETGEN .vol format)

%% 2. LOAD MESH & GEOMETRY
% -------------------------------------------------------------------------
[x,y,z,surfnr_BOOL,IEN,nel,Srf,nnp]=MyVolLoader3d(filename);
% x, y, z: Nodal coordinates
% surfnr_BOOL: Boolean vector (1=inclusion, 0=matrix)
% IEN: Element connectivity matrix
% nel: Number of elements
% nnp: Number of nodal points

%% 3. CALCULATE & ADJUST MATERIAL PHASES
% -------------------------------------------------------------------------
% Calculate initial volumes of matrix (Vc) and inclusion (Vd)
[Vc,Vd]=calcPHI3d(x,y,z,IEN,nel,surfnr_BOOL);

% Smart Phase Adjustment:
% Check if the user's target PHI is closer to the calculated matrix (Vc)
% or inclusion (Vd) volume. If it's closer to Vc (the matrix),
% invert the material definitions (surfnr_BOOL) to match the user's intent.
[val,idx]=min(abs([Vc,Vd]-PHI));
    if idx == 1
        surfnr_BOOL=~surfnr_BOOL;
        [Vc,Vd]=calcPHI3d(x,y,z,IEN,nel,surfnr_BOOL);
        fprintf('Phases adjusted. Vd (Inclusion) = %f, Vc (Matrix) = %f\n', Vd, Vc);
    end

% (Optional) Uncomment to visualize the mesh and phases
% fprintf('Plotting mesh... (This may take a moment)\n');
% plotmesh3d;
  
%% 4. IDENTIFY PERIODIC NODES (Boundary Conditions)
% -------------------------------------------------------------------------
% 4.1. Find corresponding nodes on opposing faces    
PARES=ParesCorrespondentes_linear(x,y,z,nnp);
% 4.2. Refine mapping for edges and corners (requires quadras.m)
[PARES,ndof]=quinas(x,y,z,PARES,nnp);
% 4.3. Finalize node mapping and DOF count (Script)
ReorganizarPares

%% 5. BUILD LOCATION MATRIX (LM)
% -------------------------------------------------------------------------
% This script builds the LM matrix, which maps the 4 local DOFs of
% each element to the correct global DOFs, accounting for periodicity.
MontagemMatrizLM

%% 6. ASSEMBLE GLOBAL STIFFNESS MATRIX (K) AND FORCE VECTOR (F)
% -------------------------------------------------------------------------
DIRECTION=['F' num2str(DIRECTION)];

% Assembly loop over all elements
for e=1:nel
    % 6.1. Calculate element stiffness matrix (k) and force vector (f)
    [k,f]=ElLinear(x,y,z,IEN,e,surfnr_BOOL,SIGMA,DIRECTION);
    % 6.2. Assemble element contributions into the reduced global matrices
    % This script uses 'e', 'LM', 'k', 'f' and adds them to 'K_red' and 'F'
    AssembleLinear;
end

%% 7. SOLVE THE LINEAR SYSTEM
% -------------------------------------------------------------------------
% Solve K*chi = F for the microscopic fluctuation field 'chi'
% using a preconditioned Conjugate Gradient (GC) solver.
chi=GC_red_precondicionado(F,K_red,LM,nel);

%% 8. CALCULATE EFFECTIVE CONDUCTIVITY (POST-PROCESSING)
% -------------------------------------------------------------------------
for e=1:nel
    % Calculate the contribution of this element to the total flux
    Condutividade(e)=SomatorioKElLinear(x,y,z,IEN,LM,e,chi,surfnr_BOOL,SIGMA,DIRECTION);
end

% The total effective conductivity is the sum of all element contributions
K=sum(Condutividade);

%% 9. DISPLAY RESULTS
% -------------------------------------------------------------------------
total_time = toc; % Stop timer

fprintf('==================================================\n');
fprintf('            *** COMPUTATION COMPLETE ***\n');
fprintf('==================================================\n');
fprintf('Total computation time: %.4f seconds\n', total_time);
fprintf('Inclusion Volume (Vd):  %.6f\n', Vd);
fprintf('Matrix Volume (Vc):     %.6f\n', Vc);
fprintf('Effective Conductivity in direction %d: %.6f\n', str2num(DIRECTION(2:end)), K);
fprintf('==================================================\n');

% Store final results in a single vector for function output (if used)
Keff = [K, Vd, Vc, total_time];


