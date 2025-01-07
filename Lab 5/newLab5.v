module ClockDivider(cin,cout,sw9);
     // Based on (corrected) code from fpga4student.com
     // cin is the input clock; if from the DE10-Lite,
     // the input clock will be at 50 MHz
     // The clock divider toggles cout every 25 million
     // cycles of the input clock
     input cin,sw9;
     output reg cout;
     reg[31:0] count, D;    
    
         always @(posedge cin)
         begin
         count <= count + 32'd1;
			  D = sw9 ? 32'd2500000 : 32'd50; //If SW9 is on toggle cout every 50 cycles (1 us with 50MHz). If off toggle every 5 million cycles (100 ms with 50MHz)
             if (count >= (D-1)) begin
               cout <= ~cout; 
                count <= 32'd0;
             end
         end
endmodule
    
module topmod(clk,led[7:0],cout,clr,sw[1:0]);

    output reg [7:0] led;
    
    input cout,clk,clr;

    input [1:0] sw;

    wire [7:0] count1,count2,count3;
    
    asynccounter #(8) (cout, clr, count1[7:0]);
    counterTFF #(8) (cout, clr, count2[7:0]);
    counterBehav #(8) (cout, clr, count3[7:0]);
   	 
	 
        always @(posedge clk)
        begin
            case(sw)
            2'b01: begin
                led<=count1;
            end
            
            2'b10: begin
                led<=count2;
            end
            
            2'b11: begin
                led<=count3;
            end
            endcase
    end
    
endmodule


module lfsr (R, L, Clock, Q);
	input [0:4] R;
	input L, Clock;
	output [0:4] Q;
	reg [0:4] Q;
		always @(posedge Clock) begin
			if (L)
				Q <= R;
			else
			begin
				Q[0] = Q[4];
				Q[1] = Q[0] ^ Q[4];
				Q[2] = Q[1];
				Q[3] = Q[2];
				Q[4] = Q[3];
			end
		end
endmodule








/*
module shift_reg(clk, rst, load, data_in, data_out);

	input clk, rst, load;
	input [4:0] data_in;
	output reg [4:0] data_out;
	wire feedback;
	
	assign feedback = data_out[4] ^ data_out[1]; // feedback polynomial = x^5 + x^2 + 1
	
	always @ (posedge rst or posedge clk) begin // async and active-high reset signal
	
		if (rst == 1'b1) begin
			data_out <= 5'b01010; // any number where the 2nd and 5th bits are not equal
		end else if (load == 1'b1) begin
			data_out <= data_in; // parallel data
		end else begin
			data_out <= {feedback, data_out[4:1]}; // shift and feedback
		end
			
	end

endmodule
*/