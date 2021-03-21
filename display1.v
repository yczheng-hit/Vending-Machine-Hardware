module display1(
    input [3:0] i_data,
    output reg [6:0]o_digital
);

/*
*00000000000*
5           1
5           1
5           1
5           1
*66666666666*
4           2
4           2
4           2
4           2
*33333333333*
*/
// 高电平关 低电平开
always @(i_data) begin
    case(i_data)
        //               654_3210
        4'h0: o_digital = 7'b100_0000;
        4'h1: o_digital = 7'b111_1001;
        4'h2: o_digital = 7'b010_0100;
        4'h3: o_digital = 7'b011_0000;
        4'h4: o_digital = 7'b001_1001;
        4'h5: o_digital = 7'b001_0010;
        4'h6: o_digital = 7'b000_0010;
        4'h7: o_digital = 7'b111_1000;
        4'h8: o_digital = 7'b000_0000;
        4'h9: o_digital = 7'b001_0000;
        4'ha: o_digital = 7'b000_1000;
        4'hb: o_digital = 7'b000_0011;
        4'hc: o_digital = 7'b010_0111;
        4'hd: o_digital = 7'b010_0001;
        4'he: o_digital = 7'b000_0110;
        4'hf: o_digital = 7'b000_1110;
    endcase
end




endmodule