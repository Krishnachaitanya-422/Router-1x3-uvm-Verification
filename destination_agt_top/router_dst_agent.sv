//class

  // Extend router_dst_agent from uvm_agent
class router_dst_agent extends uvm_agent;

   // Factory Registration
	`uvm_component_utils(router_dst_agent)

   // Declare handle for configuration object
    router_dst_agt_config m_cfg;
       
   // Declare handles of ram_rd_monitor,ram_rd_sequencer and ram_rd_driver
   // with Handle names as monh, seqrh, drvh respectively
	router_dst_monitor monh;
	router_dst_sequencer seqrh;
	router_dst_driver drvh;

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
  extern function new(string name = "router_dst_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : router_dst_agent
//-----------------  constructor new method  -------------------//

function router_dst_agent::new(string name = "router_dst_agent", 
                           uvm_component parent = null);
	super.new(name, parent);
endfunction
     
  
//-----------------  build() phase method  -------------------//
// Call parent build phase
// Create ram_wr_monitor instance
// If is_active=UVM_ACTIVE, create ram_wr_driver and ram_wr_sequencer instances

function void router_dst_agent::build_phase(uvm_phase phase);
		
	super.build_phase(phase);
    // get the config object using uvm_config_db 
	if(!uvm_config_db #(router_dst_agt_config)::get(this,"","router_dst_agt_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")  
    monh=router_dst_monitor::type_id::create("monh",this);	
	/*if(m_cfg.is_active==UVM_ACTIVE)
		begin
			drvh=router_dst_driver::type_id::create("drvh",this);
			seqrh=router_dst_sequencer::type_id::create("seqrh",this);
		end*/
endfunction

      
//-----------------  connect() phase method  -------------------//
//If is_active=UVM_ACTIVE, 
//connect driver(TLM seq_item_port) and sequencer(TLM seq_item_export)
      
function void router_dst_agent::connect_phase(uvm_phase phase);
	/*if(m_cfg.is_active==UVM_ACTIVE)
		begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
		end*/
endfunction