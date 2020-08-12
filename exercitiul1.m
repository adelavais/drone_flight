% VAIS Adela 325CD - Tema 3 - Teoria sistemelor
function exercitiul1 ()
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
    
    %calculez intervalele de timp dintre masuratori
    length_time = length(time_unix_usec_mavlink_system_time_t);
    deltaT(1) = 0;
    for i = 2 : length_time
        deltaT(i) = time_unix_usec_mavlink_system_time_t(i) - time_unix_usec_mavlink_system_time_t(i-1);
        deltaT(i) = deltaT(i) / 1000000;
    end
    DeltaT = mean(deltaT);
    
    %pt timp invariant discret
    state_space()
    
    clear x y z
    DeltaT = 0;
    
    %pt timp variant discret
    state_variant()
    
    %se poate observa din graficele care compara pozitia si viteza reala cu
    %cea calculata ca zgomotul/imprecizia senzorului joaca un rol important
    %in calcularea acestora
    
    %exista diferente uriase intre ce transmit senzorii si rezultatele
    %calculate -- nu exista un estimator si calculele se fac fara a lua in
    %calcul zgomotul
    
    %in general graficele pentru timp invariant au mai putine perturbatii,
    %insa nu exista diferente majore intre rezultatele date prin calcularea
    %timpului invariant fata de variant
    
end