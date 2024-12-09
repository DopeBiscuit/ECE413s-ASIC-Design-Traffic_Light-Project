module traffic_system(
            input wire clk,
            input wire rst_n,
            input wire [3 : 0] input_ss,
            input wire [3 : 0] input_fs,
            output wire [3 : 0] input_red,
            output wire [3 : 0] input_green,
            output wire [3 : 0] input_yellow
        );

    // Internal signal 
    wire [3 : 0] internal_ss;
    wire [3 : 0] internal_fs;
    wire [3 : 0] internal_red;
    wire [3 : 0] internal_green;
    wire [3 : 0] internal_yellow;

    // Instances
    lightController lightControllerInst(
        .clk(clk),
        .rst(rst_n),
        .ss(internal_ss),
        .fs(internal_fs),
        .green(internal_green),
        .red(internal_red),
        .yellow(internal_yellow)
    );

    // Traffic lights
    trafficLight T1(
        .in_sensors({input_fs[0], input_ss[0]}),
        .control({input_green[0], input_yellow[0], input_red[0]}),
        .out_lights({internal_green[0], internal_yellow[0], internal_red[0]}),
        .out_sensors({internal_fs[0], internal_ss[0]})
    );

    trafficLight T2(
        .in_sensors({input_fs[1], input_ss[1]}),
        .control({input_green[1], input_yellow[1], input_red[1]}),
        .out_lights({internal_green[1], internal_yellow[1], internal_red[1]}),
        .out_sensors({internal_fs[1], internal_ss[1]})
    );

    trafficLight T3(
        .in_sensors({input_fs[2], input_ss[2]}),
        .control({input_green[2], input_yellow[2], input_red[2]}),
        .out_lights({internal_green[2], internal_yellow[2], internal_red[2]}),
        .out_sensors({internal_fs[2], internal_ss[2]})
    );

    trafficLight T4(
        .in_sensors({input_fs[3], input_ss[3]}),
        .control({input_green[3], input_yellow[3], input_red[3]}),
        .out_lights({internal_green[3], internal_yellow[3], internal_red[3]}),
        .out_sensors({internal_fs[3], internal_ss[3]})
    );

endmodule