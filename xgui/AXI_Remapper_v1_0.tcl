# Definitional proc to organize widgets for parameters.

proc get_param_value {PARAM} {
    return [get_property value ${PARAM}]
}

proc set_param_value {VALUE PARAM} {
    set_property value $VALUE ${PARAM}
}

proc copy_value {SRC_PARAM DEST_PARAM} {

    set src_value [get_param_value ${SRC_PARAM}]
    set dest_value [get_param_value ${DEST_PARAM}]

    if { [string equal -nocase $src_value $dest_value] != 1 } {
        if { $src_value != "" } {
            set_param_value $src_value ${DEST_PARAM}
        }
    }
}

# ipview parent {param widget_type tooltip}
proc add_widgets { ipview parent widget_spec } {
    foreach {param widget_type tooltip} $widget_spec {
        set widget [ipgui::add_param $ipview -parent $parent -name $param -widget $widget_type]
        if {$tooltip != ""} {
            set_property tooltip $tooltip $widget
        }
    }
}

proc init_gui { IPINST } {
    set Page0 [ipgui::add_page $IPINST -name "Page 0" -layout vertical]

    ipgui::add_param $IPINST -parent $Page0 -name "Component_Name"

    set axi_widgets {
        PROTOCOL         comboBox {This defines which AXI protocol is implemented}
        READ_WRITE_MODE  comboBox {This controls which AXI channels are enabled}
        S_AXI_ADDR_WIDTH textEdit {Defines the width(in bits) of the AWADDR and ARADDR signals of S_AXI}
        M_AXI_ADDR_WIDTH textEdit {Defines the width(in bits) of the AWADDR and ARADDR signals of M_AXI}
        DATA_WIDTH       comboBox {Defines the width(in bits) of the AXI WDATA and RDATA signals}
        ID_WIDTH         comboBox {Defines the width(in bits) of the AXI ID signals}
    }
    add_widgets $IPINST $Page0 $axi_widgets

    set user_group [ipgui::add_group $IPINST -parent $Page0 -name {User signal widths} -layout vertical]
    set user_widgets {
        AWUSER_WIDTH textEdit {Defines the width of the AXI AWUSER signal of the master and slave interface}
        ARUSER_WIDTH textEdit {Defines the width of the AXI ARUSER signal of the master and slave interface}
        WUSER_WIDTH  textEdit {Defines the width of the AXI WUSER signal of the master and slave interface}
        RUSER_WIDTH  textEdit {Defines the width of the AXI RUSER signal of the master and slave interface}
        BUSER_WIDTH  textEdit {Defines the width of the AXI BUSER signal of the master and slave interface}
    }
    add_widgets $IPINST $user_group $user_widgets

    set addr_group [ipgui::add_group $IPINST -parent $Page0 -name {AXI addr} -layout vertical]
    set addr_widgets {
        REMAP_ADDR_WIDTH textEdit {Defines the width of address needs to be remapped}
        M_AXI_BASEADDR textEdit {Defines the base address of the master AXI interface}
    }
    add_widgets $IPINST $addr_group $addr_widgets
}

proc update_PARAM_VALUE.PROTOCOL { PARAM_VALUE.PROTOCOL } {
    # Procedure called to update PROTOCOL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PROTOCOL { PARAM_VALUE.PROTOCOL } {
    # Procedure called to validate PROTOCOL
    return true
}

proc update_PARAM_VALUE.READ_WRITE_MODE { PARAM_VALUE.READ_WRITE_MODE } {
    # Procedure called to update READ_WRITE_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.READ_WRITE_MODE { PARAM_VALUE.READ_WRITE_MODE } {
    # Procedure called to validate READ_WRITE_MODE
    return true
}

proc update_PARAM_VALUE.ID_WIDTH { PARAM_VALUE.ID_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to update ID_WIDTH when any of the dependent parameters in the arguments change

    set protocol [get_param_value ${PARAM_VALUE.PROTOCOL}]

    array set defaultval_map [subst { AXI4LITE "0" AXI4 "0"}]
    array set listval_map [subst {AXI4LITE "0,0" AXI4 "0,32"}]

    # array set visiable_map [subst {AXI4LITE false AXI4 true}]
    # set_property visible false ${PARAM_VALUE.ID_WIDTH}

    set_property range_value "$defaultval_map($protocol), $listval_map($protocol)" ${PARAM_VALUE.ID_WIDTH}
}

proc validate_PARAM_VALUE.ID_WIDTH { PARAM_VALUE.ID_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to validate ID_WIDTH
    return true
}

