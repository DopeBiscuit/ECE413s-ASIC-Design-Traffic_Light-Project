import traffic_system_package::*;

module traffic_system_tb;

	logic clk ,rst_n;
	logic [3:0] input_ss ,input_fs ,input_red ,input_green ,input_yellow;

	int error_count ,correct_count;

	int i ;

    traffic_system_class ts;

    
	traffic_system DUT(.clk(clk),.rst_n(rst_n),
        .input_ss(input_ss),
        .input_fs(input_fs),
        .output_green(input_green),
        .output_red(input_red),
        .output_yellow(input_yellow));
	


	initial begin
		clk = 0;
		forever begin
			#1 clk = ~clk;
			ts.clk = clk;
		end 
	end

	
	 //check reset
	always_comb begin 
		if(~rst_n)
			assert_rst: assert final(input_red == 4'b1110 && input_green == 4'b0001 && input_yellow == 4'b0000 );
	end

	initial begin
		ts = new();
		error_count = 0;
		correct_count = 0;
		i =0;
		rst_n = 0;
		input_ss = 0;
		input_fs = 0;

		reference_model(ts);

		repeat(1000) begin
			assert(ts.randomize())
			@(negedge clk);
			input_ss = ts._1st;
			input_fs = ts._5th;
			rst_n = ts.rst;
			ts.red = input_red;
			ts.green = input_green;
			ts.yellow = input_yellow;
			reference_model(ts);
			check_output(ts);	
		end

		$display("at end of simulation error_count = %d and correct_count = %d",error_count, correct_count);
		$stop;
		
	end

	task check_output(traffic_system_class t);
		if(t.red !== input_red && t.green !== input_green && t.yellow !== input_yellow) begin
			error_count++;
			$display("error at %t 1st sensor = %b 5th sensor = %b red = %b green = %b yellow = %b exp_r=%b exp_g=%b exp_y=%b"
				,$time(), input_ss, input_fs, input_red, input_green, input_yellow, t.red, t.green ,t.yellow);	
			end
		else
			correct_count++;

	endtask : check_output

	task reference_model(traffic_system_class t_ref);
		
			if(~rst_n) begin
				repeat(30) begin
						@(posedge clk);
						t_ref.red = 4'b1111;
						t_ref.green = 4'b0000;
						t_ref.yellow = 4'b0000;
						t_ref.red[0] = 0;
						t_ref.green[0] = 1;	
					end 
					repeat(3) begin
						@(posedge clk);
						t_ref.red = 4'b1111;
						t_ref.green = 4'b0000;
						t_ref.yellow = 4'b0000;
						t_ref.red[0] = 0;
						t_ref.yellow[0] = 1;					
					end	
			end

			else begin

					if(~t_ref.red[0])
				    i = 1;
				    else if (~t_ref.red[1]) 
				    i = 2;
				    else if (~t_ref.red[2])
				    i = 3;
				    else
				    i = 0;

				if(input_ss[i])begin

				 if(input_fs[i])begin
					repeat(40) begin
						@(posedge clk);
						t_ref.red = 4'b1111;
						t_ref.green = 4'b0000;
						t_ref.yellow = 4'b0000;
						t_ref.red[i] = 0;
						t_ref.green[i] = 1;	
					end 
					repeat(3) begin
						@(posedge clk);
						t_ref.red = 4'b1111;
						t_ref.green = 4'b0000;
						t_ref.yellow = 4'b0000;
						t_ref.red[i] = 0;
						t_ref.yellow[i] = 1;					
					end
				 end

				 else begin
					repeat(30) begin
						@(posedge clk);
						t_ref.red = 4'b1111;
						t_ref.green = 4'b0000;
						t_ref.yellow = 4'b0000;
						t_ref.red[i] = 0;
						t_ref.green[i] = 1;	
					end 
					repeat(3) begin
						@(posedge clk);
						t_ref.red = 4'b1111;
						t_ref.green = 4'b0000;
						t_ref.yellow = 4'b0000;
						t_ref.red[i] = 0;
						t_ref.yellow[i] = 1;					
					end
				 end
		        end

		        else begin
		    	i = (i + 1) % 4;		
		        end
				
		end
	
	endtask

endmodule : traffic_system_tb