/*
	// Usage - Replace opx with actual signals in top module
	Adaptor_display display(.clk(op0), 				// system clock
							.input_value(op1),		// 8-bit input [7:0] value to display
							.disp_en(op2),			// output [3:0] 7 segment display enable
							.seg7_output(op3));		// output [6:0] 7 segment signals
*/

/*
*	Top module for the adaptor displays. Instantiate this module as shown above in your design
*/
module Adaptor_display(input logic clk, input logic [15:0] input_value, output logic [3:0] disp_en, output logic [6:0]seg7_output);
	
	logic  refresh_clock;							// 10KHz refresh clock for displays
	logic  [1:0] current_display;					// Indicates the active display
	logic  [6:0] output_digit;					// digit displayed on active display
	logic  [6:0] digit3, digit2, digit1, digit0;	// 4 digits for each of the 4 displays
	
							
	// Generate a 10KHz switching frequency clock for the displays
	clockDivider10KHz refreshClock(	.clk(clk),
								.divided_clk(refresh_clock));
	
	// Change the active display
	displaySelector dSelect(.refresh_clk(refresh_clock),
							.dispSelect(current_display));
	
	// Activate the selected active display 
	activateDisplay dispEn(	.dispSelect(current_display),
							.dispID(disp_en));

    // hex decoder called for the digits
	hex_decoder first(.clk(clk),.hex_digit(input_value[3:0]),.segments(digit0));
	hex_decoder second(.clk(clk),.hex_digit(input_value[7:4]),.segments(digit1));
	hex_decoder third(.clk(clk),.hex_digit(input_value[11:8]),.segments(digit2));
	hex_decoder fourth(.clk(clk),.hex_digit(input_value[15:12]),.segments(digit3));


	
	// Choose the correct digit for the current active display
	bcdSelector bcd_select(	.x0(digit0), 
							.x1(digit1),
							.x2(digit2),
							.x3(digit3),
							.s(current_display),
							.y(output_digit));
	
	// Set teh corresponding segments for the selected 4-bit digit
	bcdTo7Segment bcd1(	.x(output_digit), 
						.curr_disp(current_display),
						.seg(seg7_output));

endmodule

/*
*	Generates a 10KHz switching frequency clock for the displays
*/
module clockDivider10KHz(input logic clk, output logic divided_clk);
	
	localparam div_value = 6249; // 6249 for 10KHz desired frequency
	// div_value = 125MHz / (2 * desired_freq) - 1
	integer counter_value = 0;
	always@ (posedge clk)
		begin
			if(counter_value == div_value) begin
				divided_clk <= ~divided_clk;
				counter_value <= 0;
				end
			else begin
				divided_clk <= divided_clk;
				counter_value <= counter_value + 1;
				end
		end

endmodule

/*
*	Changes the selected display based on the switching frequency
*/
module displaySelector(input logic refresh_clk, output logic [1:0] dispSelect);
	always @(posedge refresh_clk)
		dispSelect <= dispSelect + 1;
endmodule

/*
*	Activates the selected display 
*/
module activateDisplay(input logic [1:0] dispSelect, output logic [3:0] dispID);
	always@ (dispSelect)
		begin
			case(dispSelect)
				2'b00: dispID = 4'b1110;
				2'b01: dispID = 4'b1101;
				2'b10: dispID = 4'b1011;
				2'b11: dispID = 4'b0111;
				default:  dispID = 4'b1111;
			endcase
		end
endmodule

/*
*	Converts an 8-bit number into several digits as needed
*/

module hex_decoder(input logic clk,input logic [3:0] hex_digit, output logic [6:0] segments);
    always @(posedge clk)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b1111_001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'b000_000;
        endcase
endmodule


/*
*	Selects the correct digit to write to the active display
*/
module bcdSelector(input logic [6:0] x0, input logic [6:0] x1, input logic [6:0] x2, 
					input logic [6:0] x3, input logic [1:0] s, output logic [6:0]y);
	
	always@(x0, x1, x2, x3, s)
		case(s)
			0: y = x0;
			1: y = x1;
			2: y = x2;
			3: y = x3;
			default: y = 6'bxx;
		endcase
	
endmodule


/*
*	Write the hex value to the activateDisplay
*/

module bcdTo7Segment(input logic [6:0] x, input logic [1:0] curr_disp, output logic [6:0] seg);
	always @(x,curr_disp) begin						
	   seg[6] = x[6];
	   seg[5] = x[5];
	   seg[4] = x[4];
	   seg[3] = x[3];
	   seg[2] = x[2];
	   seg[1] = x[1];
	   seg[0] = x[0];
	end
endmodule
