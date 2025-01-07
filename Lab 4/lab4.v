module lab4(HEX0[7:0],HEX1[7:0],cin,button[1:0],sw);

	output [7:0] HEX0,HEX1;
	input cin, sw;
	input [1:0] button;

	wire [7:0] cout;
	reg [7:0] f,g;
	wire flash;
	reg ledFlash;


	ClockDivider(cin,cout,flash,button[1:0],sw);

	// Decrementer (cout) is used as an event that changes f and g based on what integers should be displayed on the HEX LEDs
	// f used for the first digit, g used for the second
	always @(cout) begin
		case(cout)
			8'b00011110    : begin //f = 3, g = 0
				f = 7'b10110000;g = 7'b11000000;
			end
			8'b00011101    : begin //f = 2, g = 9
				f = 7'b10100100;g = 7'b10010000;
			end
			8'b00011100    : begin //f = 2, g = 8
				f = 7'b10100100;g = 7'b10000000;
			end
			8'b00011011    : begin //f = 2, g = 7
				f = 7'b10100100;g = 7'b11111000;
			end
			8'b00011010    : begin //f = 2, g = 6
				f = 7'b10100100;g = 7'b10000010;
			end
			8'b00011001    : begin //f = 2, g = 5
				f = 7'b10100100;g = 7'b10010010;
			end
			8'b00011000    : begin //f = 2, g = 4
				f = 7'b10100100;g = 7'b10011001;
			end
			8'b00010111    : begin //f = 2, g = 3
				f = 7'b10100100;g = 7'b10110000;
			end
			8'b00010110    : begin //f = 2, g = 2
				f = 7'b10100100;g = 7'b10100100;
			end
			8'b00010101    : begin //f = 2, g = 1
				f = 7'b10100100;g = 7'b11111001;
			end
			8'b00010100    : begin //f = 2, g = 0
				f = 7'b10100100;g = 7'b11000000;
			end
			8'b00010011    : begin //f = 1, g = 9
				f = 7'b11111001;g = 7'b10010000;
			end
			8'b00010010    : begin //f = 1, g = 8
				f = 7'b11111001;g = 7'b10000000;
			end
			8'b00010001    : begin //f = 1, g = 7
				f = 7'b11111001;g = 7'b11111000;
			end
			8'b00010000    : begin //f = 1, g = 6
				f = 7'b11111001;g = 7'b10000010;
			end
			8'b00001111    : begin //f = 1, g = 5
				f = 7'b11111001;g = 7'b10010010;
			end
			8'b00001110    : begin //f = 1, g = 4
				f = 7'b11111001;g = 7'b10011001;
			end
			8'b00001101    : begin //f = 1, g = 3
				f = 7'b11111001;g = 7'b10110000;
			end
			8'b00001100    : begin //f = 1, g = 2
				f = 7'b11111001;g = 7'b10100100;
			end
			8'b00001011    : begin //f = 1, g = 1
				f = 7'b11111001;g = 7'b11111001;
			end
			8'b00001010    : begin //f = 1, g = 0
				f = 7'b11111001;g = 7'b11000000;
			end
			8'b00001001    : begin //f = 0, g = 9
				f = 7'b11000000;g = 7'b10010000;
			end
			8'b00001000    : begin //f = 0, g = 8
				f = 7'b11000000;g = 7'b10000000;
			end
			8'b00000111    : begin //f = 0, g = 7
				f = 7'b11000000;g = 7'b11111000;
			end
			8'b00000110    : begin //f = 0, g = 6
				f = 7'b11000000;g = 7'b10000010;
			end
			8'b00000101    : begin //f = 0, g = 5
				f = 7'b11000000;g = 7'b10010010;
			end
			8'b00000100    : begin //f = 0, g = 4
				f = 7'b11000000;g = 7'b10011001;
			end
			8'b00000011    : begin //f = 0, g = 3
				f = 7'b11000000;g = 7'b10110000;
			end
			8'b00000010    : begin //f = 0, g = 2
				f = 7'b11000000;g = 7'b10100100;
			end
			8'b00000001    : begin //f = 0, g = 1
				f = 7'b11000000;g = 7'b11111001;
			end
			8'b00000000    : begin //f = 0, g = 0
				f = 7'b11000000;g = 7'b11000000;
			end
		endcase
		// Countdown is finished, decimal must be flashed on display
		if(cout == 0) begin
			ledFlash = flash;
		end else begin
			ledFlash = 1;
		end
	end
	
	// Bits are assigned to the 7-segment display to display the correct integer
	assign HEX0[0] = g[0];
	assign HEX0[1] = g[1];
	assign HEX0[2] = g[2];
	assign HEX0[3] = g[3];
	assign HEX0[4] = g[4];
	assign HEX0[5] = g[5];
	assign HEX0[6] = g[6];
	assign HEX0[7] = ledFlash;
	
	assign HEX1[0] = f[0];
	assign HEX1[1] = f[1];
	assign HEX1[2] = f[2];
	assign HEX1[3] = f[3];
	assign HEX1[4] = f[4];
	assign HEX1[5] = f[5];
	assign HEX1[6] = f[6];
	assign HEX1[7] = 1;
 
endmodule


module ClockDivider(cin,cout,flash,button[1:0],sw);
	input cin,sw;
	input [1:0] button;
	output reg[7:0] cout = 8'b00011000;
	output reg flash;
	reg pause = 1;
 	reg init_flag = 1;
 	reg[31:0] count,count2; // count used for timer countdown, count2 used for flashing LED every 0.5 seconds
	parameter D1 = 32'd50000000; // Every 50 million cycles, 1 second passes
	parameter D2 = 32'd25000000; // Every 25 million cycles, 0.5 seconds pass

	// Checks when button[1] is pressed to pause the timer
	always @(negedge ~button[1]) begin
		pause = ~pause;
	end

	// posedge of clock used to count down each second
	always @(posedge cin)
	begin
		
		// Both counts are incremented by 1 each time a second passes
		count <= count + 32'd1;
		count2 <= count2 + 32'd1;
		
		// If decrementer’s value is 24 and switch is in upwards position, decrementer is initialized to 30
		if(cout == 8'b00011000 && sw && (init_flag == 1)) begin
			cout = 8'b00011110;
			init_flag = 0;  // if statement only runs the first time the code is blasted
		// If decrementer’s value is 30 and switch is in downwards position, decrementer is initialized to 24
		end else if (cout == 8'b00011110 && ~sw && (init_flag == 1)) begin
			cout = 8'b00011000;
			init_flag = 0; // if statmenet only runs the first time the code is blasted
		end

		// If reset button is hit, check to see if the switch is up to reset decrementer to 30
		if(~button[0] && sw)begin
			cout = 8'b00011110;
		// If reset button is hit, check to see if the switch is down to reset the decrementer to 24
		end else if(~button[0] && ~sw)begin
			cout = 8'b00011000;
		end

		//If our counter variable becomes equal to or greater than 50000000, one second has gone by. Subtract one from the decrementer and then reset our clock counter.
		if (count >= (D1-1)) begin
			//Aslong as our decrementer is greater than 0 and we aren't in a pause state (pause = 0) then subtract one.
			if (cout > 8'b00000000 && (pause == 1)) begin
				cout <= cout - 8'b00000001;
			end
			count <= 32'd0;
		end
		//If our counter variable becomes equal to or greater than 25000000, 0.5 seconds has gone by. Complement the 'flash' variable every 0.5 seconds and reset the count afterwards to begin counting to 25000000 again.
		if (count2 >= (D2-1)) begin
			flash = ~flash;
			count2 <= 32'd0;
		end
	end
endmodule
