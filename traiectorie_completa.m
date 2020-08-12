    % VAIS Adela 325CD - Tema 3 - Teoria sistemelor
    
    clear all
    ref = 'drone_log';
    cd = pwd;
    cd = fullfile(cd,ref);
    
    if exist(strcat(cd,'.mat'), 'file') == 2
      ref = load(ref);
      
      time_unix_usec_mavlink_system_time_t = ref.time_unix_usec_mavlink_system_time_t;
      
      x_mavlink_local_position_ned_t = ref.x_mavlink_local_position_ned_t;
      vx_mavlink_local_position_ned_t = ref.vx_mavlink_local_position_ned_t;
      xacc_mavlink_raw_imu_t = ref.xacc_mavlink_raw_imu_t;
      
      y_mavlink_local_position_ned_t = ref.y_mavlink_local_position_ned_t;
      vy_mavlink_local_position_ned_t = ref.vy_mavlink_local_position_ned_t;
      yacc_mavlink_raw_imu_t = ref.yacc_mavlink_raw_imu_t;
      
      z_mavlink_local_position_ned_t = ref.z_mavlink_local_position_ned_t;
      vz_mavlink_local_position_ned_t = ref.vz_mavlink_local_position_ned_t;
      zacc_mavlink_raw_imu_t = ref.zacc_mavlink_raw_imu_t;
      
    end
    
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
      
    %calculul raspunsului pt timp invariant
    x0 = [x_mavlink_local_position_ned_t(1);
          y_mavlink_local_position_ned_t(1);
          z_mavlink_local_position_ned_t(1);
          vx_mavlink_local_position_ned_t(1);
          vy_mavlink_local_position_ned_t(1);
          vz_mavlink_local_position_ned_t(1)];

    R  = 0.1;

    N = length(x_mavlink_local_position_ned_t);
    x(:,1) = x0;
    a(:,1) = [xacc_mavlink_raw_imu_t(1);yacc_mavlink_raw_imu_t(1);zacc_mavlink_raw_imu_t(1)];

    for k=1:N
        x(:,k+1) = A * x(:,k) + B * a(:,k);
        y(:,k) = C * x(:,k) + rand(1) * sqrt(R) * [1;1;1];
        if k+1 < N+1
            a(:,k+1) = [xacc_mavlink_raw_imu_t(k+1);yacc_mavlink_raw_imu_t(k+1);zacc_mavlink_raw_imu_t(k+1)];
        end
    end
   
    traiect_zbor = y;
    
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

    K = place(A,B,[-0.1 -0.2 -0.3 -0.4 -0.5 -0.6]);
    %polii se afla pe discul unitate

    A = A - B * K;

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
    
    
    traiect_homecoming = [y(1,:);y(2,:);y(3,:)];

    %traiect total = traiectorie zbor + traiectorie homecoming
    traiect = [traiect_zbor(1,:), traiect_homecoming(1,:);
               traiect_zbor(2,:), traiect_homecoming(2,:);
               traiect_zbor(3,:), traiect_homecoming(3,:)];
           
    figure()
    plot3(traiect(1,:),traiect(2,:),traiect(3,:));
    title('Traiectorie completa')
    grid on
    %se poate observa ca se intoarce in punctul de unde a plecat