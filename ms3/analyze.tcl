lappend search_path ". ./rtl_files"

analyze -library work -format sverilog \
	{./rtl_files/top.sv \
	./rtl_files/aggr.sv \
	./rtl_files/mac.sv \
	./rtl_files/mac_4n.sv \
	./rtl_files/relu.sv \
	./rtl_files/relu_4n.sv \
}
