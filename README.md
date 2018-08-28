# GRPF: Global complex Roots and Poles Finding algorithm

##### Programming language: MATLAB

[![Version](https://img.shields.io/badge/version-1.0-green.svg)](README.md) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

---
## Program goals
The aim of the GRPF algorithm is to **find all the zeros and poles of the function in the fixed region**.  A wide class of analytic functions can be analyzed, and any arbitrarily shaped search region can be considered. High flexibility and effectiveness of this program is demonstrated in the attached examples. These examples are focused on microwave and optical applications, however the algorithm is not limited to computational electrodynamics and can be used for similar problems e.g. in acoustics, control theory and quantum mechanics. 

## Solution method
In the first step, the function which is defined in the [fun.m](fun.m) file is sampled using a regular triangular mesh. After initial analysis of the function the candidate regions to search for roots and poles are determined. Next, the discretized Cauchy's argument principle is applied, but **it does not require the derivative of the function and integration over the contour**. In the proposed approach a minimal number of the function samples is utilized. To improve the accuracy of the results a simple self-adaptive mesh refinement (inside the previously determined candidate regions) is applied.

## Scientific work
If the code is used in a scientific work, then **reference should be made to the following two publications**:
1. P. Kowalczyk, “Complex Root Finding Algorithm Based on Delaunay Triangulation”, ACM Transactions on Mathematical Software, vol. 41, no. 3, art. 19, pp. 1-13, June 2015, [link](https://dl.acm.org/citation.cfm?id=2699457)
2. P. Kowalczyk, "Global Complex Roots and Poles Finding Algorithm Based on Phase Analysis for Propagation and Radiation Problems," IEEE Transactions on Antennas and Propagation, (Accept 27-Aug-2018) 2018

---
## Manual
1. **[GRPF.m](GRPF.m) - starts the program**
2. [analysis_parameters.m](/analysis_parameters.m) - contains all parameters of the analysis, e.g.:
    * the domain shape and size (two domain shapes are available: rectangle and circle, as described in the examples) 
    * the initial step
    * accuracy (Tol)
    * mesh visualization options
3. [fun.m](fun.m) - definition of the function for which roots and poles will be calculated
4. **to run examples**: copy (and overwrite) [analysis_parameters.m](analysis_parameters.m) and [fun.m](fun.m) files from the folder containing the example to the main folder and start GRPF program
 
## Short description of the functions
- [GRPF.m](GRPF.m) - main body of the algorithm  
- [analysis_parameters.m](analysis_parameters.m) - analysis parameters definition
- [fun.m](fun.m) - function definition
- [rect_dom.m](rect_dom.m) - initial mesh generator for rectangular domain
- [disk_dom.m](disk_dom.m) - initial mesh generator for circular domain
- [vinq.m](vinq.m) - converts the function value into proper quadrant
- [FindNextNode.m](FindNextNode.m) - finds the next node in the candidate boundary creation process
- [vis.m](vis.m) - mesh visualization

## Additional comments
The code involves MATLAB function [delaunayTriangulation](https://uk.mathworks.com/help/matlab/ref/delaunaytriangulation.html) which was introduced in R2013a version. In the older versions some modifications are required and the function can be replaced by [DelaunayTri](https://uk.mathworks.com/help/matlab/ref/delaunaytri.html), however this solution is not recommended.

## Author
The project has been developed in **Gdansk University of Technology**, Faculty of Electronics, Telecommunications and Informatics by Dr. Piotr Kowalczyk (faculty web site: [http://eti.pg.edu.pl](http://eti.pg.edu.pl))

## License
GRPF is an open-source Matlab code licensed under the [MIT license](LICENSE.md).
