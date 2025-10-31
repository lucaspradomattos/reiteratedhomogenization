Project: 3D Effective Thermal Conductivity via Reiterated Homogenization
Author: Lucas Prado Mattos
Based on the doctoral thesis: "A COMPUTATIONAL APPROACH OF REITERATED HOMOGENIZATION APPLIED TO THREE-DIMENSIONAL HEAT CONDUCTION IN MATERIALS WITH MULTIPLE SCALES"



1. PROJECT DESCRIPTION
------------------------------------------------------------------------

This project provides a MATLAB implementation for calculating the effective thermal conductivity ($\hat{k}$) of three-dimensional (3D) multi-scale heterogeneous materials.

The code uses the Finite Element Method (FEM) to solve the local "cell problems" derived from the theory of reiterated homogenization. This approach allows for the analysis of composite materials with complex microstructures at multiple spatial scales (e.g., a "micro" scale Z and a "meso" scale Y) to determine the bulk, macroscopic thermal behavior of the material.

The scripts provided here form the computational kernel known as the "Solve Cell Problem" (SCP) or "Resolver Problema de Célula" (RPC), as detailed in the author's thesis. 


2. LOGIC FOR REITERATED HOMOGENIZATION
------------------------------------------------------------------------

This repository provides the code for the "Solve Cell Problem" (SCP) procedure, which is the core computational kernel for both conventional (two-scale) and reiterated (three-scale) homogenization.

To apply the full reiterated homogenization logic for a three-scale material (Macro X, Meso Y, Micro Z), you must run this procedure twice in a bottom-up sequence, as illustrated in Figure 1.3 of the thesis:

Step 1: First Cell Problem (Microscale Z-level)
1.  Prepare Input: Define the mesh file for the Z-level geometry (e.g., `geo_Z.vol`), the microscale volume fraction $\phi_Z$, and the base conductivity ratio $\sigma = k_d / k_c$.
2.  Run Simulation: Execute the `main.m` script with these inputs.
3.  Get Output: The result `K` is the *intermediate effective conductivity*, $k^1$.

Step 2: Second Cell Problem (Mesoscale Y-level)
1.  Prepare Input:
    * Use the mesh file for the Y-level geometry (e.g., `geo_Y.vol`).
    * Use the mesoscale volume fraction, $\phi_Y$. 
    * The "matrix" material for this problem is the homogenized material from Step 1 (with conductivity $k^1$).
    * The "inclusion" material is the original inclusion ($k_d$).
    * Therefore, the new conductivity ratio (contrast) to use as input is: $\sigma_y = k_d / k^1$.
2.  Run Simulation: Execute the `main.m` script again with this new set of inputs.
3.  Get Output: The result `K` from this second run is the final, bulk effective thermal conductivity ($\hat{k}$) for the entire multi-scale material.


3. INPUTS & OUTPUTS
------------------------------------------------------------------------

Primary Inputs (set in `main.m`):

* `PHI`: (float) The target global volume fraction of the inclusion phase (e.g., 0.2). 
* `SIGMA`: (float) The conductivity ratio (contrast) between the inclusion phase ($k_d$) and the matrix phase ($k_c$). $\sigma = k_d / k_c$ (e.g., 100). 
* `DIRECTION`: (int) The macroscopic direction of heat flow for which to calculate conductivity (1, 2, or 3). 
* `filename`: (string) The name of the 3D mesh file in NETGEN `.vol` format. This file defines the geometry of the periodic unit cell. 
    * These `.vol` files are generated using the open-source mesh generator NETGEN [1].
    * The provided example file, `bi_08_h_1.vol`, represents a periodic bilaminated cell used for validation. 
Primary Outputs (displayed in the console):

* `K`: (float) The final calculated effective thermal conductivity ($\hat{k}$) in the specified direction.
* `Keff`: (vector) A vector `[K, Vd, Vc, toc]` containing:
    * `K`: The effective conductivity. 
    * `Vd`: The calculated volume fraction of the inclusion (dispersed) phase. 
    * `Vc`: The calculated volume fraction of the matrix (continuous) phase.
    * `toc`: The total computation time in seconds. 


4. MATLAB FILE DESCRIPTIONS
------------------------------------------------------------------------

* `main.m`:
    The main execution script. It performs the following steps:
    1.  Sets parameters (`PHI`, `SIGMA`, `DIRECTION`).
    2.  Loads the mesh using `MyVolLoader3d.m`.
    3.  Calculates initial phase volumes (`Vc`, `Vd`) using `calcPHI3d.m`.
    4.  It checks if the user's target `PHI` is closer to the calculated `Vc` (matrix) or `Vd` (inclusion). If `PHI` is closer to `Vc`, it inverts the `surfnr_BOOL` array, effectively swapping the matrix and inclusion definitions to match the user's intent.
    5.  Identifies periodic nodes using `ParesCorrespondentes_linear.m`, `quinas.m`, and `ReorganizarPares.m`.
    6.  Builds the Location Matrix (LM) using `MontagemMatrizLM.m`.
    7.  Assembles the global stiffness matrix (`K_red`) and force vector (`F`) in a loop by calling `ElLinear.m` and `AssembleLinear.m` for each element.
    8.  Solves the linear system $K\chi = F$ using `GC_red_precondicionado.m` to find the fluctuation field `chi`. 
    9.  Calculates the element-wise contributions to conductivity in a loop by calling `SomatorioKElLinear.m`.
    10. Sums the contributions to get the final effective conductivity `K`. 

