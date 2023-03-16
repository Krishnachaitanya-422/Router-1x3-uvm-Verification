// class

class router_tb extends uvm_env;

       
    // Factory Registration
  	`uvm_component_utils(router_tb)

	
	//Declare dynamic array of handles for router_src_agt_top, router_dst_agt_top  as sagt_top,ragt_top and respectively
	router_src_agt_top sagt_top[];
	router_dst_agt_top dagt_top[];
	// Declare handle for router_virtual_sequencer as  v_sequencer
	router_virtual_sequencer v_sequencer;
	//  Declare dynamic array of handles for ram scoreboard as sb
	router_scoreboard sb;
	// Declare handle for env configuration object as m_cfg
    router_env_config m_cfg;
	//------------------------------------------
	// Methods
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_tb", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass: router_tb
	
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
function router_tb::new(string name = "router_tb", uvm_component parent);
	super.new(name,parent);
endfunction

//-----------------  build phase method  -------------------//

function void router_tb::build_phase(uvm_phase phase);
	// get the config object using uvm_config_db 
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    if(m_cfg.has_wagent)
		begin
			// initialize the dynamic array sagt_top[] to m_cfg.no_of_duts
			sagt_top = new[m_cfg.no_of_duts];
			// inside a foreach loop of sagt_top[i]
			foreach(sagt_top[i])
				begin
					// set router_src_agent_config into the database using the
					// router_env_config's router_src_agent_config object 
					uvm_config_db #(router_src_agent_config)::set(this,$sformatf("sagt_top[%0d]*",i),  "router_src_agent_config", m_cfg.m_wr_agent_cfg[i]);
					// Create the instances of sagt_top[i] handles
					sagt_top[i]=router_src_agt_top::type_id::create($sformatf("sagt_top[%0d]",i) ,this);
                end 
        end
		
		
    if(m_cfg.has_ragent == 1) 
		begin
			// initialize the dynamic array dagt_top[] to m_cfg.no_of_duts
            dagt_top = new[m_cfg.no_of_duts];
			// inside a foreach loop of dagt_top[i]
            foreach(dagt_top[i]) 
				begin
					// set router_dst_agt_config into the database using the
					// router_env_config's router_dst_agt_config object 
					uvm_config_db #(router_dst_agt_config)::set(this,$sformatf("dagt_top[%0d]*",i),  "router_dst_agt_config", m_cfg.m_rd_agent_cfg[i]);
					// Create the instances of sagt_top[i]
					dagt_top[i]=router_dst_agt_top::type_id::create($sformatf("dagt_top[%0d]", i),this);
				end
        end

    super.build_phase(phase);
    if(m_cfg.has_virtual_sequencer)
		// Create the instance of v_sequencer handle 
	    v_sequencer=router_virtual_sequencer::type_id::create("v_sequencer",this);
		
    if(m_cfg.has_scoreboard)
		begin
			// initialize the dynamic array sb[] to m_cfg.no_of_duts
            //sb = new[m_cfg.no_of_duts];
			// Create the instances of router_scoreboard  
            //foreach (sb[i]) 
                sb = router_scoreboard::type_id::create("sb",this);
        end
endfunction

//-----------------  connect phase method  -------------------//

// In connect phase
// Connect virtual sequencer's sub sequencers to the envirnoment's
// write & read sequencers
//  Inside a foreach loops for *agt_top[i]
// Hint : v_sequencer.wr_seqr[i] = sagt_top[i].agnth.seqrh
// 	  v_sequencer.rd_seqr[i] = dagt_top[i].agnth.seqrh
 
function void router_tb::connect_phase(uvm_phase phase);
    if(m_cfg.has_virtual_sequencer)
		begin
            if(m_cfg.has_wagent)
				foreach(sagt_top[i]) 
					begin 
							v_sequencer.s_seqrh[i] = sagt_top[i].agnth.seqrh;                    
					end
                        
			if(m_cfg.has_ragent) 
				begin
					foreach(dagt_top[i]) 
						v_sequencer.d_seqrh[i] = dagt_top[i].agnth.seqrh;
                end
        end
// connect the corressponding analysis port of all the
// monitors to the analysis export of all the tlm analysis
// fifo's in the scoreboard 
// Inside a foreach loops for *agt_top[i]
// Hint : sagt_top[i].agnth.monh.monitor_port.connect(sb[i].fifo_wrh.analysis_export)
//        dagt_top[i].agnth.monh.monitor_port.connect(sb[i].fifo_rdh.analysis_export)

	if(m_cfg.has_scoreboard)
		begin
    		
     		sagt_top[0].agnth.monh.monitor_port.connect(sb.fifo_wrh.analysis_export);
   			
      		dagt_top[0].agnth.monh.monitor_port.connect(sb.fifo_rdh1.analysis_export);
			dagt_top[1].agnth.monh.monitor_port.connect(sb.fifo_rdh2.analysis_export);
			dagt_top[2].agnth.monh.monitor_port.connect(sb.fifo_rdh3.analysis_export);
		end
endfunction

