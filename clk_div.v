`timescale 1ns/1ps
///////////////////////////////////////////////////////////
//Module Name	:	clk_div
//Description	:	get DS18B20 communication clk 204.8KHz ---- 5us
//Editor			:	yongxiang
//Time			:	2019-12-16
///////////////////////////////////////////////////////////

module clk_div
	(
		input wire	clk_in,		//16.384M
		input wire	rst_n,
		output reg	clk_out	
	);
	
reg[5:0] cnt;

//80分频，得到204.8KHz时钟，周期约5us
always @(posedge clk_in)
begin
	if(!rst_n)begin
		clk_out <= 1'b0;
		cnt <= 6'd0;
	end
	else begin
		if(cnt == 6'd39)begin
			clk_out <= !clk_out;
			cnt <= 6'd0;
		end
		else begin
			cnt <= cnt + 6'd1;
		end
	end
end

endmodule
