module vendingMachine(
	input clk,
	input reset,
	input i_cancel,
	input i_confirm,
	input i_finish,
	input [2:0] i_coin,
	input [2:0] i_price,

	output [4:0] o_price,
	output reg [4:0] o_change, //找零
	output [4:0] o_money, //已经投入
	output reg o_ready,      //等待确认
	output reg o_goods       //商品
);

wire [4:0] price = i_price[2]?5'd20:i_price[1]?5'd14:5'd10;
assign o_price = price;
reg [4:0] money;
assign o_money = money;
parameter S0=5'b00000; //idle 等待投币
parameter S1=5'b00001; //已经投币 等待价格充足
parameter S2=5'b00010; //价格足够购买 是否确认
parameter S3=5'b00100; //退币 确认交易是否完成
parameter S4=5'b01000; //交易完成 清除寄存器值
parameter S5=5'b10000; //进入取消状态 退币

reg [4:0] curr_s;
reg [4:0] next_s;

reg money_clr;
reg [2:0]last_coin;
//处理投币价值
always @(posedge clk or  posedge reset)
begin
    if(reset) begin
        money <= 5'd0;
		last_coin <= 3'b000;
	end
    else if(money_clr) begin
        money <= 5'd0;
		last_coin <= 3'b000;
    end
    else begin
        if((curr_s == S0)||(curr_s == S1))
        begin
            last_coin <= i_coin;
            if((!i_coin[0])&last_coin[0]) begin	//1角
                money <= money + 5'd1;
            end 
            if((!i_coin[1])&last_coin[1]) begin	//5角
                money <= money + 5'd5;
            end 
            if((!i_coin[2])&last_coin[2]) begin	//1元
                money <= money + 5'd10;
            end 
        end
	end
end

/**************三段****************/
/**************每个时钟产生状态变化****************/
always @(posedge clk or  posedge reset)
begin
    if(reset)
        curr_s <= S0;
    else
        curr_s <= next_s;    
end

/**************产生的下一状态的组合逻辑****************/
always @(*)
begin
next_s = 'dx;
case(curr_s)
    S0: if(money == 0)          next_s = S0;    //没钱 等着 
        else                    next_s = S1;
    S1: if(i_cancel == 1)       next_s = S5;    //取消 退钱
        else if(money < price)  next_s = S1;    //钱不够
        else                    next_s = S2;    //钱够了
    S2: if(i_confirm == 1)      next_s = S3;    //确认购买
        else if (i_cancel == 1) next_s = S5;    //取消
        else                    next_s = S2; 
    S3: if(i_finish == 1)       next_s = S4;    //确认完成
        else                    next_s = S3; 
    S4: if((!i_finish)&(!i_cancel)&(!i_confirm))                            next_s = S0;    
        else                    next_s = S4;
    S5:                         next_s = S4;    //取消cancel 从头开始
    default:    next_s = S0;
endcase
end

/**************时序逻辑的输出****************/
always @(posedge clk or  posedge reset)
begin
    if(reset)
    begin
        money_clr = 0;
        o_change <= 0;
        o_goods <= 0;
        o_ready <= 0; 
    end     
    else
    case(curr_s)
        S0:
        begin
            o_change <= 5'd0; 
            o_goods <= 0; 
            o_ready <= 0; 
            money_clr <= 0;
        end
        S1: 
        begin
			o_change <= 5'd0;
			o_goods <= 0;
			o_ready <= 0;
            money_clr <= 0;
        end
        S2:               
        begin             
            o_change <= 5'd0;
			o_goods <= 0;
			o_ready <= 1;	//等待确认
            money_clr <= 0;
        end
        S3:               
        begin             
            o_change <= money - price;  //计算余额
			o_goods <= 1;	//购买成功
			o_ready <= 0;
        end
        S4:               
        begin             
            // o_change <= money - price;
			o_goods <= 0;	//购买成功
			o_ready <= 0;
            money_clr <= 1;
        end
        S5:               
        begin             
            o_change <= money;  //全额退款
			o_goods <= 0;
			o_ready <= 0;
            // money_clr <= 0;
        end
        default :
        begin 
            o_change <= 5'd0; 
			o_goods <= 0;
			o_ready <= 0; 
            money_clr <= 0;
		end
    endcase
end              
endmodule
