module asynccounter #(parameter N = 4) 
	(input clk, clr, output [N-1:0] count);
	
	genvar i;
	wire [N-1:0] qbar;
	
	generate 
		for (i = 0; i < N; i = i+1) begin : flipflops
			if (i==0)
				t_FF stage(clk, 1, clr, count[i], qbar[i]);
			else
				t_FF stage(qbar[i-1], 1, clr, count[i], qbar[i]);
		end
	endgenerate
endmodule

module counterTFF #(parameter N = 4) 
	(input clk, clr, output [N-1:0] count);
	
	genvar i;
	
	wire [N-1:0] toggles;
	assign toggles[0] = 1;
	
	generate 
		for (i = 0; i < N; i = i+1) begin : flipflops
			if (i!=0)
				and andstage(toggles[i], count[i-1],toggles[i-1]); 
				
			t_FF stage(clk, toggles[i], clr, count[i], );
		end
	endgenerate
endmodule

module counterBehav  #(parameter N = 4) 
	(input clk, clr, output reg [N-1:0] count);
	
	always @(posedge clk or posedge clr) begin
		if (clr)
			count <= 0;
		else 
			count <= count+1'b1;
	end
	
endmodule

 
 
module t_FF (input clk, T, clr, output q, q_bar);
	
//	dff primff (T&~q|~T&q, clk, ~clr,1,q); //need to include in modelSim libraries
	d_FF myff (T&~q|~T&q, clk, ~clr,q);
	assign q_bar = ~q;
endmodule 


module d_FF (input d, clk, clr_n, output reg q);
	
	always @(posedge clk or negedge clr_n) begin
		if (clr_n == 0)
			q <= 1'b0;
		else
			q <= d;
	end

endmodule 




