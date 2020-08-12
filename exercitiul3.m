% VAIS Adela 325CD - Tema 3 - Teoria sistemelor

function exercitiul3 ()
    clear all
    ref = 'drone_log';
    cd = pwd;
    cd = fullfile(cd,ref);
    
    %citesc din fisier
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
    
    length_time = length(time_unix_usec_mavlink_system_time_t);
    deltaT(1) = 0;
    for i = 2 : length_time
        deltaT(i) = time_unix_usec_mavlink_system_time_t(i) - time_unix_usec_mavlink_system_time_t(i-1);
        deltaT(i) = deltaT(i) / 1000000;
    end
    
    dt = deltaT;
   
    %fk()
    fk_3axe()
    
    %se observa ca filtrul Kalman se apropie foarte mult de rezultatele
    %obtinute de senzori (diferente considerabile se observa doar in
    %calcularea pozitiei z si a vitezei vz), deoarece ia in calcul o
    %estimare noua la fiecare moment de timp
    
    %procedeul de filtrare este tocmai partea de actualizare a informatiei 
    %in functie de rezultatele obtinute la iteratia anterioara si folosirea
    %matricelor Q si P (si G) in modificarea raspunsului
    
    %filtrul Kalman functioneaza optim pentru sisteme care se apropie
    %foarte mult de un model matematic sau se stie exact ce tip de zgomot
    %actioneaza in sistem si poate fi calculat
    
    %matricile de covarianta: pentru rezultate mai bune, ar trebui ca P sa
    %fie matrice diagonala cu elementele egale cu dispersia anterioara 
end
