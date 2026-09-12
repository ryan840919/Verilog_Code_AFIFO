`timescale 1ns/1ps
// 1ns 這蘭代表時間單位, 像是#10代表延遲10ns
// 1ps 這蘭代表時間精度, 1ps=0.001ns, 如果我寫#1.0006, 會四捨五入到1.001ns

module _20260626_AFIFO_TB_Overflow ();

reg wclk, rclk, wrst, rrst, winc, rinc;
reg [7:0] wdata;
wire [7:0] rdata;
wire wfull, walmostfull, rempty, ralmostempty;

_20260626_AFIFO #(
	.datawidth(8),
	.addrwidth(4)
) AFIFO (
	.wclk(wclk), .rclk(rclk),
	.wrst(wrst), .rrst(rrst),
	.winc(winc), .rinc(rinc),
	.wdata(wdata), .rdata(rdata),
	.wfull(wfull), .walmostfull(walmostfull),
	.rempty(rempty), .ralmostempty(ralmostempty)
);
	
initial begin
	wclk = 1'b0;
	rclk = 1'b0;
end

always #5 wclk = ~wclk;
always #7 rclk = ~rclk;

integer w = 0;
integer r = 0;

initial begin
	wrst = 1'b1;
	winc = 1'b0;
	rrst = 1'b1;
	rinc = 1'b0;
	wdata = 8'h00;
	
	
	#4
	wrst = 1'b0;
	rrst = 1'b0;
	
	#8
	wrst = 1'b1;
	rrst = 1'b1;
	
	#20
	while (w<20) begin
		@(negedge wclk) begin
			winc = 1'b1;
			wdata = w;
			w = w + 1;
		end
	end
	
	@(negedge wclk) begin
		winc = 1'b0;
	end
	
	#10
	while (r<16) begin
		@(negedge rclk) begin
			rinc = 1'b1;
			r = r + 1;
		end
	end
	
	@(negedge rclk) begin
		rinc = 1'b0;
	end
	
	#100 //這裡要記得把stop, 但要流時間觀察波形
	$stop;

end

endmodule
	