proc update_PARAM_VALUE.AWUSER_WIDTH { PARAM_VALUE.AWUSER_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to update AWUSER_WIDTH when any of the dependent parameters in the arguments change

    set protocol [get_param_value ${PARAM_VALUE.PROTOCOL}]

    array set defaultval_map [subst { AXI4LITE "0" AXI4 "0"}]
    array set listval_map [subst {AXI4LITE "0,0" AXI4 "0,1024"}]

    set_property range_value "$defaultval_map($protocol), $listval_map($protocol)" ${PARAM_VALUE.AWUSER_WIDTH}
}

proc validate_PARAM_VALUE.AWUSER_WIDTH { PARAM_VALUE.AWUSER_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to validate AWUSER_WIDTH
    return true
}

proc update_PARAM_VALUE.ARUSER_WIDTH { PARAM_VALUE.ARUSER_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to update ARUSER_WIDTH when any of the dependent parameters in the arguments change

    set protocol [get_param_value ${PARAM_VALUE.PROTOCOL}]

    array set defaultval_map [subst { AXI4LITE "0" AXI4 "0"}]
    array set listval_map [subst {AXI4LITE "0,0" AXI4 "0,1024"}]

    set_property range_value "$defaultval_map($protocol), $listval_map($protocol)" ${PARAM_VALUE.ARUSER_WIDTH}
}

proc validate_PARAM_VALUE.ARUSER_WIDTH { PARAM_VALUE.ARUSER_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to validate ARUSER_WIDTH
    return true
}

proc update_PARAM_VALUE.RUSER_WIDTH { PARAM_VALUE.RUSER_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to update RUSER_WIDTH when any of the dependent parameters in the arguments change

    set protocol [get_param_value ${PARAM_VALUE.PROTOCOL}]

    array set defaultval_map [subst { AXI4LITE "0" AXI4 "0"}]
    array set listval_map [subst {AXI4LITE "0,0" AXI4 "0,1024"}]

    set_property range_value "$defaultval_map($protocol), $listval_map($protocol)" ${PARAM_VALUE.RUSER_WIDTH}
}

proc validate_PARAM_VALUE.RUSER_WIDTH { PARAM_VALUE.RUSER_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to validate RUSER_WIDTH
    return true
}

proc update_PARAM_VALUE.WUSER_WIDTH { PARAM_VALUE.WUSER_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to update WUSER_WIDTH when any of the dependent parameters in the arguments change

    set protocol [get_param_value ${PARAM_VALUE.PROTOCOL}]

    array set defaultval_map [subst { AXI4LITE "0" AXI4 "0"}]
    array set listval_map [subst {AXI4LITE "0,0" AXI4 "0,1024"}]

    set_property range_value "$defaultval_map($protocol), $listval_map($protocol)" ${PARAM_VALUE.WUSER_WIDTH}
}

proc validate_PARAM_VALUE.WUSER_WIDTH { PARAM_VALUE.WUSER_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to validate WUSER_WIDTH
    return true
}

proc update_PARAM_VALUE.BUSER_WIDTH { PARAM_VALUE.BUSER_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to update BUSER_WIDTH when any of the dependent parameters in the arguments change

    set protocol [get_param_value ${PARAM_VALUE.PROTOCOL}]

    array set defaultval_map [subst { AXI4LITE "0" AXI4 "0"}]
    array set listval_map [subst {AXI4LITE "0,0" AXI4 "0,1024"}]

    set_property range_value "$defaultval_map($protocol), $listval_map($protocol)" ${PARAM_VALUE.BUSER_WIDTH}
}

proc validate_PARAM_VALUE.BUSER_WIDTH { PARAM_VALUE.BUSER_WIDTH } {
    # Procedure called to validate BUSER_WIDTH
    return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH PARAM_VALUE.PROTOCOL} {
    # Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change

    set protocol [get_param_value ${PARAM_VALUE.PROTOCOL}]

    array set defaultval_map [subst { AXI4LITE "32" AXI4 "32"}]
    array set listval_map [subst {AXI4LITE "32,64" AXI4 "32,64,128,256,512,1024"}]

    set_property range_value "$defaultval_map($protocol), $listval_map($protocol)" ${PARAM_VALUE.DATA_WIDTH}
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
    # Procedure called to validate DATA_WIDTH
    return true
}

proc update_PARAM_VALUE.S_AXI_BASEADDR { PARAM_VALUE.S_AXI_BASEADDR } {
    # Procedure called to update S_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_AXI_BASEADDR { PARAM_VALUE.S_AXI_BASEADDR } {
    # Procedure called to validate S_AXI_BASEADDR
    return true
}

