/* This file contains all parts of the lab. This file consists of two modules, the first using 4 switches and 8 segments as individual inputs and outputs, the second module using multi-bit buses. 
   The reduction of one of the hex segmenet assignments is done in the first module.
   EECS 3201 Section E - Lab #2 | Group 04B
*/ 

//First part of the lab + reduction for hex2
module lab2_a(sw0,sw1,sw2,sw3,hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7);
	
   	// Initializing the 4 switches as individual inputs and 7 segments as indivdual outputs
	input sw0,sw1,sw2,sw3;
	output hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7;
	
	// Truth statements for the turning on LED segments
	assign hex0 = sw0&~sw1&~sw2&~sw3 | ~sw0&~sw1&sw2&~sw3 | sw0&sw1&~sw2&sw3 | sw0&~sw1&sw2&sw3;
	assign hex1 = sw0&~sw1&sw2&~sw3  | ~sw0&sw1&sw2&~sw3  | sw0&sw1&~sw2&sw3 | ~sw0&~sw1&sw2&sw3 | ~sw0&sw1&sw2&sw3 | sw0&sw1&sw2&sw3;
	//assign hex2 = ~sw0&sw1&~sw2&~sw3 | ~sw0&~sw1&sw2&sw3  | ~sw0&sw1&sw2&sw3 | sw0&sw1&sw2&sw3; --- Non Reduced assignment
	//---------------------------------------------------------------------------------------------------------------------------------
	// Reduced statement:
	assign hex2 = ~sw0&sw1&~sw2&~sw3 | sw2&sw3&sw1 | sw2&sw3&~sw0;
	// Reduction (with steps):
	// hex2 = ~sw0&sw1&~sw2&~sw3 | ~sw0&~sw1&sw2&sw3  | ~sw0&sw1&sw2&sw3 | sw0&sw1&sw2&sw3;
	// 	= ~sw0&sw1&~sw2&~sw3 | ~sw0&sw2&sw3&(~sw1 | sw1) | sw0&sw1&sw2&sw3;
	//	= ~sw0&sw1&~sw2&~sw3 | ~sw0&sw2&sw3&1 | sw0&sw1&sw2&sw3;
	//	= ~sw0&sw1&~sw2&~sw3 | ~sw0&sw2&sw3 | sw0&sw1&sw2&sw3;
	//	= ~sw0&sw1&~sw2&~sw3 | sw2&sw3&(sw0&sw1 | ~sw0);
	//	= ~sw0&sw1&~sw2&~sw3 | sw2&sw3&(sw1 | ~sw0);
	//	= ~sw0&sw1&~sw2&~sw3 | sw2&sw3&sw1 | sw2&sw3&~sw0;
	//---------------------------------------------------------------------------------------------------------------------------------
	assign hex3 = sw0&~sw1&~sw2&~sw3 | ~sw0&~sw1&sw2&~sw3 | sw0&sw1&sw2&~sw3 | ~sw0&sw1&~sw2&sw3 | sw0&sw1&sw2&sw3;
	assign hex4 = sw0&~sw1&~sw2&~sw3 | sw0&sw1&~sw2&~sw3  |~sw0&~sw1&sw2&~sw3| sw0&~sw1&sw2&~sw3 | sw0&sw1&sw2&~sw3 | sw0&~sw1&~sw2&sw3;
	assign hex5 = sw0&~sw1&~sw2&~sw3 | ~sw0&sw1&~sw2&~sw3 | sw0&sw1&~sw2&~sw3| sw0&sw1&sw2&~sw3  | sw0&~sw1&sw2&sw3;
	assign hex6 = ~sw0&~sw1&~sw2&~sw3| sw0&~sw1&~sw2&~sw3 | sw0&sw1&sw2&~sw3 | ~sw0&~sw1&sw2&sw3;
	
	//hex7 set to 1, turns the dot on the 7 segment LED display off
	assign hex7 = 1;

endmodule


//Part 3 of the lab, uses multi-but buses for the inputs and outputs
/*
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
*/
