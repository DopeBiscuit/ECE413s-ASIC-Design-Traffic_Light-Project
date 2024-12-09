module traffic_light_controller(
    input  clk,
    input  rst_n,
    input [3:0] ss, fs,
    output reg [3:0] green, red, yellow
);
// T1 G--> 1000
// T2 G--> 0100
// T3 G--> 0010
// T4 G--> 0001

reg bouns;
reg [5:0] green_count;
reg [1:0] yellow_count;

// // Parameters for states
// parameter T1G = 4'b1000;
// parameter T1Y = 4'b1001;
// parameter T2G = 4'b0100;
// parameter T2Y = 4'b0101;
// parameter T3G = 4'b0010;
// parameter T3Y = 4'b0011;
// parameter T4G = 4'b0001;
// parameter T4Y = 4'b0000;

// Define states as an enum
    typedef enum logic [3:0] {
        T1G = 4'b0000, // T1 Green
        T1Y = 4'b0001, // T1 Yellow
        T2G = 4'b0010, // T2 Green
        T2Y = 4'b0011, // T2 Yellow
        T3G = 4'b0100, // T3 Green
        T3Y = 4'b0101, // T3 Yellow
        T4G = 4'b0110, // T4 Green
        T4Y = 4'b0111  // T4 Yellow
    } state_t;

state_t ns, cs;
// Next State Logic
always @(*) begin
    case (cs)
        T1G: begin
            if (bouns & green_count==40)
                ns = T1Y;
            else if (~bouns & green_count==30)
                ns = T1Y;
            else
                ns = T1G;
        end
        T1Y: begin
            if (yellow_count == 3) begin
                if (ss[1])
                    ns = T2G;
                else if (ss[2])
                    ns = T3G;
                else if (ss[3])
                    ns = T4G;
                else
                    ns = T1G;
            end
        end
        T2G: begin
            if (bouns & green_count==40)
                ns = T2Y;
            else if (~bouns & green_count==30)
                ns = T2Y;
            else
                ns = T2G;
        end
        T2Y: begin
            if (yellow_count == 3) begin
                if (ss[2])
                    ns = T3G;
                else if (ss[3])
                    ns = T4G;
                else if (ss[0])
                    ns = T1G;
                else
                    ns = T2G;
            end
        end
        T3G: begin
            if (bouns & green_count==40)
                ns = T3Y;
            else if (~bouns & green_count==30)
                ns = T3Y;
            else
                ns = T3G;
        end
        T3Y: begin
            if (yellow_count == 3) begin
                if (ss[3])
                    ns = T4G;
                else if (ss[0])
                    ns = T1G;
                else if (ss[1])
                    ns = T2G;
                else
                    ns = T3G;
            end
        end
        T4G: begin
            if (bouns & green_count==40)
                ns = T4Y;
            else if (~bouns & green_count==30)
                ns = T4Y;
            else
                ns = T4G;
        end
        T4Y: begin
            if (yellow_count == 3) begin
                if (ss[0])
                    ns = T1G;
                else if (ss[1])
                    ns = T2G;
                else if (ss[2])
                    ns = T3G;
                else
                    ns = T4G;
            end
        end
        default: begin
            ns = T1G;
        end
    endcase
end

// State Memory
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cs <= T1G;
    end else begin
        cs <= ns;
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
        case (cs)
            T1G: begin
                yellow_count <= 0;
                green_count <= green_count + 1;
                light_color(2'b00, 1);
            end 
            T1Y: begin
                green_count <= 0;
                yellow_count <= yellow_count + 1;
                bounce_achieved(0, bouns);
                light_color(2'b00, 0);
            end 
            T2G: begin
                yellow_count <= 0;
                green_count <= green_count + 1;
                light_color(2'b01, 1);
            end 
            T2Y: begin
                green_count <= 0;
                yellow_count <= yellow_count + 1;
                bounce_achieved(1, bouns);
                light_color(2'b01, 0);
            end 
            T3G: begin
                yellow_count <= 0;
                green_count <= green_count + 1;
                light_color(2'b10, 1);
            end 
            T3Y: begin
                green_count <= 0;
                yellow_count <= yellow_count + 1;
                bounce_achieved(2, bouns);
                light_color(2'b10, 0);
            end 
            T4G: begin
                yellow_count <= 0;
                green_count <= green_count + 1;
                light_color(2'b11, 1);
            end 
            T4Y: begin
                green_count <= 0;
                yellow_count <= yellow_count + 1;
                bounce_achieved(3, bouns);
                light_color(2'b11, 0);
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

// 2 -> 3 -> 0 -> 1
task bounce_achieved (input [1:0] t_num, output reg result);
    integer i;
    integer j;
    i = (t_num + 1) % 4;
    begin
        result = 0; 
        for (j = 0; j < 3; j = j + 1) begin
                // Check 1st sensor
                if (ss[i]) begin
                    // if sensor is on, then bounce is achieved
                    if (fs[i]) 
                        result = 1;
                    j = 3;
                end
            // Move to next sensor
            i = (i + 1) % 4;
        end
    end 
endtask

task light_color(input [1:0] t_num, input color); 
begin
    integer i;
    if (color == 0) begin
        red    = 4'b1111;
        green  = 4'b0000;
        yellow = 4'b0000;
        yellow[t_num] = 1;
        red[t_num] = 0;
    end 
    else begin
        // red
        red = 4'b1111; 
        red[t_num] = 0;
        // green
        green = 4'b0000;
        green[t_num] = 1;
        // yellow 
        yellow = 4'b0000;
    end
end
endtask

endmodule