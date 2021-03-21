module display2(
    input [4:0] i_data,
    output [6:0]o_digital1,
    output [6:0]o_digital2
);

display1 u0_display1(
	.i_data    (i_data%10    ),
    .o_digital (o_digital1 )
);

display1 u1_display1(
	.i_data    (i_data/10    ),
    .o_digital (o_digital2 )
);



endmodule