
`timescale 1 ns/1 ns

module simple_uart_tb();

	// Wires and variables to connect to DUT
	reg CLK_IN;
	reg nRST;
	
	initial begin
		CLK_IN = 0;
		forever CLK_IN = #10 ~CLK_IN;
	end

	// Set the reset control
	initial begin
		nRST = 1'b0;
		#50 nRST = 1'b1;
	end
	
	// Instantiate unit under test
	basic_uart_tx uBasic_uart_tx (
	.iClk    (CLK_IN),
	.iRst_n  (nRST),
	.oUart_tx());

endmodule
