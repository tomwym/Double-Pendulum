clear;
clc;

spx = 1;
spy = 1;

m = 1;
g = 9.81;
l = 1;
w = sqrt(g/l);

span = 0:0.00001:50;
initial = [pi/2 0];

[t,theta] = ode45(@odePendulum,span,initial);
% theta returns a size(t) x 2 matrix
% returns theta(t) and dtheta(t)/dt in 
% theta(:,1) and theta(:,2) respectively

subplot(2,1,1)
plot(t,theta)%(:,1))

kinetic = 1/2*m.*(theta(:,2).*l).^2;
potential = m*g*l.*(1-cos(theta(:,1)));
energy = kinetic + potential;
subplot(2,1,2)
plot(t,energy)

function thetaDot = odePendulum(t,theta)
    thetaDot = zeros(2,1);
    thetaDot(1) = theta(2);
    thetaDot(2) = -9.81*sin(theta(1));
end


%{
theta1'' + w^2*sin(theta1) = 0

theta1dot = theta2
theta1dotdot = theta2dot = -w^2*sin(theta1)

theta = [theta1 ; theta2]
thetaDot = [theta1dot ; 
            theta2dot] 
         = d/dt [theta1 ; 
                 theta2]
         = [theta2 ; 
            -w^2*sin(theta1)]
         = [theta(2) ; 
            -w^2*sin(theta(1))]e
%}

