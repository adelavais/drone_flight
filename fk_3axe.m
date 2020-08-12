% VAIS Adela 325CD - Tema 3 - Teoria sistemelor

x  = x_mavlink_local_position_ned_t;
vx = vx_mavlink_local_position_ned_t;
ax = xacc_mavlink_raw_imu_t;

y  = y_mavlink_local_position_ned_t;
vy = vy_mavlink_local_position_ned_t;
ay = yacc_mavlink_raw_imu_t;

z  = z_mavlink_local_position_ned_t;
vz = vz_mavlink_local_position_ned_t;
az = zacc_mavlink_raw_imu_t;

C = eye(6);
R = eye(6);
Q = eye(6);
P = rand(6);
I = eye(6);

raspuns = [x(1); y(1); z(1); vx(1); vy(1); vz(1)];

%timp variant, extind pentru sistem cu 3 axe
for i = 2:length(dt)
    A = [1 0 0 dt(i) 0 0;
         0 1 0 0 dt(i) 0;
         0 0 1 0 0 dt(i);
         0 0 0 1 0 0;
         0 0 0 0 1 0;
         0 0 0 0 0 1];
     
    B = [dt(i)^2/2 0 0;
         0 dt(i)^2/2 0;
         0 0 dt(i)^2/2;
         dt(i) 0 0;
         0 dt(i) 0;
         0 0 dt(i)];
     
    a = [ax(i);ay(i);az(i)];
    raspuns(:,i) = A * raspuns(:, i-1) + B * a;
    P = A * P * A' + Q;
    
    G = P * C' * inv(C * P * C' + R);
    raspuns(:,i) = raspuns(:,i) + G * ([x(i); y(i); z(i); vx(i); vy(i); vz(i)] - C * raspuns(:,i));
    P = (I - G * C) * P;
end

filtred_x  = raspuns(1,:);
filtred_vx = raspuns(4,:);
filtred_y  = raspuns(2,:);
filtred_vy = raspuns(5,:);
filtred_z  = raspuns(3,:);
filtred_vz = raspuns(6,:);

figure()
subplot(2,1,1);
plot(x);
hold on;
plot(filtred_x);
title('Pozitia x');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(vx);
hold on;
plot(filtred_vx);
title('Viteza vx');
xlabel('timp');
ylabel('viteza');

figure()
subplot(2,1,1);
plot(y);
hold on;
plot(filtred_y);
title('Pozitia y');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(vy);
hold on;
plot(filtred_vy);
title('Viteza vy');
xlabel('timp');
ylabel('viteza');

figure()
subplot(2,1,1);
plot(z);
hold on;
plot(filtred_z);
title('Pozitia z');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(vz);
hold on;
plot(filtred_vz);
title('Viteza vz');
xlabel('timp');
ylabel('viteza');

figure()
plot3(x,y,z)
hold on
grid on
title('Grafic x,y,z')
plot3(filtred_x,filtred_y,filtred_z)
axis([-15 2 -15 20 -15 2])
axis equal
hold off