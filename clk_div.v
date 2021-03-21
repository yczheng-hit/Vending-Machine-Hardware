module clk_div(
	input clk_in,
	input reset,
	output clk_out
);
parameter DIV = 100;


reg [31:0]div = DIV/2;

reg [31:0] rreg;
wire [31:0] nxt;
reg track;
 
always @(posedge clk_in or posedge reset)
 
begin
  if (reset)
     begin
        rreg <= 0;
		track <= 1'b0;
     end
 
  else if (nxt == div)
 	   begin
	    rreg <= 0;
	    track <= ~track;
	   end
 
  else 
		rreg <= nxt;
end
 
assign nxt = rreg+1;   	      
assign clk_out = track;

endmodule