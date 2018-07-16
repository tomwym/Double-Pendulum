% Runge-Kutta First Iteration 

clear; clc;

syms x y(x); 
dy = diff(y);
eqn = dy == 3*x^2*y
f = 3*x^2*y;
cond = y(1) == 2;

% {
xsyms = 1.3;
y_ = dsolve(eqn, cond);
double(subs(y_,x,xsyms))
% }



xf = 2.0;
h = 0.005;
x0 = 1;
y0 = 2;
for i=1:h:xf
    x0 = x0 + h;   
    y0 = double(y0 + h/6*T4(x0,y0,h,f,x,y));
end
y0

function val = T4(xn,yn,h,f,x,y)
    k1 = subs(f,{x,y},{xn,yn});
    k2 = subs(f,{x,y},{xn+h/2,yn+h/2*k1});
    k3 = subs(f,{x,y},{xn+h/2,yn+h/2*k2});
    k4 = subs(f,{x,y},{xn+h,yn+h*k3});
    
    val = k1+2*k2+2*k3+k4;
end
    



