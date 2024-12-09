module traffic_light(
        input wire [1 : 0] in_sensors,
        input wire [2 : 0] control,
        output wire [2 : 0] out_lights,
        output wire [1 : 0] out_sensors
    );
    
    // The first and fifth row sensors
    sensor s1s5 (in_sensors, out_sensors);
    
    // Light modules
    light  red      (control[0], out_lights[0]);
    light  yellow   (control[1], out_lights[1]);
    light  green    (control[2], out_lights[2]);
    
endmodule

module light (
        input wire io,
        output wire signal
    );
    assign signal = io;
endmodule

module sensor(
        input wire [1 : 0] sensors,
        output wire [1 : 0] signals
    );
    
    assign signals = sensors;
endmodule