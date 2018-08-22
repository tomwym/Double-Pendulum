clear; clc;

% kinematic variables
m1 = 1;         % mass 1
m2 = 2;         % mass 2
l1 = 1;         % length of segment 1
l2 = 0.75;       % length of segment 2
g = 9.81;       % gravitational constant 

% graphics variables
srad = 0.05;    % small radius
lrad = 0.1;     % large radiss

% numerical variables
delta = 0.01;
span = 0:delta:10;
num_timesteps = max(size(span));
    % consider using length(span)
initial = [2*pi/3 pi/2 0 0];
% initial = [theta1(0) theta2(0) omega1(0) omega2(0)]

% ODE45 function call 
[t,theta] = ode45(@(t,x) odePendulum(t,x,m1,m2,l1,l2,g),span,initial);


% constant graphics definition
animation = subplot(1,1,1);
axis(animation, 'equal');
grid on;
set(animation, 'XLim', [-(l1+l2), l1+l2], 'YLim', [-(l1+l2), l1+l2]);
xlabel(animation, 'X Position [m]');
ylabel(animation, 'Y Position [m]');
title(animation, {'';'Position of Point'});
% original circle
ogCirc = viscircles(animation, [0 0], srad);

% dynamic graphics definition
for i=1:num_timesteps
    [x1,y1,x2,y2] = kinematics(theta(i,1),theta(i,2),l1,l2);
    point1 = viscircles(animation, [x1 y1], srad);
    point2 = viscircles(animation, [x2 y2], srad);
    line1 = line([0 x1], [0 y1]);
    line2 = line([x1 x2], [y1 y2]);
    
    drawnow limitrate;
    
    if i < length(t)
        delete(point1);
        delete(point2);
        delete(line1);
        delete(line2);
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function xdot = odePendulum(t,x,m1,m2,l1,l2,g)

    xdot = zeros(4,1);
    xdot(1) = x(3);
    xdot(2) = x(4);
    
    A = cos(x(1)-x(2));
    B = sin(x(1)-x(2));
    C = A*B;
    D = A^2;
    E = m1+m2;
    F = E - m2*D;
    G = -m2*l1*x(3)^2*C + m2*g*A*sin(x(2)) - E*g*sin(x(1)) - m2*l2*x(4)^2*B;
    H = E*l1*x(3)^2*B + E*g*A*sin(x(1)) + m2*l2*x(4)^2*C - E*g*sin(x(2));
    
    xdot(3) = G/(l1*F);
    xdot(4) = H/(l2*F);
    
end

function [x1,y1,x2,y2] = kinematics(theta1,theta2,l1,l2)

    x1 = l1*sin(theta1);        
    y1 = -l1*cos(theta1);
    x2 = l1*sin(theta1) + l2*sin(theta2);
    y2 = -l1*cos(theta1) - l2*cos(theta2);
    
end