proc update_PARAM_VALUE.S_AXI_HIGHADDR { PARAM_VALUE.S_AXI_HIGHADDR } {
    # Procedure called to update S_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_AXI_HIGHADDR { PARAM_VALUE.S_AXI_HIGHADDR } {
    # Procedure called to validate S_AXI_HIGHADDR
    return true
}

proc update_PARAM_VALUE.M_AXI_BASEADDR { PARAM_VALUE.M_AXI_BASEADDR } {
    # Procedure called to update M_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_AXI_BASEADDR { PARAM_VALUE.M_AXI_BASEADDR } {
    # Procedure called to validate M_AXI_BASEADDR
    return true
}

proc update_PARAM_VALUE.S_AXI_ADDR_WIDTH { PARAM_VALUE.S_AXI_ADDR_WIDTH } {
    # Procedure called to update S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_AXI_ADDR_WIDTH { PARAM_VALUE.S_AXI_ADDR_WIDTH } {
    # Procedure called to validate S_AXI_ADDR_WIDTH
    return true
}

proc update_PARAM_VALUE.M_AXI_ADDR_WIDTH { PARAM_VALUE.M_AXI_ADDR_WIDTH } {
    # Procedure called to update M_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_AXI_ADDR_WIDTH { PARAM_VALUE.M_AXI_ADDR_WIDTH } {
    # Procedure called to validate M_AXI_ADDR_WIDTH
    return true
}

proc update_PARAM_VALUE.REMAP_ADDR_WIDTH { PARAM_VALUE.REMAP_ADDR_WIDTH PARAM_VALUE.S_AXI_ADDR_WIDTH} {
    # Procedure called to update REMAP_ADDR_WIDTH when any of the dependent parameters in the arguments change
    set range_max [get_param_value ${PARAM_VALUE.S_AXI_ADDR_WIDTH}]
    set defaultval [get_param_value ${PARAM_VALUE.REMAP_ADDR_WIDTH}]

    if {$defaultval > $range_max} {
        set defaultval $range_max
    }

    set listval "1,$range_max"

    puts [get_property range_value ${PARAM_VALUE.REMAP_ADDR_WIDTH}]

    set_property range_value "$defaultval, $listval" ${PARAM_VALUE.REMAP_ADDR_WIDTH}
}

proc validate_PARAM_VALUE.REMAP_ADDR_WIDTH { PARAM_VALUE.REMAP_ADDR_WIDTH PARAM_VALUE.S_AXI_ADDR_WIDTH} {
    # Procedure called to validate REMAP_ADDR_WIDTH

    if {[get_param_value ${PARAM_VALUE.REMAP_ADDR_WIDTH}] > [get_param_value ${PARAM_VALUE.S_AXI_ADDR_WIDTH}]} {
        return false
    } else {
        return true
    }
}

##################

