//class

// Extend ram_base_test from uvm_test;
class router_base_test extends uvm_test;

   // Factory Registration
	`uvm_component_utils(router_base_test)

	
    // Declare the handles for env, env config_object, wr_agent config_object and
    // rd_agent config_object as ram_envh, m_tb_cfg, m_src_cfg[] & m_dst_cfg[]
    // (dynamic array of handles)
    // respectively     	
    router_tb router_envh;
    router_env_config m_tb_cfg;
    router_src_agent_config m_src_cfg[];
    router_dst_agt_config m_dst_cfg[];

	// Declare no_of_duts, has_ragent, has_wagent as int which are local
	// variables to this test class

    
    
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_router();
endclass
//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
function router_base_test::new(string name = "router_base_test" , uvm_component parent);
	super.new(name,parent);
endfunction
//----------------- function config_ram()  -------------------//

function void router_base_test::config_router();
	if (m_tb_cfg.has_wagent) 
		begin
			// initialize the dynamic array of handles for router_src_agent_config equal to no_of_duts
			m_src_cfg = new[m_tb_cfg.no_of_sources];
	
	        foreach(m_src_cfg[i]) 
				begin
					// create the instance for router_src_agent_config

					m_src_cfg[i]=router_src_agent_config::type_id::create($sformatf("m_src_cfg[%0d]", i));
					// for all the configuration objects, set the following parameters 
					// is_active to UVM_ACTIVE
					// Get the virtual interface from the config database
					if(!uvm_config_db #(virtual router_src_if)::get(this,"","vif",m_src_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
					m_src_cfg[i].is_active = UVM_ACTIVE;
					// assign the router_src_agent_config handle to the enviornment
					// config's(ram_env_config) ram_rd_agent_config handle
					m_tb_cfg.m_wr_agent_cfg[i] = m_src_cfg[i];
                
                end
        end
		
		
		// read config object
    if (m_tb_cfg.has_ragent) 
		begin
            // initialize the dynamic array of handles m_dst_cfg to no_of_duts
            m_dst_cfg = new[m_tb_cfg.no_of_clients];

			foreach(m_dst_cfg[i])
				begin
					// create the instance for ram_rd_agent_config
					m_dst_cfg[i]=router_dst_agt_config::type_id::create($sformatf("m_dst_cfg[%0d]", i));
					// for all the configuration objects, set the following parameters 
					// is_active to UVM_ACTIVE
					// Get the virtual interface from the config database

					if(!uvm_config_db #(virtual router_dst_if)::get(this,"", $sformatf("vif[%0d]",i),m_dst_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
					m_dst_cfg[i].is_active = UVM_ACTIVE;
					// assign the ram_rd_agent_config handle to the enviornment
					// config's(ram_env_config) ram_rd_agent_config handle
					m_tb_cfg.m_rd_agent_cfg[i] = m_dst_cfg[i];
                
                end
        end
	// assign no_of_duts to local m_tb_cfg.no_of_duts
	// assign has_ragent to local m_tb_cfg.has_ragent
	// assign has_wagent to local m_tb_cfg.has_wagent
   // m_tb_cfg.no_of_sources = no_of_sources;
	//m_tb_cfg.no_of_clients = no_of_clients;
    //m_tb_cfg.has_ragent = has_ragent;
    //m_tb_cfg.has_wagent = has_wagent;
		// assign 1 to m_tb_cfg.has_scoreboard
		m_tb_cfg.has_scoreboard= 1;
		
endfunction : config_router


//-----------------  build() phase method  -------------------//

function void router_base_test::build_phase(uvm_phase phase);
    // create the config object using uvm_config_db 
	m_tb_cfg=router_env_config::type_id::create("m_tb_cfg");
    if(m_tb_cfg.has_wagent)
		// initialize the dynamic array of handles m_tb_cfg.m_wr_agent_cfg & m_tb_cfg.m_rd_agent_cfg to no_of_duts
        m_tb_cfg.m_wr_agent_cfg = new[m_tb_cfg.no_of_sources];
    if(m_tb_cfg.has_ragent)
		// initialize the dynamic array of handles for ram_rd_agent_config equal to no_of_duts
        m_tb_cfg.m_rd_agent_cfg = new[m_tb_cfg.no_of_clients];
    // Call function config_ram which configures all the parameters
    config_router; 
	// set the config object into UVM config DB  
	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",m_tb_cfg);
	// call super.build()
    super.build();
	// create the instance for ram_envh handle
	router_envh=router_tb::type_id::create("router_envh", this);
endfunction


class router_test_1 extends  router_base_test;
	`uvm_component_utils(router_test_1)
	
	router_virtual_sequence_c1 seq1;
	bit [1:0] addr;
	
	extern function new(string name="router_test_1",uvm_component parent);
	extern task run_phase(uvm_phase phase);
	extern function void build_phase(uvm_phase phase);
endclass

function router_test_1::new(string name="router_test_1",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test_1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


task router_test_1::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	//repeat(10)
	begin
		addr= {$random} % 3;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
		seq1=router_virtual_sequence_c1::type_id::create("seq1",this);
		seq1.start(router_envh.v_sequencer);
	end
	phase.drop_objection(this);
endtask
