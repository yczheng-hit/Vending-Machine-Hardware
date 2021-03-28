module Top(
input [17:0] SW,
input [3:0] KEY,
input CLOCK_50,
input CLOCK_27,
output [17:0] LEDR,
output [7:0] LEDG,
output [6:0] HEX0,
output [6:0] HEX1,
output [6:0] HEX2,
output [6:0] HEX3,
output [6:0] HEX4,
output [6:0] HEX5,
output [6:0] HEX6,
output [6:0] HEX7

);

`define CNT_TEST

// wire clk = CLOCK_27;
wire clk = CLOCK_50;
assign LEDR = SW;
assign LEDG[3:0] = KEY;
parameter DIV_1k = 50_000;
wire reset = ~KEY[0];
wire clk_1k;
wire [4:0] o_price;
wire [4:0] o_change;
wire [4:0] o_money;

wire [1:0] o_num_10;
wire o_num_5;
wire [2:0] o_num_1;

// 贩卖机
vendingMachine u_vendingMachine(
	.clk       (clk_1k       ),
	.reset     (reset     ),
	.i_cancel  (SW[17] ),
	.i_confirm (SW[16] ),
	.i_finish  (SW[15]  ),
	.i_coin    (SW[10:8]    ),
	.i_price   (SW[2:0]   ),

	.o_num_10  (o_num_10   ),
	.o_num_5   (o_num_5   ),
	.o_num_1   (o_num_1   ),
	.o_price   (o_price   ),
	.o_change  (o_change  ),
	.o_money   (o_money   ),
	.o_ready   (LEDG[6]   ),
	.o_goods   (LEDG[7]   )
);


// 分频
clk_div 
#(
	.DIV (DIV_1k )
)
u_clk_div(
	.clk_in  (clk  ),
	.reset   (reset   ),
	.clk_out (clk_1k )
);

// 显示数据
display2 u0_display2(
	.i_data     (o_price     ),
	.o_digital1 (HEX6 ),
	.o_digital2 (HEX7 )
);

display2 u1_display2(
	.i_data     (o_money     ),
	.o_digital1 (HEX4 ),
	.o_digital2 (HEX5 )
);

display1 u0_display1(
	.i_data     (o_num_10),
	.o_digital (HEX2)
);
display1 u1_display1(
	.i_data     (o_num_5),
	.o_digital (HEX1)
);
display1 u2_display1(
	.i_data     (o_num_1),
	.o_digital (HEX0)
);
// display2 u2_display2(
// 	.i_data     (o_change     ),
// 	.o_digital1 (HEX0 ),
// 	.o_digital2 (HEX1 )
// );

// test
`ifdef CNT_TEST
wire clk_1;
assign LEDG[5] = clk_1;
reg [2:0]cnt;
parameter MAX=3'b101;
        always @(posedge reset or posedge clk_1)
        begin
            if(reset)
            begin
                cnt<=3'b000;
            end
            else
            begin
                if(cnt==MAX)
                begin
                    cnt<=3'b000;
                end
                else
                begin
                    cnt<=cnt+3'b001;
                end
            end
        end

// 分频
parameter DIV_1 = 50_000_000;
clk_div 
#(
	.DIV (DIV_1 )
)
u1_clk_div(
	.clk_in  (clk  ),
	.reset   (reset   ),
	.clk_out (clk_1 )
);

display1 utest_display1(
	.i_data     (cnt),
	.o_digital (HEX3)
);
`endif
endmodule
