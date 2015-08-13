// from user code to infer
module internal_ram ( 	input clk, 
						input [addr_width-1:0] addr, 
						input write_en, 
						input [data_width-1:0] din, 
						output [data_width-1:0] dout
);
	// 512x32 bit
	parameter addr_width = 9;
	parameter data_width = 32;
	reg [data_width-1:0] dout; // Register for output. 
	reg [data_width-1:0] mem [(1<<addr_width)-1:0];
	always @(posedge clk)
	begin
	    if (write_en)
	      mem[(addr)] <= din;
		dout = mem[addr]; // Output register controlled by clock. 
	end
endmodule