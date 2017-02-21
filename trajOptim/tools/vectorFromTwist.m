function [ v ] = vectorFromTwist( T )
%returns the six dim vecotr corresoponding to a twist belonging to se(3)
%represented as a matrix

v(4:6)=T(1:3,4);
v(1:3)=Hat2Vector(T(1:3,1:3));


end

