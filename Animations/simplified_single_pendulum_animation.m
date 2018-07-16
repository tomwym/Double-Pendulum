%simple pendulum
clc; clear;

srad = 0.05;        % small radius constant
lgrad = 0.1;        % large radius constant 
iniTheta = 20;      % initial theta release angle
maxTime = 10;       % x domain
timeStep = 0.02;    % time increment
spn = 2;            % subplot number (spn:1)
pauseTime = 0.0025;     % pause after circle and line is drawn 
                        % pausetime and timestep were decided via tuning

syms theta(t);      % standard theta with respect to time 
g = 9.81;           % m/s^2
r = 2;              % m
w = sqrt(g/r);      % period of penlulum swing 

dtheta = diff(theta);
% d''theta/dt'' + w*sin(theta) = 0
% small angle approximation sin(theta) ~ theta
shm_ode = diff(theta,t,2) + w^2*theta == 0;

cond1 = dtheta(0) == 0;
cond2 = theta(0) == iniTheta;
conds = [cond1 cond2];
                    % initial conditions packaged as a single vector, as per convention
thetaSol(t) = dsolve(shm_ode,conds);
                    % MATLAB built in function to symbolically solve ODEs
t = 0:timeStep:maxTime;
theta = double(thetaSol(t));
                    % Changes from symbolic value to numeric (double)

% Plot 1: theta vs time graph
thetaPlot = subplot(spn,1,1);
curve = animatedline('Color','b','Marker','o');
grid on;
xlabel(thetaPlot, 'Time [s]');
ylabel(thetaPlot, 'Theta [deg]');
title(thetaPlot, 'Theta vs Time');
set(thetaPlot,'XLim', [0, maxTime],'YLim', [-iniTheta, iniTheta]);    

% Plot 2: swinging pendulum
y_pos = -r.*cosd(theta);
x_pos = r.*sind(theta);
% To model a pendulum swinging, side to side movement that is seen as the x position 
% is in actuality modeled by the sin function with respect to the radius and time, 
% and the height (y movement) is modeled by the cosine function.
% Remember that the centerline is the y axis instead of the x axis. 

pointPlot = subplot(spn,1,2);
axis(pointPlot, 'equal');
grid on;
set(gca, 'XLim', [-r, r], 'YLim', [-2*r, r]);
xlabel(pointPlot, 'X Position [m]');
ylabel(pointPlot, 'Y Position [m]');
title(pointPlot, {'';'Position of Point'});
    
ogCirc = viscircles(pointPlot, [0 0], srad);
crLineX = line(pointPlot, [-0.5 0.5], [0 0]);
ctrLineY = line(pointPlot, [0 0], [0.5 -0.5]);

for i=1:length(t)
    
    pointCirc = viscircles(pointPlot, [x_pos(i) y_pos(i)], lgrad);
    pointLn = line([0 x_pos(i)], [0 y_pos(i)]);
    
    addpoints(curve,t(i),theta(i));
    drawnow limitrate;

    pause(pauseTime);
    
    if i < length(t)
        delete(pointCirc);
        delete(pointLn);
    end
end

