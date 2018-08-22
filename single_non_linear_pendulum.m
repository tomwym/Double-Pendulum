clear; clc;

% subplot definition variables
spx = 1;
spy = 4;

% kinematic variables
m = 1;
g = 9.81;
l = 1;
w = sqrt(g/l);
w2 = g/l;

% numerics variables
span = 0:0.000001:10;
initial = [pi/3 0];

% ODE45 function call
[t,theta] = ode45(@(t,theta) odePendulum(t,theta,w2),span,initial);
% theta returns a size(t) x 2 matrix
% returns theta(t) and dtheta(t)/dt in 
% theta(:,1) and theta(:,2) respectively

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subplot features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% theta and omega vs time plot
pendulum_plot = subplot(spy,spx,1);
plot(pendulum_plot,t,theta)%(:,1))
grid on;
grid(pendulum_plot,'on');
grid(pendulum_plot,'minor');
xlabel(pendulum_plot, 'Time [s]');
ylabel(pendulum_plot, 'Theta [rad]');
title(pendulum_plot, {'';'Theta vs Time'});
legend('theta(t)','dtheta(t)/dt');

% total mechanical energy definition
kinetic = 1/2*m.*(theta(:,2).*l).^2;
potential = m*g*l.*(1-cos(theta(:,1)));
energy = kinetic + potential;

% mechanical energy vs time plot
energy_plot = subplot(spy,spx,2);
plot(energy_plot,t,energy,'m')
grid on;
grid(energy_plot,'on');
grid(energy_plot,'minor');
xlabel(energy_plot, 'Time [s]');
ylabel(energy_plot, 'Mechanical Energy [J]');
title(energy_plot, {'';'Energy vs Time'});

% absolute energy difference
delta_energy = abs(energy - m*g*l*(1-cos(initial(1))));

% energy difference vs time plot
delta_energy_plot = subplot(spy,spx,3);
plot(delta_energy_plot,t,delta_energy,'g')
grid on;
grid(delta_energy_plot,'on');
grid(delta_energy_plot,'minor');
xlabel(delta_energy_plot, 'Time [s]');
ylabel(delta_energy_plot, 'Delta Energy [J]');
title(delta_energy_plot, {'';'Energy Difference vs Time'});

% percent energy error 
perc_diff = abs(delta_energy) ./ energy .* 100;

% percent error vs time plot 
perc_diff_plot = subplot(spy,spx,4);
plot(perc_diff_plot,t,perc_diff,'k')
grid on;
grid(perc_diff_plot,'on');
grid(perc_diff_plot,'minor');
xlabel(perc_diff_plot, 'Time [s]');
ylabel(perc_diff_plot, 'Percent Difference');
title(perc_diff_plot, {'';'Percent Difference vs Time'});

% function definition to prepare ode45
function thetaDot = odePendulum(t,v_theta,w2)
    thetaDot = zeros(2,1);
    thetaDot(1) = v_theta(2);
    thetaDot(2) = -w2*sin(v_theta(1));
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

