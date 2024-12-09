package traffic_system_package;

	class traffic_system_class;

		rand logic [3:0] _1st ,_5th ;
		logic clk; 
		rand logic rst;
		logic [3:0] red, green, yellow;

		constraint reset {
		rst dist{0:/2,1:/98};	
		}

		covergroup cg @(posedge clk);

			coverpoint _1st;
			coverpoint _5th;
			coverpoint red;
			coverpoint green;
			coverpoint yellow;

		endgroup : cg

		function new ();
			cg=new();
		endfunction 

	endclass : traffic_system_class
	
endpackage : traffic_system_package