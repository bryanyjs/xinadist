
vlib work
vlog basic_uart_tx.v simple_uart_tb.v
vsim -t ns work.simple_uart_tb
view wave
add wave -radix hex /CLK_IN
add wave -radix hex /nRST
run 1 ms