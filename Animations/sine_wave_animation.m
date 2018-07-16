clear;
clc;

xmin = 0;
xinc = pi/24;
xmax = 4*pi;

A = 1;
w = 1;

x = xmin:xinc:xmax;     % range from 0 to 4pi with a step size of pi/24
                        % consider using x = linespace(0,4*pi,24*4)
y = A*sin(w*x);         % creates vector of respective sin(x) values 

curve = animatedline('Color','b','Marker','o');
                        % returns handle for axis handle of animated line
set(gca,'XLim',[xmin xmax],'YLim',[-A A]);
                        % domain and range of axis determined by function parameters
grid on;
xlabel(gca, 'X position');
ylabel(gca, 'Y position');
title(gca, 'Animated sin wave');
                        % basic labelling of axis
legend('y = sin(x)');

for i=1:length(x)       % for each point add a new point to the curve
        addpoints(curve,x(i),y(i));
        drawnow limitrate
        pause(0.05);    % pause fo 50 ms to render new graph
end