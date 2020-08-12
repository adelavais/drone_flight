% VAIS Adela 325CD - Tema 3 - Teoria sistemelor

%calculez intervalele de timp dintre masuratori
length_time = length(time_unix_usec_mavlink_system_time_t);
deltaT(1) = 0;
for i = 2 : length_time
    deltaT(i) = time_unix_usec_mavlink_system_time_t(i) - time_unix_usec_mavlink_system_time_t(i-1);
    deltaT(i) = deltaT(i) / 1000000;
end
DeltaT = mean(deltaT);

A = [1 DeltaT; 0 1];
B = [DeltaT^2/2; DeltaT];
C = [1 0; 0 1];

diag_A = [A(1,1);A(2,2)];
if (eig(A) == diag_A)
    disp('A e superior triunghiulara si are valorile proprii pe diagonala principala');
end

K = place(A,B,[-0.1 -0.2]);
A = A - B * K;

A
disp('A nu mai e superior triunghiulara')


x0 =  [x_mavlink_local_position_ned_t(end); vx_mavlink_local_position_ned_t(end)];
R  = 0.1;
a  = 1;

N = length(x_mavlink_local_position_ned_t);
x(:,1) = x0;
for k=1:N
    x(:,k+1) = A * x(:,k) + B * a;
    y(:,k) = C * x(:,k) + rand(2,1) * sqrt(R);
end

subplot(2,1,1);
plot(y(1,:));
title('Pozitia');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(y(2,:));
title('Viteza');
xlabel('timp');
ylabel('viteza');


