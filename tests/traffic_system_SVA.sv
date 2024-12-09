module traffic_system_SVA (
	input clk, rst_n ,
	input [3:0] input_ss ,input_fs ,input_red ,input_green ,input_yellow   
	);

//check reset
	always_comb begin 
		if(~rst_n)
			assert_rst: assert final(input_red == 4'b1110 && input_green == 4'b0001 && input_yellow == 4'b0000 );
	end

	ap_t1 : assert property
	 (@(posedge clk) disable iff (~rst_n) (input_ss == 4'b0001 && input_fs == 4'b0) 
	 	|=> input_red == 4'b1110 && input_green == 4'b0001 && input_yellow == 4'b0000 
	 	##30 input_red == 4'b1110 && input_green == 4'b0000 && input_yellow == 4'b0001);
    cv_t1 : cover property
	 (@(posedge clk) disable iff (~rst_n) (input_ss == 4'b0001 && input_fs == 4'b0) 
	 	|=> input_red == 4'b1110 && input_green == 4'b0001 && input_yellow == 4'b0000 
	 	##30 input_red == 4'b1110 && input_green == 4'b0000 && input_yellow == 4'b0001 );



endmodule : traffic_system_SVA