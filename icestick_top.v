`timescale 1ns / 1ps
`include "zpu_core_defines.v"
module SB_ROM512x8(
	output [7:0] RDATA,
	input        RCLK, RCLKE, RE,
	input  [8:0] RADDR,
);
	parameter INIT_0 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_4 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_5 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_6 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_7 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_8 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_9 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

  wire [15:0] rd;

  SB_RAM40_4K #(
    .WRITE_MODE(1),
    .READ_MODE(1),
    .INIT_0(INIT_0),
    .INIT_1(INIT_1),
    .INIT_2(INIT_2),
    .INIT_3(INIT_3),
    .INIT_4(INIT_4),
    .INIT_5(INIT_5),
    .INIT_6(INIT_6),
    .INIT_7(INIT_7),
    .INIT_8(INIT_8),
    .INIT_9(INIT_9),
    .INIT_A(INIT_A),
    .INIT_B(INIT_B),
    .INIT_C(INIT_C),
    .INIT_D(INIT_D),
    .INIT_E(INIT_E),
    .INIT_F(INIT_F)
  ) _ram (
    .RDATA(rd),
    .RADDR(RADDR[7:0]),
    .RCLK(RCLK), .RCLKE(RCLKE), .RE(RE),
    .WCLK(RCLK), .WCLKE(1'b0), .WE(1'b0),
    .WADDR(8'b0),
    .MASK(16'h0000), .WDATA({16'b0}));

  assign RDATA[7:0] = RADDR[8] ? rd[15:8] : rd[7:0];

endmodule

module top(
//	inout  FTDI_DCD,
//	inout  FTDI_DSR,
	input  FTDI_DTR, // AKA reset pin
//	inout  FTDI_CTS,
//	inout  FTDI_RTS,
//	output FTDI_TX, // USB serial port transmit
//	input  FTDI_RX, // USE serial port recieve

	input ICE_CLK, // Oscilator clock

//	inout  EXPAN_J3_07,
//	inout  EXPAN_J3_10,
//	inout  EXPAN_J3_09,
//	inout  EXPAN_J3_08,
//	inout  EXPAN_J3_06,
//	inout  EXPAN_J3_05,
//	inout  EXPAN_J3_04,
//	inout  EXPAN_J3_03,

//	output SPI_SCLK, // SPI is connected to the flash
//	input  SPI_SI,
//	output SPI_SO,
//	output SPI_SS,

//	inout  PMOD_LEFT1,
//	inout  PMOD_LEFT2,
//	inout  PMOD_LEFT3,
//	inout  PMOD_LEFT4,
//	inout  PMOD_RIGHT1,
//	inout  PMOD_RIGHT2,
//	inout  PMOD_RIGHT3,
//	inout  PMOD_RIGHT4,

	output LED0, // Green 'PWR' LED
	output LED1,
	output LED2,
	output LED3,
	output LED4

//	output IRDA_TXD,
//	input  IRDA_RXD,
//	output IRDA_SD,

//	inout  EXPAN_J1_03,
//	inout  EXPAN_J1_04,
//	inout  EXPAN_J1_05,
//	inout  EXPAN_J1_06,
//	inout  EXPAN_J1_07,
//	inout  EXPAN_J1_08,
//	inout  EXPAN_J1_09,
//	inout  EXPAN_J1_10

);
	wire [9:0] addr;
	wire [31:0] data_read;
	wire [31:0] data_write;
	wire write_en;
	wire read_en;
	wire mem_done;

//	internal_ram iram(
//		.clk(ICE_CLK),
//		.addr(addr),
//		.write_en(write_en),
//		.din(data_write),
//		.dout(data_read),
//
//	);
	zpu_rom irom(
		.clk(ICE_CLK),
		.addr(addr[8:0]),
		.dout(data_read[7:0])
	);

	assign mem_done = 1'b1; // 1 cycle ram

	zpu_core cpu(
		.clk(ICE_CLK),
		.reset(FTDI_DTR),
		.mem_read(read_en),
		.mem_write(write_en),
		.mem_done(mem_done),
		.mem_addr(addr),
		.mem_data_read(data_read),
		.mem_data_write(data_write),
`ifdef ENABLE_CPU_INTERRUPTS
		.interrupt     (),
`endif
`ifdef ENABLE_BYTE_SELECT
  		.byte_select()
`endif

	);

	assign {LED0, LED1, LED2, LED3, LED4 } = addr[6:2];

endmodule	
