function [ v ] = Hat2Vector( h )
%returns the R3 vector from its corresponding so(3) element

v(1)=h(3,2);
v(2)=h(1,3);
v(3)=h(2,1);

end