proc update_MODELPARAM_VALUE.C_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.DATA_WIDTH} ${MODELPARAM_VALUE.C_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_ID_WIDTH { MODELPARAM_VALUE.C_AXI_ID_WIDTH PARAM_VALUE.ID_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.ID_WIDTH} ${MODELPARAM_VALUE.C_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_BUSER_WIDTH { MODELPARAM_VALUE.C_AXI_BUSER_WIDTH PARAM_VALUE.BUSER_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.BUSER_WIDTH} ${MODELPARAM_VALUE.C_AXI_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_AWUSER_WIDTH { MODELPARAM_VALUE.C_AXI_AWUSER_WIDTH PARAM_VALUE.AWUSER_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.AWUSER_WIDTH} ${MODELPARAM_VALUE.C_AXI_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_ARUSER_WIDTH { MODELPARAM_VALUE.C_AXI_ARUSER_WIDTH PARAM_VALUE.ARUSER_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.ARUSER_WIDTH} ${MODELPARAM_VALUE.C_AXI_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_WUSER_WIDTH { MODELPARAM_VALUE.C_AXI_WUSER_WIDTH PARAM_VALUE.WUSER_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.WUSER_WIDTH} ${MODELPARAM_VALUE.C_AXI_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_RUSER_WIDTH { MODELPARAM_VALUE.C_AXI_RUSER_WIDTH PARAM_VALUE.RUSER_WIDTH } {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.RUSER_WIDTH} ${MODELPARAM_VALUE.C_AXI_RUSER_WIDTH}
}

###################

proc update_MODELPARAM_VALUE.C_M_AXI_BASEADDR { MODELPARAM_VALUE.C_M_AXI_BASEADDR PARAM_VALUE.M_AXI_BASEADDR } {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.M_AXI_BASEADDR} ${MODELPARAM_VALUE.C_M_AXI_BASEADDR}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.S_AXI_ADDR_WIDTH } {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.S_AXI_ADDR_WIDTH} ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_ADDR_WIDTH PARAM_VALUE.M_AXI_ADDR_WIDTH } {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.M_AXI_ADDR_WIDTH} ${MODELPARAM_VALUE.C_M_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_REMAP_ADDR_WIDTH { MODELPARAM_VALUE.C_REMAP_ADDR_WIDTH PARAM_VALUE.REMAP_ADDR_WIDTH } {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    copy_value ${PARAM_VALUE.REMAP_ADDR_WIDTH} ${MODELPARAM_VALUE.C_REMAP_ADDR_WIDTH}
}

###################

proc update_MODELPARAM_VALUE.C_AXI_PROTOCOL { MODELPARAM_VALUE.C_AXI_PROTOCOL PARAM_VALUE.PROTOCOL } {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value

    array set map [subst {AXI4 0 AXI3 1 AXI4LITE 2}]

    set SRC_PARAM ${PARAM_VALUE.PROTOCOL}
    set DEST_PARAM ${MODELPARAM_VALUE.C_AXI_PROTOCOL}

    set src_value $map([get_param_value ${SRC_PARAM}])
    set dest_value [get_param_value ${DEST_PARAM}]

    if { [string equal -nocase $src_value $dest_value] != 1 } {
        if { $src_value != "" } {
            set_param_value $src_value ${DEST_PARAM}
        }
    }
}

proc update_MODELPARAM_VALUE.C_AXI_SUPPORTS_WRITE { MODELPARAM_VALUE.C_AXI_SUPPORTS_WRITE PARAM_VALUE.READ_WRITE_MODE } {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    array set map [subst {READ_WRITE 1 WRITE_ONLY 1 READ_ONLY 0}]

    set SRC_PARAM ${PARAM_VALUE.READ_WRITE_MODE}
    set DEST_PARAM ${MODELPARAM_VALUE.C_AXI_SUPPORTS_WRITE}

    set src_value $map([get_param_value ${SRC_PARAM}])
    set dest_value [get_param_value ${DEST_PARAM}]

    if { [string equal -nocase $src_value $dest_value] != 1 } {
        if { $src_value != "" } {
            set_param_value $src_value ${DEST_PARAM}
        }
    }
}

proc update_MODELPARAM_VALUE.C_AXI_SUPPORTS_READ { MODELPARAM_VALUE.C_AXI_SUPPORTS_READ PARAM_VALUE.READ_WRITE_MODE } {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
    array set map [subst {READ_WRITE 1 WRITE_ONLY 0 READ_ONLY 1}]

    set SRC_PARAM ${PARAM_VALUE.READ_WRITE_MODE}
    set DEST_PARAM ${MODELPARAM_VALUE.C_AXI_SUPPORTS_READ}

    set src_value $map([get_param_value ${SRC_PARAM}])
    set dest_value [get_param_value ${DEST_PARAM}]

    if { [string equal -nocase $src_value $dest_value] != 1 } {
        if { $src_value != "" } {
            set_param_value $src_value ${DEST_PARAM}
        }
    }
}

# Invalid option value 'PARAM_VALUE.AWUSER_WIDTH' specified for 'object'.

proc update_MODELPARAM_VALUE.C_AXI_SUPPORTS_USER_SIGNALS { MODELPARAM_VALUE.C_AXI_SUPPORTS_USER_SIGNALS PARAM_VALUE.AWUSER_WIDTH PARAM_VALUE.ARUSER_WIDTH PARAM_VALUE.WUSER_WIDTH PARAM_VALUE.RUSER_WIDTH PARAM_VALUE.BUSER_WIDTH} {
    # Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value

    set DEST_PARAM ${MODELPARAM_VALUE.C_AXI_SUPPORTS_USER_SIGNALS}
    puts "$DEST_PARAM"

    set src_value 0

    foreach channel {AW AR W R B} {
        set param_name PARAM_VALUE.${channel}USER_WIDTH
        if {[get_param_value [set ${param_name}]] > 0} {
            set src_value 1
            break
        }
    }

    set dest_value [get_param_value ${DEST_PARAM}]

    if { [string equal -nocase $src_value $dest_value] != 1 } {
        if { $src_value != "" } {
            set_param_value $src_value ${DEST_PARAM}
        }
    }

}
