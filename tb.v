`timescale  1ns / 1ps    

module tb_VendingMachine;

// VendingMachine Parameters
parameter PERIOD = 10     ;
parameter S0  = 4'b0000;
parameter S1  = 4'b0001;
parameter S2  = 4'b0010;
parameter S3  = 4'b0100;
parameter S4  = 4'b1000;

// VendingMachine Inputs
reg   clk                                  = 0 ;
reg   reset                                = 0 ;
reg   i_cancel                            = 0 ;
reg   i_confirm                            = 0 ;
reg   i_finish                             = 0 ;
reg   [2:0]  i_coin                        = 0 ;
reg   [2:0]  i_price                       = 0 ;

// VendingMachine Outputs
wire  [4:0]  o_price                       ; 
wire  [4:0]  o_change                      ;
wire  [4:0]  o_money                       ;
wire  o_ready                              ;
wire  o_goods                              ;

initial begin
    $dumpfile("tb_VendingMachine.vcd");
    $dumpvars(0, tb_VendingMachine);
end

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) reset  =  1;
end

vendingMachine  u_vendingMachine (
    .clk                     ( clk              ),
    .reset                   ( reset            ),
    .i_cancel               ( i_cancel        ),
    .i_confirm               ( i_confirm        ),
    .i_finish                ( i_finish         ),
    .i_coin                  ( i_coin     [2:0] ),
    .i_price                 ( i_price    [2:0] ),

    .o_price                 ( o_price    [4:0] ),
    .o_change                ( o_change   [4:0] ),
    .o_money                 ( o_money    [4:0] ),
    .o_ready                 ( o_ready          ),
    .o_goods                 ( o_goods          )
);

initial
begin
    reset = 0;
    #(PERIOD*2) reset = 1;
    #(PERIOD*2) reset = 0;

    $display("reset ok");

    #(PERIOD*10) $display("o_price is %d",o_price);
    // 测试输入硬币面额和数值
    #(PERIOD*2) i_coin[0] = 1;
    #(PERIOD*2) i_coin[0] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[1] = 1;
    #(PERIOD*2) i_coin[1] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[2] = 1;
    #(PERIOD*2) i_coin[2] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);

    #(PERIOD*50) i_confirm = 1;
    #(PERIOD*10) $display("set confirm = 1");
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*10) $display("o_change is %d",o_change);
    #(PERIOD*50) i_finish = 1;
    #(PERIOD*10) $display("set finish = 1");
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*10) $display("o_change is %d",o_change);

    #(PERIOD*100)

    // 更换价格测试

    #(PERIOD*10) $display("run again,price changed");
    i_confirm = 0;
    i_finish = 0;
    i_price = 3'b110;
    #(PERIOD*10) $display("o_price is %d",o_price);
    // 测试输入硬币面额和数值
    #(PERIOD*2) i_coin[0] = 1;
    #(PERIOD*2) i_coin[0] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[1] = 1;
    #(PERIOD*2) i_coin[1] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[1] = 1;
    #(PERIOD*2) i_coin[1] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[2] = 1;
    #(PERIOD*2) i_coin[2] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);

    #(PERIOD*50) i_confirm = 1;
    #(PERIOD*10) $display("set confirm = 1");
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*10) $display("o_change is %d",o_change);
    #(PERIOD*50) i_finish = 1;
    #(PERIOD*10) $display("set finish = 1");
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*10) $display("o_change is %d",o_change);

    #(PERIOD*100)
    // 测试 cancel
    i_confirm = 0;
    i_finish = 0;
    i_price = 3'b010;
    #(PERIOD*10) $display("o_price is %d",o_price);
    // 测试输入硬币面额和数值
    #(PERIOD*2) i_coin[0] = 1;
    #(PERIOD*2) i_coin[0] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[1] = 1;
    #(PERIOD*2) i_coin[1] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[1] = 1;
    #(PERIOD*2) i_coin[1] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);

    #(PERIOD*50) i_cancel = 1;
    #(PERIOD*10) $display("set cancel = 1");
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*10) $display("o_change is %d",o_change);

    #(PERIOD*100)
    // 测试 cancel
    i_cancel = 0;
    i_confirm = 0;
    i_finish = 0;
    i_price = 3'b010;
    #(PERIOD*10) $display("o_price is %d",o_price);
    // 测试输入硬币面额和数值
    #(PERIOD*2) i_coin[0] = 1;
    #(PERIOD*2) i_coin[0] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[1] = 1;
    #(PERIOD*2) i_coin[1] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[1] = 1;
    #(PERIOD*2) i_coin[1] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*2) i_coin[1] = 1;
    #(PERIOD*2) i_coin[1] = 0;
    #(PERIOD*10) $display("o_money is %d",o_money);

    #(PERIOD*50) i_cancel = 1;
    #(PERIOD*10) $display("set cancel = 1");
    #(PERIOD*10) $display("o_money is %d",o_money);
    #(PERIOD*10) $display("o_change is %d",o_change);

    #(PERIOD*100)

    $finish;
end

endmodule

