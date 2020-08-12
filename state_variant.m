% VAIS Adela 325CD - Tema 3 - Teoria sistemelor

%DeltaT calculat in exercitiul1

clear A B C a x y 

%pentru axa x
A = [1 DeltaT; 0 1];
B = [DeltaT^2/2; DeltaT];
C = [1 0];

x0 = [x_mavlink_local_position_ned_t(1); vx_mavlink_local_position_ned_t(1)];
R  = 0.1;
a  = xacc_mavlink_raw_imu_t;

N = length(x_mavlink_local_position_ned_t) - 1;
x(:,1) = x0;

for k=1:N
    x(:,k+1) = A * x(:,k) + B * a(k);
    y(:,k) = C * x(:,k) + rand(1) * sqrt(R);
    A = [1 deltaT(k); 0 1];
    B = [deltaT(k)^2/2; deltaT(k)];
end

k = N +1;
x(:,k+1) = A * x(:,k) + B * a(k);
y(:,k) = C * x(:,k) + rand(1) * sqrt(R);
plot_3d(1,:) = y;

figure()

subplot(2,1,1);
plot(y);
hold on;
plot(x_mavlink_local_position_ned_t);
title('Pozitia x');
xlabel('timp');
ylabel('pozitie');
hold off

clear y

subplot(2,1,2);
plot(x(2,:));
hold on;
plot(vx_mavlink_local_position_ned_t);
title('Viteza vx');
xlabel('timp');
ylabel('viteza');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear A B C a x y 

%pentru axa y
A = [1 DeltaT; 0 1];
B = [DeltaT^2/2; DeltaT];
C = [1 0];

x0 = [y_mavlink_local_position_ned_t(1); vy_mavlink_local_position_ned_t(1)];
R  = 0.1;
a  = yacc_mavlink_raw_imu_t;

N = length(y_mavlink_local_position_ned_t) - 1;
x(:,1) = x0;

for k=1:N
    x(:,k+1) = A * x(:,k) + B * a(k);
    y(:,k) = C * x(:,k) + rand(1) * sqrt(R);
    A = [1 deltaT(k); 0 1];
    B = [deltaT(k)^2/2; deltaT(k)];
end

k = N +1;
x(:,k+1) = A * x(:,k) + B * a(k);
y(:,k) = C * x(:,k) + rand(1) * sqrt(R);
plot_3d(2,:) = y;    

figure()

subplot(2,1,1);
plot(y);
hold on;
plot(y_mavlink_local_position_ned_t);
title('Pozitia y');
xlabel('timp');
ylabel('pozitie');
hold off

clear y

subplot(2,1,2);
plot(x(2,:));
hold on;
plot(vy_mavlink_local_position_ned_t);
title('Viteza vy');
xlabel('timp');
ylabel('viteza');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

clear A B C a x y 

%pentru axa z
A = [1 DeltaT; 0 1];
B = [DeltaT^2/2; DeltaT];
C = [1 0];

x0 = [z_mavlink_local_position_ned_t(1); vz_mavlink_local_position_ned_t(1)];
R  = 0.1;
a  = zacc_mavlink_raw_imu_t;

N = length(z_mavlink_local_position_ned_t) - 1;
x(:,1) = x0;

for k=1:N
    x(:,k+1) = A * x(:,k) + B * a(k);
    y(:,k) = C * x(:,k) + rand(1) * sqrt(R);
    A = [1 deltaT(k); 0 1];
    B = [deltaT(k)^2/2; deltaT(k)];
end

k = N +1;
x(:,k+1) = A * x(:,k) + B * a(k);
y(:,k) = C * x(:,k) + rand(1) * sqrt(R);
plot_3d(3,:) = y;   

figure()

subplot(2,1,1);
plot(y);
hold on;
plot(z_mavlink_local_position_ned_t);
title('Pozitia z');
xlabel('timp');
ylabel('pozitie');
hold off

clear y

subplot(2,1,2);
plot(x(2,:));
hold on;
plot(vz_mavlink_local_position_ned_t);
title('Viteza vz');
xlabel('timp');
ylabel('viteza');


figure()
plot3(plot_3d(1,:), plot_3d(2,:), plot_3d(3,:));
hold on;
plot3(x_mavlink_local_position_ned_t,y_mavlink_local_position_ned_t,z_mavlink_local_position_ned_t);
title('Plot 3D');
grid on
hold off
