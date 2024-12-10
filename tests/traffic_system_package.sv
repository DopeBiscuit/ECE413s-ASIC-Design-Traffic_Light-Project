package traffic_system_package;

	class traffic_system_class;

		rand logic [3:0] _1st ,_5th ;
		bit clk; 
		rand bit rst;
		logic [3:0] red, green, yellow;

		constraint reset {
		rst dist{0:/2,1:/98};	
		}

		constraint _1st_5th {
			(~_1st[0]) -> _5th[0]==0;
			(~_1st[1]) -> _5th[1]==0;
			(~_1st[2]) -> _5th[2]==0;
			(~_1st[3]) -> _5th[3]==0;
		}

		constraint ss {
		_1st dist{0:/10,[1:15]:/90};	
		}

		constraint fs {
		_5th dist{0:/70,[1:15]:/30};	
		}

		covergroup cg @(posedge clk);

			coverpoint _1st;
			coverpoint _5th;
			coverpoint red{
				bins t1 = {4'b1110};
				bins t2 = {4'b1101};
				bins t3 = {4'b1011};
				bins t4 = {4'b0111};
			}
			coverpoint green{
				bins t1 = {4'b0001};
				bins t2 = {4'b0010};
				bins t3 = {4'b0100};
				bins t4 = {4'b1000};
				bins zero = {4'b0000};
			}
			coverpoint yellow{
				bins t1 = {4'b0001};
				bins t2 = {4'b0010};
				bins t3 = {4'b0100};
				bins t4 = {4'b1000};
				bins zero = {4'b0000};
			}

		endgroup : cg

		function new ();
			cg=new();
		endfunction 

	endclass : traffic_system_class
	
endpackage : traffic_system_package