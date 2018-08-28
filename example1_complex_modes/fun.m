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

z=z*10;

f=5e9;
c = 3e+8;                  
mu0 = 4 * pi * 1e-7;        
eps0 = 1e-9 / 36 / pi;     
a = 6.35e-3; 
b = 10.0e-3; 
eps_r1 = 10; 
eps_r2 = 1; 
m = 1;  

omega = 2 * pi * f;
k0 = omega / c;
alpha=real(z)*k0;
beta=imag(z)*k0; 
gama=alpha+1i*beta;
eps1=eps0*eps_r1;
eps2=eps0*eps_r2;
mu1=mu0;
mu2=mu0;
kappa1 = sqrt(gama^2 + k0^2*eps_r1);
kappa2 = sqrt(gama^2 + k0^2*eps_r2);
eta1=sqrt(mu1/eps1);
eta2=sqrt(mu2/eps2);

Jm_a1 = besselj( m , kappa1*a );
Jm_a2 = besselj( m , kappa2*a );
Ym_a2 = bessely( m , kappa2*a );
Jm_b2 = besselj( m , kappa2*b );
Ym_b2 = bessely( m , kappa2*b );
DJm_a1 = ( besselj(m-1,kappa1*a) - besselj(m+1,kappa1*a) ) / 2;
DJm_a2 = ( besselj(m-1,kappa2*a) - besselj(m+1,kappa2*a) ) / 2;
DJm_b2 = ( besselj(m-1,kappa2*b) - besselj(m+1,kappa2*b) ) / 2;
DYm_a2 = ( bessely(m-1,kappa2*a) - bessely(m+1,kappa2*a) ) / 2;
DYm_b2 = ( bessely(m-1,kappa2*b) - bessely(m+1,kappa2*b) ) / 2;


W = [ 
Jm_a1                       0                                 -Jm_a2                       -Ym_a2                       0                                0
0                           Jm_a1/eta1                        0                            0                            -Jm_a2/eta2                      -Ym_a2/eta2
gama*m*Jm_a1/(a*kappa1^2)   -omega*mu1*DJm_a1/(kappa1*eta1)   -gama*m*Jm_a2/(a*kappa2^2)   -gama*m*Ym_a2/(a*kappa2^2)   omega*mu2*DJm_a2/(kappa2*eta2)   omega*mu2*DYm_a2/(kappa2*eta2)
-omega*eps1*DJm_a1/kappa1   -m*gama*Jm_a1/(a*kappa1^2*eta1)   omega*eps2*DJm_a2/kappa2     omega*eps2*DYm_a2/kappa2     m*gama*Jm_a2/(a*kappa2^2*eta2)   m*gama*Ym_a2/(a*kappa2^2*eta2)
0                           0                                 Jm_b2                        Ym_b2                        0                                0
0                           0                                 gama*m*Jm_b2/(b*kappa2^2)    gama*m*Ym_b2/(b*kappa2^2)    -omega*mu2*DJm_b2/(kappa2*eta2)  -omega*mu2*DYm_b2/(kappa2*eta2)
];

w=det(W);

end





