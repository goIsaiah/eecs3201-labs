module lab3(sw[9:0],hex5[7:0],hex3[7:0],hex0[7:0],hex1[7:0]);

/*
	Legend =================================================|
	Switches 0-3 will control HEX3 - a1
	Switches 4-7 will control HEX5 - a0
	Switch 9  represents which operation to execute
	sw[9] = 1 means subtraction sw[9] = 0 means addition
	Sum or difference of a0 and a1 on HEX0 with cout on HEX1
	========================================================|
*/

	//Declare inputs,outputs, wires and reg that are used throughout module
	input [9:0] sw;
	output [7:0] hex5, hex3, hex1, hex0;
	
	wire [3:0] sum;
	reg [3:0] S;
	wire carryout;
	wire [4:1] C;

	
	
	//Display hex numbers on hex displays 5 and 3 depending on the corresponding switches that have been turned on or off
	lab2_b(sw[7:4],hex5[7:0]);
	lab2_b(sw[3:0],hex3[7:0]);

	//Preform arithemtic calculation storing the result in `sum` and the final Cout in `carryout`
	fulladd stage0 (sw[9],sw[4],sw[0],sum[0],C[1],sw[9]);
   fulladd stage1 (C[1], sw[5], sw[1], sum[1], C[2],sw[9]);
   fulladd stage2 (C[2], sw[6], sw[2], sum[2], C[3],sw[9]);
	fulladd stage3 (C[3], sw[7], sw[3], sum[3], carryout,sw[9]);
	
	//Whenever a change in sign (sw[9]) occurs, check to see if our sum is in 2's complement. If it is in 2's turn it back to a regular 4 bit number
	always @(sw[9])begin
		if(~carryout & sw[9]) S = ~sum + 1;
		else S = sum;	
	end
	
	//Display our result on hex0
	lab2_b(S[3:0],hex0[7:0]);
	
	//Depending on whether we are doing addition or subtraction and the final carry value, display nothing, a 1 or minus sign accordingly
   assign hex1[0] = 1;
	assign hex1[1] = sw[9] | ~carryout;
	assign hex1[2] = sw[9] | ~carryout;
	assign hex1[3] = 1;
	assign hex1[4] = 1;
	assign hex1[5] = 1;		
	assign hex1[6] = ~sw[9] | carryout;
	assign hex1[7] = 1;
	
endmodule



//Displaying hex numbers onto hex displays depending on 4 bit register | Module taken from out Lab #2
module lab2_b(sw[3:0],hex[7:0]);
	
	// Initializing the inputs and outputs with multi-bit buses
	input [3:0] sw;
	output [7:0] hex;
	
	// Truth statements for the turning on LED segments
	assign hex[0] = sw[0]&~sw[1]&~sw[2]&~sw[3] | ~sw[0]&~sw[1]&sw[2]&~sw[3] | sw[0]&sw[1]&~sw[2]&sw[3] | sw[0]&~sw[1]&sw[2]&sw[3];
	assign hex[1] = sw[0]&~sw[1]&sw[2]&~sw[3]  | ~sw[0]&sw[1]&sw[2]&~sw[3]  | sw[0]&sw[1]&~sw[2]&sw[3] | ~sw[0]&~sw[1]&sw[2]&sw[3] | ~sw[0]&sw[1]&sw[2]&sw[3] | sw[0]&sw[1]&sw[2]&sw[3];
	assign hex[2] = ~sw[0]&sw[1]&~sw[2]&~sw[3] | sw[2]&sw[3]&sw[1] | sw[2]&sw[3]&~sw[0];
	assign hex[3] = sw[0]&~sw[1]&~sw[2]&~sw[3] | ~sw[0]&~sw[1]&sw[2]&~sw[3] | sw[0]&sw[1]&sw[2]&~sw[3] | ~sw[0]&sw[1]&~sw[2]&sw[3] | sw[0]&sw[1]&sw[2]&sw[3];
	assign hex[4] = sw[0]&~sw[1]&~sw[2]&~sw[3] | sw[0]&sw[1]&~sw[2]&~sw[3]  |~sw[0]&~sw[1]&sw[2]&~sw[3]| sw[0]&~sw[1]&sw[2]&~sw[3] | sw[0]&sw[1]&sw[2]&~sw[3] | sw[0]&~sw[1]&~sw[2]&sw[3];
	assign hex[5] = sw[0]&~sw[1]&~sw[2]&~sw[3] | ~sw[0]&sw[1]&~sw[2]&~sw[3] | sw[0]&sw[1]&~sw[2]&~sw[3]| sw[0]&sw[1]&sw[2]&~sw[3]  | sw[0]&~sw[1]&sw[2]&sw[3];
	assign hex[6] = ~sw[0]&~sw[1]&~sw[2]&~sw[3]| sw[0]&~sw[1]&~sw[2]&~sw[3] | sw[0]&sw[1]&sw[2]&~sw[3] | ~sw[0]&~sw[1]&sw[2]&sw[3];
	
	//hex7 set to 1, turns the dot on the 7 segment LED display off
	assign hex[7] = 1;

endmodule



//Full adder/subtractor module (sign is whether we are adding(1) or subtracting(0))
module fulladd(Cin, x, y, s, Cout, sign);

	input Cin, x, y, sign;
	output s, Cout; 
	assign s = x ^ (y^sign) ^ Cin;
	assign Cout = (x & (y^sign)) | (x & Cin) | ((y^sign) & Cin);
	
endmodule

