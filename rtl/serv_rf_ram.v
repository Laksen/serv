
module serv_rf_ram
  #(parameter width=0,
    parameter csr_regs=4,
    parameter depth=32*(32+csr_regs)/width)
   (input wire i_clk,
    input wire [$clog2(depth)-1:0] i_waddr,
    input wire [width-1:0] 	   i_wdata,
    input wire 			   i_wen,
    input wire [$clog2(depth)-1:0] i_raddr,
    output reg [width-1:0] 	   o_rdata);
   
  wire [7:0] data;
  assign data = i_clk ? 8'hZZ : i_wdata;

  always @(negedge i_clk)
    o_rdata <= data;

  ram ram_blk(
    .nOE(!i_clk),
    .nWE((!i_clk) ? !i_wen : 1'b1),
    .address(i_clk ? i_raddr : i_waddr),
    .data(data)
  );

  //  reg [width-1:0] 		   memory [0:depth-1];

  //  always @(posedge i_clk) begin
  //     if (i_wen)
	// memory[i_waddr] <= i_wdata;
  //     o_rdata <= memory[i_raddr];
  //  end

`ifdef SERV_CLEAR_RAM
   integer i;
   initial
     for (i=0;i<depth;i=i+1)
       memory[i] = {width{1'd0}};
`endif
endmodule

(* keep *)
(* blackbox *)
module ram(input [12:0] address,
           input nWE,
           input nOE,
           inout [7:0] data);
endmodule
