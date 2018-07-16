clear; clc;

syms x(t);
m = 2;
k = 10;
c = 2;
Dx = diff(x);
eqn = m*diff(x,t,2)+c*Dx+k*x == 0;
cond = [Dx(0)==0, x(0)==0.1];
solve(t) = dsolve(eqn,cond)

