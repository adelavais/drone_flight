% VAIS Adela 325CD - Tema 3 - Teoria sistemelor

%DeltaT calculat in exercitiul1

%pentru axa x
A = [1 DeltaT; 0 1];
B = [DeltaT^2/2; DeltaT];
C = [1 0];

x0 = [x_mavlink_local_position_ned_t(1); vx_mavlink_local_position_ned_t(1)];
R  = 0.1;
a  = xacc_mavlink_raw_imu_t;

N = length(x_mavlink_local_position_ned_t);
x(:,1) = x0;

for k=1:N
    x(:,k+1) = A * x(:,k) + B * a(k);
    y(:,k) = C * x(:,k) + rand(1) * sqrt(R);
end

figure(1)

subplot(2,1,1);
plot(y);
hold on;
plot(x_mavlink_local_position_ned_t);
title('Pozitia');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(x(2,:));
hold on;
plot(vx_mavlink_local_position_ned_t);
title('Viteza');
xlabel('timp');
ylabel('viteza');

clear y

%pentru axa y
y0 = [y_mavlink_local_position_ned_t(1); vy_mavlink_local_position_ned_t(1)];
R  = 0.1;
a  = yacc_mavlink_raw_imu_t;

N = length(y_mavlink_local_position_ned_t);
y(:,1) = y0;

for k=1:N
    y(:,k+1) = A * y(:,k) + B * a(k);
    iesire(:,k) = C * y(:,k) + rand(1) * sqrt(R);
end

figure(2)

subplot(2,1,1);
plot(iesire);
hold on;
plot(y_mavlink_local_position_ned_t);
title('Pozitia');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(y(2,:));
hold on;
plot(vy_mavlink_local_position_ned_t);
title('Viteza');
xlabel('timp');
ylabel('viteza');

clear y

%pentru axa z
z0 = [z_mavlink_local_position_ned_t(1); vz_mavlink_local_position_ned_t(1)];
R  = 0.1;
a  = zacc_mavlink_raw_imu_t;

N = length(z_mavlink_local_position_ned_t);
z(:,1) = z0;

for k=1:N
    z(:,k+1) = A * z(:,k) + B * a(k);
    y(:,k) = C * z(:,k) + rand(1) * sqrt(R);
end

figure(3)

subplot(2,1,1);
plot(y);
hold on;
plot(z_mavlink_local_position_ned_t);
title('Pozitia');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(z(2,:));
hold on;
plot(vz_mavlink_local_position_ned_t);
title('Viteza');
xlabel('timp');
ylabel('viteza');
