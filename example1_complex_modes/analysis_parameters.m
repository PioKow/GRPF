

% circular disk domain definition of radius R, center in (0,0), |z|<R
R = 1;     % domain radius
r = 0.15;   % initial mesh step

NewNodesCoord = disk_dom(R,r); % initial mesh generation


Tol = 1e-9; % accuracy (candidate region size)

visual=2; % mesh visualization:  0 - turned off,   1  - only last iteration,   2  - all iterations

ItMax=100; % max number of iterations

NodesMax=500000; % max number of nodes

SkinnyTriangle=3; % sinny triangle definition

