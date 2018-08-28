function [ NewNodesCoord ] = disk_dom( R,r )

%  rect_dom: generates the initial mesh for circular disk 
%            domain of radius R and center in (0,0), |z|<R
%
% INPUTS
%
%  R      : domain radius
%  r      : initial mesh step
%
% OUTPUTS
%
%  NewNodesCoord     : generated nodes coordinates
%

h=r*sqrt(3)/2;
n=1+round(R/h);
Rn=(1:n)*R/n;
NewNodesCoord=[0,0];
f0=0;
np=6;
for i=1:n
    f=f0+linspace(0,2*pi,np+1)';
    f(end)=[];
    xyn=Rn(i)*[cos(f) sin(f)];
    NewNodesCoord=[NewNodesCoord; xyn];
    f0=f0+pi/6/n;
    np=np+6;
end


end

