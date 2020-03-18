`timescale 1ns/1ps
////////////////////////////////
//module name: smg_display
//功能说明：将串口接收的数据译码成16进制显示在两位数码管上
////////////////////////////////

module smg_display
	(
		input clk_1khz,
		//input clk_1hz,
		input rst,
		input[4:0] data,
		
		output reg[1:0] smg_sig,
		output reg[7:0] smg_data
	);
	
//共阳数码管0~F编码:A~G、DP => data[0]~data[7]
parameter d0 = ~8'hc0;
parameter d1 = ~8'hf9;
parameter d2 = ~8'ha4;
parameter d3 = ~8'hb0;
parameter d4 = ~8'h99;
parameter d5 = ~8'h92;
parameter d6 = ~8'h82;
parameter d7 = ~8'hf8;
parameter d8 = ~8'h80;
parameter d9 = ~8'h90;

parameter smg_sig1 = 2'b10;
parameter smg_sig2 = 2'b01;

reg[7:0] smg_data1, smg_data2;
reg smg_sig_cnt;

//数据译码,显示0~29℃
always @(posedge clk_1khz or negedge rst)
begin
	if(!rst)begin
		smg_data1 <= d0;smg_data2 <= d0;
	end
	else begin
		case(data)
//			8'd0:begin smg_data1 <= d0;smg_data2 <= d0;end
//			8'd1:begin smg_data1 <= d1;smg_data2 <= d0;end
//			8'd2:begin smg_data1 <= d2;smg_data2 <= d0;end
//			8'd3:begin smg_data1 <= d3;smg_data2 <= d0;end
//			8'd4:begin smg_data1 <= d4;smg_data2 <= d0;end
//			8'd5:begin smg_data1 <= d5;smg_data2 <= d0;end
//			8'd6:begin smg_data1 <= d6;smg_data2 <= d0;end
//			8'd7:begin smg_data1 <= d7;smg_data2 <= d0;end
//			8'd8:begin smg_data1 <= d8;smg_data2 <= d0;end
//			8'd9:begin smg_data1 <= d9;smg_data2 <= d0;end
//			8'd10:begin smg_data1 <= d0;smg_data2 <= d1;end
//			8'd11:begin smg_data1 <= d1;smg_data2 <= d1;end
//			8'd12:begin smg_data1 <= d2;smg_data2 <= d1;end
//			8'd13:begin smg_data1 <= d3;smg_data2 <= d1;end
//			8'd14:begin smg_data1 <= d4;smg_data2 <= d1;end
//			8'd15:begin smg_data1 <= d5;smg_data2 <= d1;end
//			8'd16:begin smg_data1 <= d6;smg_data2 <= d1;end
//			8'd17:begin smg_data1 <= d7;smg_data2 <= d1;end
//			8'd18:begin smg_data1 <= d8;smg_data2 <= d1;end
//			8'd19:begin smg_data1 <= d9;smg_data2 <= d1;end
//			8'd20:begin smg_data1 <= d0;smg_data2 <= d2;end
//			8'd21:begin smg_data1 <= d1;smg_data2 <= d2;end
//			8'd22:begin smg_data1 <= d2;smg_data2 <= d2;end
//			8'd23:begin smg_data1 <= d3;smg_data2 <= d2;end
//			5'd24:begin smg_data1 <= d4;smg_data2 <= d2;end
//			5'd25:begin smg_data1 <= d5;smg_data2 <= d2;end
			5'd26:begin smg_data1 <= d6;smg_data2 <= d2;end
//			5'd27:begin smg_data1 <= d7;smg_data2 <= d2;end
//			5'd28:begin smg_data1 <= d8;smg_data2 <= d2;end
//			5'd29:begin smg_data1 <= d9;smg_data2 <= d2;end
			default:begin smg_data1 <= d0;smg_data2 <= d0;end
		endcase
	end
end

//扫描显示
always @(posedge clk_1khz)
begin
	smg_sig_cnt <= !smg_sig_cnt;
	case(smg_sig_cnt)
		1'b0:begin
			smg_sig <= smg_sig1;
			smg_data <= smg_data1;
		end
		1'b1:begin
			smg_sig <= smg_sig2;
			smg_data <= smg_data2;
		end
		default:begin
			smg_sig <= smg_sig1;
			smg_data <= smg_data1;
		end
	endcase
end


endmodule
