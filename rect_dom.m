function [ NewNodesCoord ] = rect_dom( xb,xe,yb,ye,r )

%  rect_dom: generates the initial mesh for rectangular domain z=x+jy x\in[xb,xe] , y\in[yb,ye]
%
% INPUTS
%
%  xb     : real part range begin 
%  xe     : real part range end 
%  yb     : imag part range begin 
%  ye     : imag part range end 
%  r      : initial mesh step
%
% OUTPUTS
%
%  NewNodesCoord     : generated nodes coordinates
%



X=xe-xb;
Y=ye-yb;

n=ceil(Y/r+1);
dy=Y/(n-1);
m=ceil(X/sqrt(r^2-dy^2/4) +1);
dx = X/(m-1);

vx=linspace(xb,xe,m);
vy=linspace(yb,ye,n);
[x,y]=meshgrid(vx,vy);
temp=ones(n,1);
temp(n,:)=0;
y=y+0.5*dy*kron( (1+(-1).^(1:m))/2, temp);


x=reshape(x,m*n,1);
y=reshape(y,m*n,1);
tx=((2:2:m)-1)'*dx + xb;
ty=tx*0+yb;
x=[x ; tx];
y=[y ; ty];

NewNodesCoord=[x,y];

end

