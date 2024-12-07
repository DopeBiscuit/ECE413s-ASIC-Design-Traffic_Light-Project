module trafficLight(
        input wire [2 : 0] control,
        output wire [1 : 0] sensors
    );
    
    // The first and fifth row sensors
    sensor s1s5 (sensors);
    
    // Light modules
    light #(0) red      (control[2]);
    light #(1) yellow   (control[1]);
    light #(2) green    (control[0]);
    
endmodule

module light (
        input wire io
    );
    parameter N = 0;
    always @(io) begin
        $display("Light %d toggled!", N);
    end    
endmodule

module sensor(
        output wire [1 : 0] signals
    );
    assign signal = $urandom;
endmodule