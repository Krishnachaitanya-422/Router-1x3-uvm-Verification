//class

// Extend router_dst_monitor from uvm_monitor
class router_dst_monitor extends uvm_monitor;

	// Factory Registration
	`uvm_component_utils(router_dst_monitor)

	// Declare virtual interface handle with DST_MON_MP as modport
   	virtual router_dst_if.DST_MON_MP vif;
	dst_trxn xtn;
	// Declare the router_dst_agt_config handle as "m_cfg"
    router_dst_agt_config m_cfg;

	// Analysis TLM port to connect the monitor to the scoreboard for lab09
	uvm_analysis_port #(dst_trxn) monitor_port;

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_dst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);


endclass 

//-----------------  constructor new method  -------------------//
 
function router_dst_monitor::new (string name = "router_dst_monitor", uvm_component parent);
	super.new(name, parent);
	// create object for handle monitor_port using new
    monitor_port = new("monitor_port", this);
endfunction : new

//-----------------  build() phase method  -------------------//
 
 function void router_dst_monitor::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
    super.build_phase(phase);
	// get the config object using uvm_config_db 
	if(!uvm_config_db #(router_dst_agt_config)::get(this,"","router_dst_agt_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

//-----------------  connect() phase method  -------------------//
// in connect phase assign the configuration object's virtual interface
// to the monitor's virtual interface instance(handle --> "vif")
function void router_dst_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	vif = m_cfg.vif;
endfunction


//-----------------  run() phase method  -------------------//
	

// In forever loop
// Call task collect_data
task router_dst_monitor::run_phase(uvm_phase phase);
    forever
		// Call collect data task
		collect_data();     
endtask


//Collect Reference Data from DUV IF 
task router_dst_monitor::collect_data();
	xtn=dst_trxn::type_id::create("xtn");
	
	wait(vif.dst_mon_cb.rd_en)
	@(vif.dst_mon_cb);
	
	xtn.header=vif.dst_mon_cb.dout;
	xtn.payload=new[xtn.header[7:2]];
	
	for(int i=0;i<xtn.header[7:2];i++)
			begin
				@(vif.dst_mon_cb);
				xtn.payload[i]=vif.dst_mon_cb.dout;
			end
    
	@(vif.dst_mon_cb);
	xtn.parity=vif.dst_mon_cb.dout;
	//xtn.print;
	`uvm_info("ROUTER_DST_MONITOR",$sformatf("printing from monitor \n %s",xtn.sprint()),UVM_LOW);
	@(vif.dst_mon_cb);
	//@(vif.dst_mon_cb);
	monitor_port.write(xtn);
  
endtask 

// UVM report_phase
function void router_dst_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: Router Read Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction