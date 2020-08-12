% VAIS Adela 325CD - Tema 3 - Teoria sistemelor

%calculez intervalele de timp dintre masuratori
length_time = length(time_unix_usec_mavlink_system_time_t);
deltaT(1) = 0;
for i = 2 : length_time
    deltaT(i) = time_unix_usec_mavlink_system_time_t(i) - time_unix_usec_mavlink_system_time_t(i-1);
    deltaT(i) = deltaT(i) / 1000000;
end
DeltaT = mean(deltaT);

A = [1 0 0 DeltaT 0 0; 
     0 1 0 0 DeltaT 0;
     0 0 1 0 0 DeltaT;
     0 0 0 1 0 0;
     0 0 0 0 1 0;
     0 0 0 0 0 1];
     
B = [DeltaT^2/2 0 0;
     0 DeltaT^2/2 0;
     0 0 DeltaT^2/2;
     DeltaT 0 0;
     0 DeltaT 0;
     0 0 DeltaT];
    
C = [1 0 0 0 0 0;
     0 1 0 0 0 0;
     0 0 1 0 0 0];

diag_A = [A(1,1);A(2,2);A(3,3);A(4,4);A(5,5);A(6,6)];
if (eig(A) == diag_A)
    disp('A e superior triunghiulara si are valorile proprii pe diagonala principala');
end

K = place(A,B,[-0.1 -0.2 -0.3 -0.4 -0.5 -0.6]);
%polii se afla pe discul unitate

A = A - B * K;

A
disp('A nu mai e superior triunghiulara')

x0 =  [x_mavlink_local_position_ned_t(end); 
       y_mavlink_local_position_ned_t(end); 
       z_mavlink_local_position_ned_t(end);
       vx_mavlink_local_position_ned_t(end);
       vy_mavlink_local_position_ned_t(end);
       vz_mavlink_local_position_ned_t(end)];
   
R  = 0.1;
a  = [1;1;1];

N = length(x_mavlink_local_position_ned_t);

clear x y
x(:,1) = x0;

for k=1:N
    x(:,k+1) = A * x(:,k) + B * a;
    y(:,k) = C * x(:,k) + rand(3,1) * sqrt(R);
end

figure()
subplot(2,1,1);
plot(y(1,:));
title('Pozitia x');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(x(4,:));
title('Viteza vx');
xlabel('timp');
ylabel('viteza');


figure()
subplot(2,1,1);
plot(y(2,:));
title('Pozitia y');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(x(5,:));
title('Viteza vy');
xlabel('timp');
ylabel('viteza');


figure()
subplot(2,1,1);
plot(y(3,:));
title('Pozitia z');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(x(6,:));
title('Viteza vz');
xlabel('timp');
ylabel('viteza');

figure()
plot3(y(1,:),y(2,:),y(3,:))
title('Plot x,y,x')
axis equal
grid on

