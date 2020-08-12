    % VAIS Adela 325CD - Tema 3 - Teoria sistemelor
    clear all
    ref = 'drone_log';
    cd = pwd;
    cd = fullfile(cd,ref);
    
    %daca fisierul exista, citesc datele din el
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
    
    homecoming()
    homecoming_3axe()
   