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
     
     R = ctrb(A, B);

     Q = obsv(A, C);

    %conditia de minimalitate
    if (rank(R) == rank(Q))
        if (rank(R) == size(A))
            disp("rank(R) == rank(Q) == size(A) ====> minimal");
        end
    end

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

    %pentru axa x
    figure()
    subplot(2,1,1);
    plot(y(1,:));
    hold on;
    plot(x_mavlink_local_position_ned_t);
    title('Pozitia x');
    xlabel('timp');
    ylabel('pozitie');

    subplot(2,1,2);
    plot(x(4,:));
    hold on;
    plot(vx_mavlink_local_position_ned_t);
    title('Viteza vx');
    xlabel('timp');
    ylabel('viteza'); 
    
    %se poate observa ca graficele sunt identice cu cele din scheletul
    %temei/primul grafic din rularea exercitiul1 (invariant pentru x si vx)
    %deci A,B,C au fost alese bine. Restul graficelor vor fi la fel cu cele
    %din state_space (cu timp invariant)
    
    