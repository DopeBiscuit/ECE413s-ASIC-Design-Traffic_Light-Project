import traffic_system_package::*;

module traffic_system_tb;

	logic clk ,rst_n;
	logic [3:0] input_ss ,input_fs ,input_red ,input_green ,input_yellow;

	int error_count ,correct_count;

    traffic_system_class ts;

	traffic_system DUT(.*);
	//bind  traffic_system traffic_system_SVA sva_inst(.*);

	initial begin
		clk = 0;
		forever begin
			#1 clk = ~clk;
			ts.clk = clk;
		end 
	end

	initial begin
		error_count = 0;
		correct_count = 0;
		rst_n = 0;
		input_ss = 0;
		input_fs = 0;

		ts = new();


		repeat(100) begin
			@(negedge clk);
			assert(ts.randomize());
			input_ss = ts._1st;
			input_fs = ts._5th;
			rst_n = ts.rst;
			reference_model(ts);	
		end

		$display("at end of simulation error_count = %d and correct_count = %d",error_count, correct_count);
		$stop;
		
	end

	task check_output(traffic_system_class t);
		if(t.red !== input_red && t.green !== input_green && t.yellow !== input_yellow) begin
			error_count++;
			$display("error at %t 1st sensor = %b 5th sensor = %b red = %b green = %b yellow = %b"
				,$time(), input_ss, input_fs, input_red, input_green, input_yellow);	
			end
		else
			correct_count++;

	endtask : check_output

	task reference_model(traffic_system_class t_ref);
		int i ;

		for(i=0 ; i<=10 ; i++) begin

			if(~rst_n) begin
				t_ref.red = 4'b1110;
				t_ref.green = 4'b0001;
				t_ref.yellow = 4'b0000;	
			end

			else begin
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

		    i = (i + 1) % 4;
				
			end

			check_output(t_ref);
	
		end
		
	endtask

endmodule : traffic_system_tb