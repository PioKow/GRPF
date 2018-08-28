

% rectangular domain definition z=x+jy x\in[xb,xe] , y\in[yb,ye]
xb = -2;     % real part range begin 
xe = 2 ;     % real part range end
yb = -2;     % imag part range begin
ye = 2;      % imag part range end 
r = 0.1;     % initial mesh step

NewNodesCoord = rect_dom(xb,xe,yb,ye,r); % initial mesh generation

Tol = 1e-9; % accuracy (candidate region size)

visual=2; % mesh visualization:  0 - turned off,   1  - only last iteration,   2  - all iterations

ItMax=100; % max number of iterations

NodesMax=500000; % max number of nodes

SkinnyTriangle=3; % sinny triangle definition

