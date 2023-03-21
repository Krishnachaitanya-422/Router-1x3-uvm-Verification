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

    int no_of_duts = 4;
    int has_ragent = 1;
    int has_wagent = 1;
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
	if (has_wagent) 
		begin
			// initialize the dynamic array of handles for router_src_agent_config equal to no_of_duts
			m_src_cfg = new[no_of_duts];
	
	        foreach(m_src_cfg[i]) 
				begin
					// create the instance for router_src_agent_config

					m_src_cfg[i]=router_src_agent_config::type_id::create($sformatf("m_src_cfg[%0d]", i));
					// for all the configuration objects, set the following parameters 
					// is_active to UVM_ACTIVE
					// Get the virtual interface from the config database
					/*if(!uvm_config_db #(virtual ram_if)::get(this,"", $sformatf("vif_%0d",i),m_src_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
					m_src_cfg[i].is_active = UVM_ACTIVE;
					// assign the router_src_agent_config handle to the enviornment
					// config's(ram_env_config) ram_rd_agent_config handle
					m_tb_cfg.m_wr_agent_cfg[i] = m_src_cfg[i];*/
                
                end
        end
		
		
		// read config object
    if (has_ragent) 
		begin
            // initialize the dynamic array of handles m_dst_cfg to no_of_duts
            m_dst_cfg = new[no_of_duts];

			foreach(m_dst_cfg[i])
				begin
					// create the instance for ram_rd_agent_config
					m_dst_cfg[i]=router_dst_agt_config::type_id::create($sformatf("m_dst_cfg[%0d]", i));
					// for all the configuration objects, set the following parameters 
					// is_active to UVM_ACTIVE
					// Get the virtual interface from the config database

					/*if(!uvm_config_db #(virtual ram_if)::get(this,"", $sformatf("vif_%0d",i),m_dst_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
					m_dst_cfg[i].is_active = UVM_ACTIVE;
					// assign the ram_rd_agent_config handle to the enviornment
					// config's(ram_env_config) ram_rd_agent_config handle
					m_tb_cfg.m_rd_agent_cfg[i] = m_dst_cfg[i];*/
                
                end
        end
	// assign no_of_duts to local m_tb_cfg.no_of_duts
	// assign has_ragent to local m_tb_cfg.has_ragent
	// assign has_wagent to local m_tb_cfg.has_wagent
    m_tb_cfg.no_of_duts = no_of_duts;
    m_tb_cfg.has_ragent = has_ragent;
    m_tb_cfg.has_wagent = has_wagent;
		// assign 1 to m_tb_cfg.has_scoreboard
		m_tb_cfg.has_scoreboard= 1;
		
endfunction : config_router


//-----------------  build() phase method  -------------------//

function void router_base_test::build_phase(uvm_phase phase);
    // create the config object using uvm_config_db 
	m_tb_cfg=router_env_config::type_id::create("m_tb_cfg");
    if(has_wagent)
		// initialize the dynamic array of handles m_tb_cfg.m_wr_agent_cfg & m_tb_cfg.m_rd_agent_cfg to no_of_duts
        m_tb_cfg.m_wr_agent_cfg = new[no_of_duts];
    if(has_ragent)
		// initialize the dynamic array of handles for ram_rd_agent_config equal to no_of_duts
        m_tb_cfg.m_rd_agent_cfg = new[no_of_duts];
    // Call function config_ram which configures all the parameters
    config_router; 
	// set the config object into UVM config DB  
	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",m_tb_cfg);
	// call super.build()
    super.build();
	// create the instance for ram_envh handle
	router_envh=router_tb::type_id::create("router_envh", this);
endfunction

	


