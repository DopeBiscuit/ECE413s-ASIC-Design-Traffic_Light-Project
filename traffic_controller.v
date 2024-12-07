module traffic_controller(
    input wire [7 : 0] sensors,
    output wire [7 : 0] lights
);

    // Clock signal
    reg clk = 0;
    always 
        #5 clk = ~clk;

    // Internal state signals
    reg [3 : 0] state = 4'b0000;
    reg [3 : 0] next_state = 4'b0000;
    reg [1 : 0] t_sensors = sensors;

    // Output signals
    always @(posedge clk) begin
        state <= next_state;
    end

    // State machine
    always @(*) begin
        // If the traffic light is red
        if(!state[0]) begin
            // If sensor 1 is on 
            if(t_sensors[0]) 
                next_state = {state[3 : 1], 1'b1};  // Turn traffic
            else begin
                // else goto next red traffic light
                next_state = {state[3 : 2] + 1, 2'b00};
                t_sensors = sensors >> (next_state[3 : 2] * 2); // Read sensors of next traffic light
            end
        end
        // If traffic light is not red
        else begin
            // Traffic light is not yellow
            if(!state[1]) begin
                // Yellow if(count is 40 and sensor 5 is on) or if(count is 30 and sensor 5 is off)
                state[1] = (!t_sensors[1] && (cnt == 30)) || (t_sensors[1] && (cnt == 40));
                // reset cnt
            end
            // Traffic light is yellow
            else begin
                // If count is 3
                if(cnt == 3) begin
                    // Goto next traffic light, make all traffic lights red
                    next_state = {state[3 : 2] + 1, 2'b0};
                    t_sensors = sensors >> (next_state[3 : 2] * 2);
                end
            end
        end
    end

    // Output logic
    always @(*) begin
        lights = 0;
        lights[state[3:2] * 2 + 1 : state[3:2] * 2] = state[1 : 0];
    end

endmodule