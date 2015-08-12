`timescale 1ns / 1ps
`include "zpu_core_defines.v"

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
	output LED4,

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

	internal_ram iram(
		.clk(ICE_CLK),
		.addr(addr),
		.write_en(write_en),
		.din(data_write),
		.dout(data_read),
	);

	always @(posedge ICE_CLK)
	begin
		mem_done <= 1; // 1 cycle ram
	end

	zpu_core cpu(
		.clk(ICE_CLK),
		.reset(FTDI_DTR),
		.mem_read(read_en),
		.mem_write(write_en),
		.mem_done(mem_done),
		.mem_addr(addr),
		.mem_data_read(data_read),
		.mem_data_write(data_write)
	);

	assign {LED0, LED1, LED2, LED3, LED4 } = addr[6:2];

endmodule	
