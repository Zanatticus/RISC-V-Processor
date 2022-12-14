`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//
// Author: James Brock
// Copyright Northeastern University 2010
// Modified by: Majid Sabbagh with help of Tlalit Bruno
//////////////////////////////////////////////////////////////////////////////////
module debounce (
   input logic clk_in,
   input logic rst_in,
   input logic sig_in,
   output logic sig_debounced_out);
   
   parameter NDELAY = 25000000;
   parameter NBITS = 26;

   logic [NBITS-1:0] count0;
   logic [NBITS-1:0] count1;
   logic xnew0;
   logic xnew1;
   logic toggle0;
   logic toggle1;
   
   logic RST_in;
   logic cnt_done0;
   logic cnt_done1;
   assign RST_in = rst_in;
   //assign CLK_out = clk_in;

   ////////// Button 0 Processes //////////
   // Count 1 process
   assign cnt_done0 = (count0 == NDELAY);
   always @(posedge clk_in or posedge RST_in) begin
      if (RST_in) count0 <= 0;
      else if (sig_in != xnew0) count0 <= 0;
      else count0 <= count0 + 1;
   end

   // xnew1 process
   always @(posedge clk_in or posedge RST_in) begin
      if (RST_in) xnew0 <= sig_in;
      else if (sig_in != xnew0) xnew0 <= sig_in;
      else xnew0 <= xnew0;
   end

   // Toggle1 process
   always @(posedge clk_in or posedge RST_in) begin
      if (RST_in) toggle0 <= 0;
      else if (xnew0) toggle0 <= 1;
      else if (cnt_done0) toggle0 <= 0;
      else toggle0 <= toggle0;
   end

   // sig_debounced_out process
   always @(posedge clk_in or posedge RST_in) begin
      if (RST_in) sig_debounced_out <= sig_in;
      else if (cnt_done0 & toggle0 & sig_in) sig_debounced_out <= 1;
      else sig_debounced_out <= 0;
   end

   ////////// End Button 0 Processes //////////
   
endmodule

