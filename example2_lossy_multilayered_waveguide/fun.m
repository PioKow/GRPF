function [ w ] = fun( z )
%  fun: function definition
%
% INPUTS
%
%  z     : function argument
%
% OUTPUTS
%
%  w     : function value
%

ns=0.065-4.j;
n1=1.5835;
nc=1.0;
d1=1.81e-6;
lambda0=0.6328e-6;
k0=2.*pi/lambda0;
k0d1=k0*d1;
kappa1=sqrt(n1^2.-z^2.);
gammas=sqrt(z^2.-ns^2.);
gammac=sqrt(z^2.-nc^2.);
m11=cos(kappa1*k0d1);
m12=1j/kappa1*sin(kappa1*k0d1);
m21=1j*kappa1*sin(kappa1*k0d1);
m22=cos(kappa1*k0d1);
    
w=det([1.0, -m11+1j*gammac*m12; 1j*gammas, -m21+1j*gammac*m22]);

end





