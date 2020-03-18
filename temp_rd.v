`timescale 1ns/1ps
///////////////////////////////////////////////////////////
//Module Name	:	temp_rd
//Description	:	get temperature
//Editor			:	yongxiang
//Time			:	2019-12-16
///////////////////////////////////////////////////////////

module temp_rd
	(
		input wire	clk_in,		//1.024M
		input wire	rst_n,
		inout wire	dq,			//单总线
		output reg[4:0]	temp	//温度值，单位℃
	);

reg dq_is_out;
reg dq_reg;
reg respond;
reg[5:0] state;
reg[6:0] cnt;

assign dq = dq_is_out ? dq_reg : 1'bz;	//输入输出方向控制

always @(posedge clk_in)
begin
	if(!rst_n)begin
		state <= 6'd0;
		cnt <= 7'd0;
		dq_reg <= 1'b1;
		dq_is_out <= 1'b1;
//		temp <= 8'd0;
	end
	else begin
		case(state)
			//复位,初始化
			6'd0:begin	//置0,等待500us,置1
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd100)begin
					cnt <= 7'd0;
					dq_reg <= 1'b1;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd1:begin	//等待70us,接收应答0,建立通信
				dq_is_out <= 1'b0;	//输入
				if(cnt == 7'd14)begin
					respond <= dq;	//接收0
					cnt <= cnt + 7'd1;
				end
				else if(cnt == 7'd15)begin
					if(respond == 1'b0)begin
						cnt <= cnt + 7'd1;
					end
					else begin	//初始化失败
						state <= 6'd0;
						cnt <= 7'd0;
					end
				end
				else if(cnt == 7'd100)begin	//初始化结束
					state <= state + 6'd1;
					cnt <= 7'd0;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			
			//Skip ROM  发送0XCC----1100_1100
			6'd2,6'd3,6'd6,6'd7:begin	//发送0
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd16)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd4,6'd5,6'd8,6'd9:begin	//发送1
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd2)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			
			//启动convert,发送0X44----0100_0100
			6'd10,6'd11,6'd13,6'd14,6'd15,6'd17:begin	//发送0
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd16)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd12,6'd16:begin	//发送1
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd2)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			
			//等待转换完成
//			6'd18:begin
//				dq_is_out <= 1'b0;	//输入
//				if(cnt == 10'd300)begin
//					respond <= dq;	   
//					cnt <= cnt + 10'd1;
//				end
//				else if(cnt == 10'd301)begin
//					cnt <= 10'd0;
//					if(respond == 1'b1)begin	//转换完成
//						state <= state + 6'd1;
//					end
//				end
//				else begin
//					cnt <= cnt + 10'd1;
//				end
//			end

			//复位,初始化
			6'd18:begin	//置0,等待500us,置1
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd100)begin
					cnt <= 7'd0;
					dq_reg <= 1'b1;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd19:begin	//等待70us,接收应答0,建立通信
				dq_is_out <= 1'b0;	//输入
				if(cnt == 7'd14)begin
					respond <= dq;	//接收0
					cnt <= cnt + 7'd1;
				end
				else if(cnt == 7'd15)begin
					if(respond == 1'b0)begin
						cnt <= cnt + 7'd1;
					end
					else begin	//初始化失败
						state <= 6'd0;
						cnt <= 7'd0;
					end
				end
				else if(cnt == 7'd100)begin	//初始化结束
					state <= state + 6'd1;
					cnt <= 7'd0;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			
			//Skip ROM  发送0XCC----1100_1100
			6'd20,6'd21,6'd24,6'd25:begin	//发送0
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd16)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd22,6'd23,6'd26,6'd27:begin	//发送1
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd2)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			
			//发送读取数据命令0XBE----1011_1110
			6'd28,6'd34:begin	//发送0
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd16)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd29,6'd30,6'd31,6'd32,6'd33,6'd35:begin	//发送1
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd2)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			
			//读取温度数据
			6'd36,6'd37,6'd38,6'd39:begin
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd1)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
					dq_is_out <= 1'b0;	//输入
				end
				else if(cnt == 7'd3)begin
					cnt <= cnt + 7'd1;
					//////小数数据不读取
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd40:begin
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd1)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
					dq_is_out <= 1'b0;	//输入
				end
				else if(cnt == 7'd3)begin
					cnt <= cnt + 7'd1;
					temp[0] <= dq;//读取7位温度值
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd41:begin
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd1)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
					dq_is_out <= 1'b0;	//输入
				end
				else if(cnt == 7'd3)begin
					cnt <= cnt + 7'd1;
					temp[1] <= dq;//读取7位温度值
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd42:begin
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd1)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
					dq_is_out <= 1'b0;	//输入
				end
				else if(cnt == 7'd3)begin
					cnt <= cnt + 7'd1;
					temp[2] <= dq;//读取7位温度值
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd43:begin
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd1)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
					dq_is_out <= 1'b0;	//输入
				end
				else if(cnt == 7'd3)begin
					cnt <= cnt + 7'd1;
					temp[3] <= dq;//读取7位温度值
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
			6'd44:begin
				if(cnt == 7'd0)begin
					dq_is_out <= 1'b1;	//输出
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b0;	//reset
				end
				else if(cnt == 7'd1)begin
					cnt <= cnt + 7'd1;
					dq_reg <= 1'b1;
					dq_is_out <= 1'b0;	//输入
				end
				else if(cnt == 7'd3)begin
					cnt <= cnt + 7'd1;
					temp[4] <= dq;//读取7位温度值
				end
				else if(cnt == 7'd18)begin
					cnt <= 7'd0;
					state <= state + 6'd1;
				end
				else begin
					cnt <= cnt + 7'd1;
				end
			end
//			6'd45:begin
//				if(cnt == 7'd0)begin
//					dq_is_out <= 1'b1;	//输出
//					cnt <= cnt + 7'd1;
//					dq_reg <= 1'b0;	//reset
//				end
//				else if(cnt == 7'd1)begin
//					cnt <= cnt + 7'd1;
//					dq_reg <= 1'b1;
//					dq_is_out <= 1'b0;	//输入
//				end
//				else if(cnt == 7'd3)begin
//					cnt <= cnt + 7'd1;
//					temp[5] <= dq;//读取7位温度值
//				end
//				else if(cnt == 7'd18)begin
//					cnt <= 7'd0;
//					state <= state + 6'd1;
//				end
//				else begin
//					cnt <= cnt + 7'd1;
//				end
//			end
//			6'd46:begin
//				if(cnt == 7'd0)begin
//					dq_is_out <= 1'b1;	//输出
//					cnt <= cnt + 7'd1;
//					dq_reg <= 1'b0;	//reset
//				end
//				else if(cnt == 7'd1)begin
//					cnt <= cnt + 7'd1;
//					dq_reg <= 1'b1;
//					dq_is_out <= 1'b0;	//输入
//				end
//				else if(cnt == 7'd3)begin
//					cnt <= cnt + 7'd1;
//					temp[6] <= dq;//读取7位温度值
//				end
//				else if(cnt == 7'd18)begin
//					cnt <= 7'd0;
//					state <= state + 6'd1;
//				end
//				else begin
//					cnt <= cnt + 7'd1;
//				end
//			end
			
			//读取结束，复位
			6'd45:begin
				state <= 6'd0;
			end
		endcase
	end
end

endmodule
	