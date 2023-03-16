//class

class router_src_monitor extends uvm_monitor;

	// Factory Registration
	`uvm_component_utils(router_src_monitor)

	// Declare virtual interface handle with WMON_MP as modport
   	virtual ram_if.WMON_MP vif;

	// Declare the router_scr_agt_config handle as "m_cfg"
    router_src_agent_config m_cfg;
	
	//Declare Analysis TLM port to connect the monitor to the scoreboard
	uvm_analysis_port#(trxn)monitor_port;
	

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_src_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);
endclass 
//-----------------  constructor new method  -------------------//
function router_src_monitor::new(string name = "router_src_monitor", uvm_component parent);
	super.new(name,parent);
	//create instance of analysis port	
	monitor_port =  new("monitor_port",this);
endfunction

//-----------------  build() phase method  -------------------//
function void router_src_monitor::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
    super.build_phase(phase);
	// get the config object using uvm_config_db  
	if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

//-----------------  connect() phase method  -------------------//
// in connect phase assign the configuration object's virtual interface
// to the monitor's virtual interface instance(handle --> "vif")
function void router_src_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase)
	vif = m_cfg.vif;
endfunction


//-----------------  run() phase method  -------------------//
	

// In forever loop
// Call task collect_data
task router_src_monitor::run_phase(uvm_phase phase);
    forever
       // Call collect data task
       collect_data();     
endtask


// Collect Reference Data from DUV IF 
task router_src_monitor::collect_data();
    wait(vif.src_mon_cb.pkt_valid)
	xtn=trxn::type_id::create("XTN");
	xtn.header=vif.src_mon_cb.data_in;
	xtn.payload=new[xtn.header[7:2]];
	
	@(vif.src_mon_cb);
	for(int i=0;i<xtn.header[7:2];i++)
		begin
		
				wait(~vif.src_mon_cb.busy)
				xtn.payload[i]=vif.src_mon_cb.data_in;
				@(vif.src_mon_cb);
		end
		
		
	wait(~vif.src_mon_cb.busy)
	xtn.parity=vif.src_mon_cb.data_in;
	xtn.print;
	@(vif.src_mon_cb);
	monitor_port.write(xtn);
endtask 
      	  

// UVM report_phase
function void router_src_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: Router Write Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction : report_phase