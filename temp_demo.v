`timescale 1ns/1ps
///////////////////////////////////////////////////////////
//Module Name	:	temp_demo
//Description	:	DS18B20 communication
//Editor			:	yongxiang
//Time			:	2019-12-16
///////////////////////////////////////////////////////////

module temp_demo
	(
		input wire	clk_in,
		input wire	rst_n,
		inout wire	dq,
		output wire[4:0]	temp
	);

wire clk;

//clk_div
clk_div clk_div_inst
	(
		.clk_in(clk_in),	
		.rst_n(rst_n),
		.clk_out(clk)
	);
	
//temp_rd
temp_rd temp_rd_inst
	(
		.clk_in(clk),		//1.024M
		.rst_n(rst_n),
		.dq(dq),				//单总线
		.temp(temp)			//温度值，单位℃
	);
	
endmodule
	