###############################################################
# This is a generated script based on design: xvc_server_hw
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
proc init_xcv_system_bd {design_name} {
   set scripts_vivado_version 2022.2
   set current_vivado_version [version -short]

   if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
      puts ""
      puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

      return 1
   }

   ################################################################
   # START
   ################################################################

   # To test this script, run the following commands from Vivado Tcl console:
   # source design_1_script.tcl

   # If you do not already have a project created,
   # you can create a project using the following command:
   #    create_project project_1 myproj -part xc7z010clg400-1
   #    set_property BOARD_PART em.avnet.com:microzed:part0:1.0 [current_project]


   # CHANGE DESIGN NAME HERE
   set design_name xvc_server_hw

   # If you do not already have an existing IP Integrator design open,
   # you can create a design using the following command:
   #    create_bd_design $design_name

   # CHECKING IF PROJECT EXISTS
   if { [get_projects -quiet] eq "" } {
      puts "ERROR: Please open or create a project!"
      return 1
   }


   # Creating design if needed
   set errMsg ""
   set nRet 0

   set cur_design [current_bd_design -quiet]
   set list_cells [get_bd_cells -quiet]

   if { ${design_name} eq "" } {
      # USE CASES:
      #    1) Design_name not set

      set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
      set nRet 1

   } elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
      # USE CASES:
      #    2): Current design opened AND is empty AND names same.
      #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
      #    4): Current design opened AND is empty AND names diff; design_name exists in project.

      if { $cur_design ne $design_name } {
         puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
         set design_name [get_property NAME $cur_design]
      }
      puts "INFO: Constructing design in IPI design <$cur_design>..."

   } elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
      # USE CASES:
      #    5) Current design opened AND has components AND same names.

      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 1
   } elseif { [get_files -quiet ${design_name}.bd] ne "" } {
      # USE CASES: 
      #    6) Current opened design, has components, but diff names, design_name exists in project.
      #    7) No opened design, design_name exists in project.

      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 2

   } else {
      # USE CASES:
      #    8) No opened design, design_name not in project.
      #    9) Current opened design, has components, but diff names, design_name not in project.

      puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

      create_bd_design $design_name

      puts "INFO: Making design <$design_name> as current_bd_design."
      current_bd_design $design_name

   }

   puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

   if { $nRet != 0 } {
      puts $errMsg
      return $nRet
   }
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {
  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set TCK [ create_bd_port -dir O TCK ]
  set TDI [ create_bd_port -dir O TDI ]
  set TDO [ create_bd_port -dir I TDO ]
  set TMS [ create_bd_port -dir O TMS ]

  # Create instance: axi_jtag_0, and set properties
  set axi_jtag_0 [ create_bd_cell -type module -reference axi_jtag_v1_0 axi_jtag_0 ]
  set_property -dict [ list CONFIG.C_TCK_CLOCK_RATIO {16}  ] $axi_jtag_0

  # Create instance: processsor_system_7(ps), and set properties
  set ps [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps ]
  set_property -dict [apply_preset $ps] $ps

  # Create instance: ps_axi_periph, and set properties
  set ps_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {1} ] $ps_axi_periph

  # Create instance: ps_rst_100m, and set properties
  set ps_rst_100m [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ps_rst_100m ]

  # Create interface connections
  connect_bd_intf_net -intf_net ps_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins ps/DDR]
  connect_bd_intf_net -intf_net ps_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins ps/FIXED_IO]
  connect_bd_intf_net -intf_net ps_M_AXI_GP0 [get_bd_intf_pins ps/M_AXI_GP0] [get_bd_intf_pins ps_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps_axi_periph_M00_AXI [get_bd_intf_pins axi_jtag_0/s_axi] [get_bd_intf_pins ps_axi_periph/M00_AXI]

  # Create port connections
  connect_bd_net -net TDO_1 [get_bd_ports TDO] [get_bd_pins axi_jtag_0/TDO]
  connect_bd_net -net axi_jtag_0_TCK [get_bd_ports TCK] [get_bd_pins axi_jtag_0/TCK]
  connect_bd_net -net axi_jtag_0_TDI [get_bd_ports TDI] [get_bd_pins axi_jtag_0/TDI]
  connect_bd_net -net axi_jtag_0_TMS [get_bd_ports TMS] [get_bd_pins axi_jtag_0/TMS]
  connect_bd_net -net ps_FCLK_CLK0 [get_bd_pins axi_jtag_0/s_axi_aclk] [get_bd_pins ps/FCLK_CLK0] [get_bd_pins ps/M_AXI_GP0_ACLK] [get_bd_pins ps_axi_periph/ACLK] [get_bd_pins ps_axi_periph/M00_ACLK] [get_bd_pins ps_axi_periph/S00_ACLK] [get_bd_pins ps_rst_100m/slowest_sync_clk]
  connect_bd_net -net ps_FCLK_RESET0_N [get_bd_pins ps/FCLK_RESET0_N] [get_bd_pins ps_rst_100m/ext_reset_in]
  connect_bd_net -net ps_rst_100m_interconnect_aresetn [get_bd_pins ps_axi_periph/ARESETN] [get_bd_pins ps_rst_100m/interconnect_aresetn]
  connect_bd_net -net ps_rst_100m_peripheral_aresetn [get_bd_pins axi_jtag_0/s_axi_aresetn] [get_bd_pins ps_axi_periph/M00_ARESETN] [get_bd_pins ps_axi_periph/S00_ARESETN] [get_bd_pins ps_rst_100m/peripheral_aresetn]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces ps/Data] [get_bd_addr_segs axi_jtag_0/s_axi/reg0] SEG_axi_jtag_0_reg0
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()

