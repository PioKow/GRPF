function [ w ] = vinq( f )
%  vinq: converts the function values to quadrants
%
% INPUTS
%
%  f     : function value
%
% OUTPUTS
%
%  w     : quadrant
%

if     ( real(f)>0 ) && ( imag(f)>=0 )
    w=1;
elseif ( real(f)<=0 ) && ( imag(f)>0 )
    w=2;    
elseif ( real(f)<0 ) && ( imag(f)<=0 )
    w=3;
elseif ( real(f)>=0 ) && ( imag(f)<0 )
    w=4;
else
    w=NaN;        
end


end

