% ode45 practice with dampened pendulum

clear; clc;

call_pendulum()

function [] = call_pendulum()
    tspan = 0:0.01:60;
    u0 = [pi/2 0] % initial conditions
    [t,u] = ode45(@pendulum,tspan,u0);
    [t1,y] = ode45(@pendulum_lin,tspan,u0);
    x_lin = L*(1-cos(u(:,1)));
    vel_lin = L*u(:,2);
    x_nonlin = L*(1-cos(y(:,1)));
    vel_nonlin = L*y(:,2);  
    
    subplot(3,1,1)
    plot(t,x_nonlin,t1,x_lin,'r')
    legend('Non-linear','Linear')
    xlabel('time (sec)')
    ylabel('y height (m)')
    
    subplot(3,1,2)
    plot(t,vel_nonlin,t1,vel_lin,'r')
    legend('Non-Linear','Linear')
    xlabel('time (sec)')
    ylabel('tangential vel (m/s)')
    
    subplot(3,1,3)
    plot(t,u(:,1)*180/pi,t1,y(:,1)*180/pi,'r')
    legend('Non-linear','Linear')
    xlabel('time (sec)')
    ylabel('pendulum angle (m/s)')
    
    function dX = pendulum(t,u)
        theta = u(1);
        thetadot = u(2);
        g = 9.81;
        L = 10;
        C = 0.1;
        dX = [u(2); -g/L*sin(theta)-C*thetadot];
    end

    function dx = pendulum_lin(t,y)
        g = 9.81;
        L = 10;
        C = 0.1;
        dx = [y(2); -g/L*y(1)-C*y(2)];
    end
end