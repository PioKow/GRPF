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

f=1.0e9;
er=5-2i;
mr=1-2i;
d=1.0e-2;
c=3e8;
w=2*pi*f;
k0=w/c;
c=er^2*(k0*d)^2*(er*mr-1);
w=er^2*z^2 + z^2*tan(z)^2 -c;

end





