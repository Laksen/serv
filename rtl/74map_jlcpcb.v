(* blackbox *)
(* keep *)
module _74283(input [3:0] A, input [3:0] B, input C0,
              output C4, output [3:0] Sum);

endmodule

(* blackbox *)
(* keep *)
module _7482(input [1:0] A, input [1:0] B, input C0,
              output C2, output [1:0] Sum);

endmodule

(* blackbox *)
(* keep *)
module _74183(input A, input B, input C0,
              output C1, output Sum);

endmodule

(* blackbox *)
(* keep *)
module _74157(input [3:0] A, input [3:0] B, input S,
              output [3:0] Y);

endmodule

(* blackbox *)
(* keep *)
module _744078(input [7:0] A,
              output Y,
              output K);

endmodule

(* blackbox *)
(* keep *)
module _74460(input [9:0] A,
              input [9:0] B,
              output EQ,
              output NE);

endmodule

(* blackbox *)
(* keep *)
module _74150(input [15:0] E,
              input A,
              input B,
              input C,
              input D,
              output W);

endmodule

(* blackbox *)
(* keep *)
module _74377(input [8:0] D,
              input nCE,
              input CLK,
              output [8:0] Q);

endmodule

(* techmap_celltype = "$dffe" *)
module _90_dffe (CLK, EN, D, Q);

    parameter WIDTH = 0;
    parameter CLK_POLARITY = 1'b1;
    parameter EN_POLARITY = 1'b1;

    input CLK, EN;
    input [WIDTH-1:0] D;
    output [WIDTH-1:0] Q;

    wire enable = EN != EN_POLARITY;

    generate
        if (CLK_POLARITY && (WIDTH >= 8))
        begin
            _74377 dff(
                .D(D[7:0]),
                .Q(Q[7:0]),
                .nCE(enable),
                .CLK(CLK)
            );

            if (WIDTH > 8)
                \$dffe #(.WIDTH(WIDTH-8),
                         .CLK_POLARITY(CLK_POLARITY),
                         .EN_POLARITY(EN_POLARITY)) next(
                    .D(D[8+:WIDTH-8]),
                    .Q(Q[8+:WIDTH-8]),
                    .EN(EN),
                    .CLK(CLK)
                );
        end
        else if (CLK_POLARITY && (WIDTH >= 4))
        begin
            wire [8-WIDTH-1:0] d_tmp, q_tmp;

            _74377 dff(
                .D({d_tmp,D}),
                .Q({q_tmp,Q}),
                ._74377(enable),
                .CLK(CLK)
            );
        end
        else
            wire _TECHMAP_FAIL_ = 1;
    endgenerate

endmodule

// (* techmap_celltype = "$reduce_or" *)
// module _90_reduce_or (A, Y);
//     parameter A_SIGNED = 0;
//     parameter A_WIDTH = 2;
//     parameter Y_WIDTH = 1;

//     input [A_WIDTH-1:0] A;
//     output [Y_WIDTH-1:0] Y;

//     wire _TECHMAP_FAIL_ = (Y_WIDTH != 1) || (A_WIDTH < 4) || (A_WIDTH > 8);

//     wire [7:0] A_In;

//     assign A_In[A_WIDTH-1:0] = A;

//     _744078 or_gate(
//         .A(A_In),
//         .Y(Y),
//         .K()
//     );

// endmodule

(* techmap_celltype = "$mux" *)
module _90_mux (A, B, S, Y);
    parameter WIDTH = 0;

    input [WIDTH-1:0] A, B;
    input S;
    output reg [WIDTH-1:0] Y;

    genvar i;
    generate
        if (WIDTH >= 3)
        begin
            localparam
                CNT = (WIDTH+3) / 4;

            wire [CNT*4-1:0] A_IN;
            wire [CNT*4-1:0] B_IN;
            wire [CNT*4-1:0] Y_OUT;

            assign A_IN[WIDTH-1:0] = A;
            assign B_IN[WIDTH-1:0] = B;
            assign Y = Y_OUT[WIDTH-1:0];

            for (i=0; i<CNT; i=i+1)
                _74157 mux1(
                    .A(A[i*4+:4]),
                    .B(B[i*4+:4]),
                    .S(S),
                    .Y(Y[i*4+:4])
                );
        end
        else
        begin
            wire _TECHMAP_FAIL_ = 1;
        end
    endgenerate

endmodule

/*(* techmap_celltype = "$eq $ne" *)
module _90_eq (A, B, Y);

    parameter _TECHMAP_CELLTYPE_ = "";

    parameter A_SIGNED = 0;
    parameter B_SIGNED = 0;
    parameter A_WIDTH = 0;
    parameter B_WIDTH = 0;
    parameter Y_WIDTH = 0;

    input [A_WIDTH-1:0] A;
    input [B_WIDTH-1:0] B;
    output [Y_WIDTH-1:0] Y;

    wire _TECHMAP_FAIL_ = (Y_WIDTH != 1) || (A_WIDTH < 4) || (A_WIDTH > 8) || (B_WIDTH < 4) || (B_WIDTH > 8);

    localparam
        MIN_WIDTH = A_WIDTH < B_WIDTH ? B_WIDTH : A_WIDTH;

	wire [MIN_WIDTH-1:0] A_buf, B_buf;
	\$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(MIN_WIDTH)) A_conv (.A(A), .Y(A_buf));
	\$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(MIN_WIDTH)) B_conv (.A(B), .Y(B_buf));

    wire [Y_WIDTH-1:0] eq, ne;

    generate
        _74460 or_gate(
            .A(A_buf),
            .B(B_buf),
            .EQ(eq),
            .NE(ne)
        );

        if (_TECHMAP_CELLTYPE_ == "$eq")
            assign Y = eq;
        else
            assign Y = ne;
    endgenerate

endmodule*/

