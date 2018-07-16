clear; clc;

t1span = 0:0.01:50;

y10 = [pi/2 0];
[t1,y1] = ode45(@odefnc1, t1span, y10);

t2span = t1span;
y20 = y10;
[t2,y2] = ode45(@(t2,y2) odefnc2(y2), t2span, y20);

angleDelta = y1(:,1)-y2(:,1);

plot(t1,y1(:,1),'-o', t2,y2(:,1),'-*')
legend('ode','approximation')

% plot(t1,angleDelta,'-+');

function dy1dt = odefnc1(t1, y1)
    dy1dt = zeros(2,1);
    dy1dt(1) = y1(2);
    dy1dt(2) = -sin(y1(1));
end

function dy2dt = odefnc2(y2)
    dy2dt = zeros(2,1);
    dy2dt(1) = y2(2);
    dy2dt(2) = -y2(1);
end