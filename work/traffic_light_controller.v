module traffic_light_controller(
    input  clk,
    input  rst_n,
    input [3:0] ss, fs,
    output reg [3:0] green, red, yellow
);

reg bouns;
reg [5:0] green_count;
reg [1:0] yellow_count;

// // Parameters for states
localparam T1G = 4'b1000;
localparam T1Y = 4'b1001;
localparam T2G = 4'b0100;
localparam T2Y = 4'b0101;
localparam T3G = 4'b0010;
localparam T3Y = 4'b0011;
localparam T4G = 4'b0001;
localparam T4Y = 4'b0000;

reg [3:0] next_state, current_state;
// Next State Logic
always @(*) begin
    case (current_state)
        T1G: begin
            if ((bouns && green_count==40) || (~bouns & green_count==30))
                next_state <= T1Y;
            else
                next_state <= T1G;
        end
        T1Y: begin
            if (yellow_count == 3) begin
                if (ss[1])
                    next_state <= T2G;
                else if (ss[2])
                    next_state <= T3G;
                else if (ss[3])
                    next_state <= T4G;
                else
                    next_state <= T1G;
            end
            else
                next_state <= T1Y;
        end
        T2G: begin
            if ((bouns && green_count==40) || (~bouns & green_count==30))
                next_state <= T2Y;
            else
                next_state <= T2G;
        end
        T2Y: begin
            if (yellow_count == 3) begin
                if (ss[2])
                    next_state <= T3G;
                else if (ss[3])
                    next_state <= T4G;
                else if (ss[0])
                    next_state <= T1G;
                else
                    next_state <= T2G;
            end
            else 
                next_state <= T2Y;
        end
        T3G: begin
            if ((bouns && green_count==40) || (~bouns & green_count==30))
                next_state <= T3Y;
            else
                next_state <= T3G;
        end
        T3Y: begin
            if (yellow_count == 3) begin
                if (ss[3])
                    next_state <= T4G;
                else if (ss[0])
                    next_state <= T1G;
                else if (ss[1])
                    next_state <= T2G;
                else
                    next_state <= T3G;
            end
            else
                next_state <= T3Y;
        end
        T4G: begin
            if ((bouns && green_count==40) || (~bouns & green_count==30))
                next_state <= T4Y;
            else
                next_state <= T4G;
        end
        T4Y: begin
            if (yellow_count == 3) begin
                if (ss[0])
                    next_state <= T1G;
                else if (ss[1])
                    next_state <= T2G;
                else if (ss[2])
                    next_state <= T3G;
                else
                    next_state <= T4G;
            end
            else
                next_state <= T4Y;
        end
        default: begin
            next_state <= T1G;
        end
    endcase
end

// State Memory
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= T1G;
    end     else begin
        current_state <= next_state;
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        green_count <= 0;
        yellow_count <= 0;
        bouns <= 0;
        green   = 4'b0001;
        red = 4'b1110;
        yellow  = 4'b0;
    end else begin
        case (current_state)
            T1G: begin
                yellow_count <= 0;
                green_count <= green_count + 1;
                red = 4'b1110; 
                green = 4'b0001;
                yellow = 4'b0000;
            end 
            T1Y: begin
                green_count <= 0;
                yellow_count <= yellow_count + 1;
                // bouns_achieved(0, bouns);
                // if (ss[0])
                //     if (fs[0])
                //         bouns <= 1;
                if (ss[1])
                    if (fs[1])
                        bouns <= 1;
                else if (ss[2])
                    if (fs[2])
                        bouns <= 1;
                else if (ss[3])
                    if (fs[3])
                        bouns <= 1;

                red = 4'b1110; 
                green = 4'b0000;
                yellow = 4'b0001;
            end 
            T2G: begin
                yellow_count <= 0;
                green_count <= green_count + 1;
                red = 4'b1101; 
                green = 4'b0010;
                yellow = 4'b0000;
            end 
            T2Y: begin
                green_count <= 0;
                yellow_count <= yellow_count + 1;

                if (ss[2])
                    if (fs[2])
                        bouns <= 1;
                else if (ss[3])
                    if (fs[3])
                        bouns <= 1;
                else if (ss[0])
                    if (fs[0])
                        bouns <= 1;

                red = 4'b1101; 
                green = 4'b0000;
                yellow = 4'b0010;
            end 
            T3G: begin
                yellow_count <= 0;
                green_count <= green_count + 1;
                red = 4'b1011; 
                green = 4'b0100;
                yellow = 4'b0000;
            end 
            T3Y: begin
                green_count <= 0;
                yellow_count <= yellow_count + 1;
                red = 4'b1011; 
                green = 4'b0000;
                yellow = 4'b0100;
                
                if (ss[3])
                    if (fs[3])
                        bouns <= 1;
                else if (ss[0])
                    if (fs[0])
                        bouns <= 1;
                else if (ss[1])
                    if (fs[1])
                        bouns <= 1;
            end 
            T4G: begin
                yellow_count <= 0;
                green_count <= green_count + 1;
                red = 4'b0111; 
                green = 4'b1000;
                yellow = 4'b0000;
            end 
            T4Y: begin
                green_count <= 0;
                yellow_count <= yellow_count + 1;
                red = 4'b0111; 
                green = 4'b0000;
                yellow = 4'b1000;
                
                if (ss[0])
                    if (fs[0])
                        bouns <= 1;
                else if (ss[1])
                    if (fs[1])
                        bouns <= 1;
                else if (ss[2])
                    if (fs[2])
                        bouns <= 1;
            end 
            default: begin
                green_count <= 0;
                yellow_count <= 0;
                bouns <= 0;
                green   = 4'b0000;
                red = 4'b1111;
                yellow  = 4'b0;
            end
        endcase
    end
end

endmodule