/*(* techmap_celltype = "$shiftx" *)
module _90_shiftx (A, B, Y);
  parameter A_SIGNED = 0;
  parameter B_SIGNED = 0;
  parameter A_WIDTH = 1;
  parameter B_WIDTH = 1;
  parameter Y_WIDTH = 1;

  (* force_downto *)
  input [A_WIDTH-1:0] A;
  (* force_downto *)
  input [B_WIDTH-1:0] B;
  (* force_downto *)
  output [Y_WIDTH-1:0] Y;

    wire _TECHMAP_FAIL_ = (Y_WIDTH != 1) || (A_WIDTH != 16) || B_SIGNED;

	wire [Y_WIDTH-1:0] A_buf;
	\$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
	wire [4-1:0] B_buf;
	\$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(4)) B_conv (.A(B), .Y(B_buf));

    _74150 x(
        .E(A_buf),
        .A(B_buf[0]),
        .B(B_buf[1]),
        .C(B_buf[2]),
        .D(B_buf[3]),
        .W(Y)
    );

endmodule*/

(* techmap_simplemap *)
(* techmap_celltype = "$pos $slice $concat $mux $tribuf" *)
module _90_simplemap_various;
endmodule

/*(* techmap_celltype = "$fa" *)
module _90_fa (A, B, C, X, Y);
	parameter WIDTH = 1;

	input [WIDTH-1:0] A, B, C;
	output [WIDTH-1:0] X, Y;

  _74183 fa(.A(A[0]), .B(B[0]), .C0(C[0]), .C1(X[0]), .Sum(Y[0]));
  
endmodule*/

module recursive_add #(parameter WIDTH = 9 )
                    (input [WIDTH-1:0] a,
                     input [WIDTH-1:0] b,
                     input carry_in,
                     output [WIDTH-1:0] sum,
                     output carry_out);

    generate
        if (WIDTH > 0)
        begin
            /*if (WIDTH >= 4)
            begin
                wire C4;

                _74283 sum4(
                    .A(a[0+:4]),
                    .B(a[0+:4]),
                    .C0(carry_in),
                    .Sum(sum[0+:4]),
                    .C4(C4),
                );

                if ((WIDTH-4) > 0)
                    recursive_add #(.WIDTH(WIDTH-4)) add_rest(
                        .a(a[4+:WIDTH-4]),
                        .b(b[4+:WIDTH-4]),
                        .carry_in(C4),
                        .sum(sum[4+:WIDTH-4]),
                        .carry_out(carry_out));
            end
            else */if (WIDTH >= 2)
            begin
                wire C1;
                wire C2;

                recursive_add #(.WIDTH(1)) adder0(
                    .a(a[0]),
                    .b(b[0]),
                    .carry_in(carry_in),
                    .sum(sum[0]),
                    .carry_out(C1)
                );
                recursive_add #(.WIDTH(1)) adder1(
                    .a(a[1]),
                    .b(b[1]),
                    .carry_in(C1),
                    .sum(sum[1]),
                    .carry_out(C2)
                );
                // _7482 sum2(
                //     .A(a[0+:2]),
                //     .B(a[0+:2]),
                //     .C0(carry_in),
                //     .Sum(sum[0+:2]),
                //     .C2(C2),
                // );

                if ((WIDTH-2) > 0)
                    recursive_add #(.WIDTH(WIDTH-2)) add_rest(
                        .a(a[2+:WIDTH-2]),
                        .b(b[2+:WIDTH-2]),
                        .carry_in(C2),
                        .sum(sum[2+:WIDTH-2]),
                        .carry_out(carry_out));
            end
            else
            begin
                \$fa #(.WIDTH(1)) adder0(
                    .A(a[0]),
                    .B(b[0]),
                    .C(carry_in),
                    .X(sum[0]),
                    .Y(carry_out)
                );
            end
        end
    endgenerate

endmodule


(* techmap_celltype = "$alu" *)
module _90_alu (A, B, CI, BI, X, Y, CO);
	parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;

	input [A_WIDTH-1:0] A;
	input [B_WIDTH-1:0] B;
	output [Y_WIDTH-1:0] X, Y;

	input CI, BI;
	output [Y_WIDTH-1:0] CO;

	wire [Y_WIDTH-1:0] A_buf, B_buf;
	\$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
	\$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(Y_WIDTH)) B_conv (.A(B), .Y(B_buf));

	wire [Y_WIDTH-1:0] AA = A_buf;
	wire [Y_WIDTH-1:0] BB = BI ? ~B_buf : B_buf;

	wire [Y_WIDTH:0] Carry;
	assign Carry[0] = CI;
	
    recursive_add #(.WIDTH(Y_WIDTH)) adders(
        .a(AA),
        .b(BB),
        .carry_in(CI),
        .sum(Y),
        .carry_out(Carry[Y_WIDTH])
    );
	
    assign X = AA ^ BB;
	assign CO = Carry;

endmodule