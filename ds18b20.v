`timescale 1ns/1ps
///////////////////////////////////////////////////////////
//Module Name	:	ds18b20
//Description	:	get temperature information from DS18B20
//Editor			:	yongxiang
//Time			:	2019-12-16
///////////////////////////////////////////////////////////

module ds18b20
	(
		input wire	clk_in,
		input wire	rst_n,
		inout wire	dq,
		output wire[1:0]	smg_sig,
		output wire[7:0]	smg_data
	);

wire[4:0] temp_data;

//temp_demo
temp_demo temp_demo_inst
	(
		.clk_in(clk_in),
		.rst_n(rst_n),
		.dq(dq),
		.temp(temp_data)
	);
	
//smg_demo
smg_demo smg_demo_inst
	(
		.clk_50MHz(clk_in),
		.rst(rst_n),
		.data(temp_data),
		.smg_sig(smg_sig),
		.smg_data(smg_data)
	);
	
endmodule
