tb_VendingMachine.vcd: tb_VendingMachine.vvp
	vvp -n tb_VendingMachine.vvp

tb_VendingMachine.vvp: *.v
	iverilog -s tb_VendingMachine -o $@ $^
	


gtk:
	gtkwave tb_VendingMachine.vcd

# ---- Clean ----

clean:
	rm -f *.vcd
	rm -f *.vvp 
.PHONY: clean gtk
