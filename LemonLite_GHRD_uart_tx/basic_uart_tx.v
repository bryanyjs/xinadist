
`define SYSCLK			50000000
`define BAUD_RATE    115200
`define BAUD_DIV		`SYSCLK/`BAUD_RATE //434.02 =? 435


module basic_uart_tx (
	input 	iClk,
	input 	iRst_n,
	output 	oUart_tx);
	
	parameter N	= 9;
	
	parameter STATE_N_BIT  = 4;
	
	parameter IDLE_ST      = 4'b0000;
	parameter START_BIT_ST = 4'b0001;
	parameter DATA_1_ST    = 4'b0010;
	parameter DATA_2_ST    = 4'b0011;
	parameter DATA_3_ST    = 4'b0100;
	parameter DATA_4_ST    = 4'b0101;
	parameter DATA_5_ST    = 4'b0110;
	parameter DATA_6_ST    = 4'b0111;
	parameter DATA_7_ST    = 4'b1000;
	parameter DATA_8_ST    = 4'b1001;
	parameter STOP_BIT_ST  = 4'b1010;
	

	reg [N-1:0] rCnt_baud;
	reg         rTx_clk;
	reg         rUart_tx;
	reg [7:0]   rUart_data;
	
	reg [STATE_N_BIT-1:0] cur_st;
	reg [STATE_N_BIT-1:0] nxt_st;
	
	always @(posedge iClk or negedge iRst_n)
	begin
		if (!iRst_n) begin
			rCnt_baud <= {N{1'b0}};
			rTx_clk   <= 1;
			//ruart_tx  <= 0;
		end
		else if (rCnt_baud == (`BAUD_DIV >> 1'b1)) begin
			rTx_clk   <= 0;
			rCnt_baud <= rCnt_baud + 1'b1;
		end
			
		else if (rCnt_baud == (`BAUD_DIV - 1'b1)) begin
			rTx_clk   <= 1;
			rCnt_baud <= {N{1'b0}};
		end
		else begin
			rCnt_baud <= rCnt_baud + 1'b1;
		end
	end
	
	always @(posedge rTx_clk or negedge iRst_n)
	begin
		if (!iRst_n) begin
			cur_st     <= IDLE_ST;
			//rUart_tx   <= 1'b1;
			rUart_data <= 8'h41; //'A'
		end
		else begin
			cur_st     <= nxt_st;
		end
	end
	
	always @(*) 
	begin
		case (cur_st)
			//IDLE_ST     :
			default     :
				begin
					nxt_st   = START_BIT_ST;
					rUart_tx = 1'b1;
				end
			START_BIT_ST:
				begin
					nxt_st   = DATA_1_ST;
					rUart_tx = 1'b0;
				end
			DATA_1_ST   :
				begin
					nxt_st   = DATA_2_ST;
					rUart_tx = rUart_data[0];
				end
			DATA_2_ST   :
				begin
					nxt_st   = DATA_3_ST;
					rUart_tx = rUart_data[1];
				end
			DATA_3_ST   :
				begin
					nxt_st   = DATA_4_ST;
					rUart_tx = rUart_data[2];
				end
			DATA_4_ST   :
				begin
					nxt_st   = DATA_5_ST;
					rUart_tx = rUart_data[3];
				end
			DATA_5_ST   :
				begin
					nxt_st   = DATA_6_ST;
					rUart_tx = rUart_data[4];
				end
			DATA_6_ST   :
				begin
					nxt_st   = DATA_7_ST;
					rUart_tx = rUart_data[5];
				end
			DATA_7_ST   :
				begin
					nxt_st   = DATA_8_ST;
					rUart_tx = rUart_data[6];
				end
			DATA_8_ST   :
				begin
					nxt_st   = STOP_BIT_ST;
					rUart_tx = rUart_data[7];
				end
			STOP_BIT_ST :
				begin
					nxt_st   = IDLE_ST;
					rUart_tx = 1'b1;
				end
		endcase
	end
	
	assign oUart_tx = rUart_tx;
	
endmodule

