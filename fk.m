x  = x_mavlink_local_position_ned_t;
vx = vx_mavlink_local_position_ned_t;
ax = xacc_mavlink_raw_imu_t;

C = eye(2);
R = eye(2);
Q = eye(2);
P = rand(2);
I = eye(2);

z = [x(1); vx(1)];

for i = 2:length(dt)
    A = [1 dt(i); 0 1];
    B = [dt(i)^2/2; dt(i)];
    z(:,i) = A * z(:, i-1) + B * ax(i);
    P = A * P * A' + Q;
    
    G = P * C' * inv(C * P * C' + R);
    z(:,i) = z(:,i) + G * ([x(i); vx(i)] - C * z(:,i));
    P = (I - G * C) * P;
end

filtred_x  = z(1,:);
filtred_vx = z(2,:);

figure()
subplot(2,1,1);
plot(x);
hold on;
plot(filtred_x);
title('Pozitia');
xlabel('timp');
ylabel('pozitie');

subplot(2,1,2);
plot(vx);
hold on;
plot(filtred_vx);
title('Viteza');
xlabel('timp');
ylabel('viteza');