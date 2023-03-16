//class
class router_src_driver extends uvm_driver;

	`uvm_component_utils(router_src_driver)
	
	// virtual interface statement pending in this line
	virtual router_if.W_DR_MP vif;
	//handle decleration
	router_src_agent_config m_cfg;
	
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	
	extern function new(string name ="router_src_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(trxn xtn);
	extern function void report_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function	
function router_src_driver::new(string name ="router_src_driver",uvm_component parent);
	super.new(name,parent);
endfunction

//-----------------  build() phase method  -------------------//

function void router_src_driver::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
	super.build_phase(phase);
	
	// get the config object using uvm_config_db 
	if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

endfunction

//-----------------  connect() phase method  -------------------//
// in connect phase assign the configuration object's virtual interface
// to the driver's virtual interface instance(handle --> "vif")
function void router_src_driver::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
endfunction

//-----------------  run() phase method  -------------------//
task router_src_driver::run_phase(uvm_phase phase);
    @(vif.src_dr_cb);
	vif.src_dr_cb.resetn<=0;
	@(vif.src_dr_cb);
	vif.src_dr_cb.resetn<=1;
	
	forever
		begin
			
			seq_item_port.get_next_item(req);
			drive (req);
			seq_item_port.item_done;
			
		end
	
endtask

//-----------------  task send_to_dut() method  -------------------//

// Add task send_to_dut(write_xtn handle as an input argument)
	
task router_src_driver::send_to_dut(trxn xtn);
	trxn.print();
	wait(~vif.src_dr_cb.busy)
	@(vif.src_dr_cb);
	vif.src_dr_cb.pkt_valid<=1;
	vif.src_dr_cb.data_in<=xtn.header;
	@(vif.src_dr_cb);
	
	for(int i=0;i<xtn.header[7:2];i++)
		begin
				wait(~vif.src_dr_cb.busy)
				vif.src_dr_cb.data_in<=xtn.payload[i];
				@(vif.src_dr_cb);
		end
		
	wait(~vif.src_dr_cb.busy)
	vif.src_dr_cb.pkt_valid<=0;
	vif.src_dr_cb.data_in<=xtn.parity;
	@(vif.src_dr_cb);
endtask

 // UVM report_phase
  function void router_src_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: Router write driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
  endfunction