* `MyVolLoader3d.m`:
    A custom mesh loader for 3D `.vol` files generated by NETGEN. It reads nodal coordinates (`x`, `y`, `z`), element connectivity (`IEN`), and material markers. It automatically identifies the material phase with the largest volume and assigns it as the matrix (`surfnr_BOOL = 0`), assigning all other material markers as inclusions (`surfnr_BOOL = 1`).

* `calcPHI3d.m`:
    Calculates the volume fraction of the continuous (`Vc`, where `surfnr_BOOL==0`) and dispersed (`Vd`, where `surfnr_BOOL==1`) materials based on the mesh. It iterates through all elements and calls `VolTetra.m` to sum their respective volumes. 

* `VolTetra.m`:
    A utility function that calculates the volume of a single tetrahedral element using the determinant of the Jacobian matrix. 

* `plotmesh3d.m`:
    A visualization script to plot the 3D tetrahedral mesh using `tetramesh`. It inspects the `surfnr_BOOL` vector to color the inclusion phase ('red') and make the matrix phase transparent for inspection.

* `ParesCorrespondentes_linear.m`:
    Identifies and maps corresponding node pairs on the opposing faces of the unit cell. This is the first step for imposing periodic boundary conditions. 

* `quinas.m`:
    Identifies nodes on the 12 edges and 8 corners of the unit cell. It refines the periodic node mapping from `ParesCorrespondentes_linear.m` to correctly handle these complex boundary conditions. It requires the helper function `quadras.m`.

* `ReorganizarPares.m`:
    Organizes the final list of periodic node pairs (`PARES`) and determines the total number of unique degrees of freedom (`ndof`) for the system.

* `MontagemMatrizLM.m`:
    Assembles the Location Matrix (LM). This crucial matrix maps the 4 local degrees of freedom (DOFs) of each tetrahedral element to the correct global DOFs, ensuring that periodic nodes share the same DOF. 

* `ElLinear.m`:
    Calculates the 4x4 element stiffness matrix (`k`) and 4x1 element force vector (`f`) for a single linear tetrahedral element, based on its geometry and material properties (`SIGMA`).

* `AssembleLinear.m`:
    Assembles the global stiffness matrix (`K_red`) and global force vector (`F`) from all element matrices (`k`) and vectors (`f`), using the `LM` map. This is done in an element-by-element fashion to conserve memory.

* `GC_red_precondicionado.m`:
    Solves the large, sparse linear system of equations $K\chi = F$ using a preconditioned Conjugate Gradient (GC) solver. It returns the solution vector `chi`, which represents the microscopic temperature fluctuation field.

* `SomatorioKElLinear.m`:
    Calculates the final effective conductivity `K` by performing a numerical integration over all elements. It uses the solution field `chi` (from the GC solver), the element geometry, and material properties to compute the element's contribution to the total macroscopic flux, as described by the homogenization formula (Eq. 3.100 in the thesis). 


5. KEY VARIABLES
------------------------------------------------------------------------

* `PHI`: (Input) Target global volume fraction. 
* `SIGMA`: (Input) Conductivity ratio, $k_d/k_c$. 
* `DIRECTION`: (Input) Direction of heat flow (1, 2, or 3). 
* `x`, `y`, `z`: Nodal coordinate vectors (from mesh file). 
* `IEN`: Element connectivity matrix (maps element nodes to global node numbers).
* `nel`: Total number of elements in the mesh. 
* `nnp`: Total number of nodal points in the mesh.
* `surfnr_BOOL`: (1 x nel) Boolean vector. `surfnr_BOOL(e) = 1` if element `e` is the inclusion (dispersed) phase; `0` if it is the matrix (continuous) phase.
* `Vc`, `Vd`: Calculated volumes of continuous (matrix) and dispersed (inclusion) phases. 
* `PARES`: Matrix mapping periodic node pairs.
* `ndof`: Net degrees of freedom after periodic boundary conditions are applied. 
* `LM`: Location Matrix (maps element DOFs to global DOFs). 
* `K_red`: The global (reduced) stiffness matrix. 
* `F`: The global (reduced) force vector. 
* `chi`: (ndof x 1) The solution vector (microscopic fluctuation field). 
* `Condutividade`: (1 x nel) Vector storing each element's contribution to the final `K`. 
* `K`: (Output) The final, calculated effective thermal conductivity. 

6. REFERENCES
------------------------------------------------------------------------

[1] Schöberl, J. (1997), "NETGEN an Advancing front 2D/3D-mesh generator based on abstract rules", Computing and Visualization in Science, Vol. 1 No. 1, pp. 41-52. 

7. LICENSE
------------------------------------------------------------------------

This project is licensed under the MIT License. See the `LICENSE` file for details.


8. CITATION
------------------------------------------------------------------------

If you use this code in your research, please cite the following paper:

Mattos, L. P., Cruz, M. E., & Bravo-Castillero, J. (2018). Finite element computation of the effective thermal conductivity of two-dimensional multi-scale heterogeneous media. *Engineering Computations*, *35*(5), 2107-2123. https://doi.org/10.1108/EC-11-2017-0444

**BibTeX Entry:**

@article{Mattos2018EC,
  author   = {Lucas Prado Mattos and Manuel Ernani Cruz and Juli{\'a}n Bravo-Castillero},
  title    = {Finite element computation of the effective thermal conductivity of two-dimensional multi-scale heterogeneous media},
  journal  = {Engineering Computations},
  volume   = {35},
  number   = {5},
  pages    = {2107-2123},
  year     = {2018},
  doi      = {10.1108/EC-11-2017-0444}
}
