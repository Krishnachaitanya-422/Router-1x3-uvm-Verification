package router_test_pkg;


	//import uvm_pkg.sv
	
	import uvm_pkg::*;
	
	`include "uvm_macros.svh"
	`include "tb_defs.sv"
	`include "trxn.sv"
	`include "router_src_agent_config.sv"
	`include "router_dst_agt_config.sv"
	`include "router_env_config.sv"
	`include "router_src_driver.sv"
	`include "router_src_monitor.sv"
	`include "router_src_sequencer.sv"
	`include "router_src_agent.sv"
	`include "router_src_agt_top.sv"
	`include "router_src_seqs.sv"

	`include "dst_trxn.sv"
	`include "router_dst_monitor.sv"
	`include "router_dst_sequencer.sv"
	`include "router_dst_seqs.sv"
	`include "router_dst_driver.sv"
	`include "router_dst_agent.sv"
	`include "router_dst_agt_top.sv"

	`include "router_virtual_sequencer.sv"
	//`include "router_virtual_seqs.sv"
	`include "router_scoreboard.sv"

	`include "router_tb.sv"


	`include "router_vtest_lib.sv"
	
endpackage