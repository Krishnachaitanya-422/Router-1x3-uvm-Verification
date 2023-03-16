//class

// Extend router_dst_driver from uvm driver parameterized by read_xtn
class router_dst_driver extends uvm_driver #(dst_trxn);

	// Factory Registration

	`uvm_component_utils(router_dst_driver)

	// Declare virtual interface handle with RDR_MP as modport
	virtual ram_dst_if.RDR_MP vif;

	// Declare the router_dst_agent_config handle as "m_cfg"
    router_dst_agt_config m_cfg;



	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
     	
	extern function new(string name ="router_dst_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(dst_trxn duv_xtn);
	extern function void report_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//
 
 function router_dst_driver::new (string name ="router_dst_driver", uvm_component parent);
	super.new(name, parent);
endfunction : new

//-----------------  build() phase method  -------------------//
function void router_dst_driver::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
    super.build_phase(phase);
	// get the config object using uvm_config_db 
	if(!uvm_config_db #(router_dst_agt_config)::get(this,"","router_dst_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction

//-----------------  connect() phase method  -------------------//
// in connect phase assign the configuration object's virtual interface
// to the driver's virtual interface instance(handle --> "vif")
function void router_dst_driver::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
endfunction

//-----------------  run() phase method  -------------------//
// In forever loop
// Get the sequence item using seq_item_port
// Call send_to_dut task 
// Get the next sequence item using seq_item_port  

task router_dst_driver::run_phase(uvm_phase phase);
    forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask


//-----------------  task send_to_dut() method  -------------------//


 task router_dst_driver::send_to_dut (dst_trxn duv_xtn);

   	

 endtask 

 // UVM report_phase
 function void router_dst_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: RAM read driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
 endfunction 
