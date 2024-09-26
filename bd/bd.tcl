

proc copy_property {src_obj src_property dest_obj dest_property} {

	if {[llength src_property] <= 0} {
		set src_property [list $src_property ]
		set dest_property [list $dest_property ]
	}

	for {set index 0} {$index < [llength src_property]} {incr index} {

		set src_property_name CONFIG.[lindex $src_property $index]
		set dest_property_name CONFIG.[lindex $dest_property $index]

		set val_on_src_obj [get_property $src_property_name $src_obj]
		set val_on_dest_obj [get_property $dest_property_name $dest_obj]

		if { [string equal -nocase $val_on_src_obj $val_on_dest_obj] != 1 } {
			if { $val_on_src_obj != "" } {
				# puts "Importing property $src_property_name of $src_obj to $dest_property_name of $dest_obj"
				set_property -quiet $dest_property_name $val_on_src_obj $dest_obj
			}
		}
	}
}

proc propagate_axi {cellpath otherInfo } {

	set param_list [list PROTOCOL READ_WRITE_MODE DATA_WIDTH ID_WIDTH AWUSER_WIDTH ARUSER_WIDTH WUSER_WIDTH RUSER_WIDTH BUSER_WIDTH]

	set ip [get_bd_cells $cellpath]
	set mi [get_bd_intf_pins $cellpath/M_AXI]
	set si [get_bd_intf_pins $cellpath/S_AXI]

	# 获取该 IP 接口所连接接口
	set con_si [find_bd_objs -quiet -thru_hier -relation connected_to $si]
	set con_mi [find_bd_objs -quiet -thru_hier -relation connected_to $mi]

	if {[get_property CONFIG.S_AXI_ADDR_WIDTH.VALUE_SRC $ip] != "USER"} {
		set_property CONFIG.ADDR_WIDTH.VALUE_SRC WEAK $si
		copy_property $con_si ADDR_WIDTH $ip S_AXI_ADDR_WIDTH
		copy_property $con_si ADDR_WIDTH $si ADDR_WIDTH
	} else {
		set_property CONFIG.ADDR_WIDTH.VALUE_SRC USER $si
		copy_property $ip S_AXI_ADDR_WIDTH $si ADDR_WIDTH
	}

	if {[get_property CONFIG.M_AXI_ADDR_WIDTH.VALUE_SRC $ip] != "USER"} {
		set_property CONFIG.ADDR_WIDTH.VALUE_SRC WEAK $mi
		set_property CONFIG.ADDR_WIDTH.VALUE_SRC WEAK $con_mi
		copy_property $con_mi ADDR_WIDTH $ip M_AXI_ADDR_WIDTH
		copy_property $con_mi ADDR_WIDTH $mi ADDR_WIDTH
		copy_property $con_mi ADDR_WIDTH $con_mi ADDR_WIDTH
	} else {
		set_property CONFIG.ADDR_WIDTH.VALUE_SRC USER $mi
		set_property CONFIG.ADDR_WIDTH.VALUE_SRC USER $con_mi
		copy_property $ip M_AXI_ADDR_WIDTH $mi ADDR_WIDTH
		copy_property $ip M_AXI_ADDR_WIDTH $con_mi ADDR_WIDTH
	}

	# 遍历模块所有接口
	foreach tparam $param_list {
		if {[get_property CONFIG.$tparam.VALUE_SRC $ip] != "USER"} {
			set_property CONFIG.${tparam}.VALUE_SRC WEAK $si
			set_property CONFIG.${tparam}.VALUE_SRC WEAK $mi
			copy_property $con_si $tparam $ip $tparam
			copy_property $con_si $tparam $si $tparam
			copy_property $con_si $tparam $mi $tparam
		} else {
			set_property CONFIG.${tparam}.VALUE_SRC USER $si
			set_property CONFIG.${tparam}.VALUE_SRC USER $mi
			copy_property $ip $tparam $si $tparam
			copy_property $ip $tparam $mi $tparam
		}
	}

	foreach tparam $param_list {
		if {[get_property CONFIG.$tparam.VALUE_SRC $con_mi] != "USER"} {
			copy_property $ip $tparam $con_mi $tparam
		}
	}

}

proc init { cellpath otherInfo } {
	# puts "init"

	set cell_handle [get_bd_cells $cellpath]
	set param_list [list PROTOCOL READ_WRITE_MODE DATA_WIDTH ID_WIDTH AWUSER_WIDTH ARUSER_WIDTH WUSER_WIDTH RUSER_WIDTH BUSER_WIDTH]
	set full_sbusif_list [list S_AXI]

	# 遍历模块所有接口
	set all_busif [get_bd_intf_pins $cellpath/*]
	foreach busif $all_busif {

		# 若接口模式为 "slave"
		if { [string equal -nocase [get_property MODE $busif] "slave"] == 1 } {

			set busif_param_list [list]

			# 获取接口名称，查找接口是否在接口列表中
			set busif_name [get_property NAME $busif]
			if { [lsearch -exact -nocase $full_sbusif_list $busif_name ] == -1 } {
				continue
			}

			# 遍历接口参数
			foreach tparam $param_list {
				# 推断接口参数名称，将接口参数名称添加到接口参数列表中
				lappend busif_param_list "${tparam}"
			}

			# 标记参数为仅接受继承
			bd::mark_propagate_only $cell_handle $busif_param_list
		}
	}

	# 设置参数可覆写
	bd::mark_propagate_overrideable $cell_handle {PROTOCOL S_AXI_ADDR_WIDTH M_AXI_ADDR_WIDTH READ_WRITE_MODE DATA_WIDTH ID_WIDTH AWUSER_WIDTH ARUSER_WIDTH WUSER_WIDTH RUSER_WIDTH BUSER_WIDTH}
	set_property CONFIG.PROTOCOL.VALUE_SRC WEAK [get_bd_intf_pins $cellpath/S_AXI]
	set_property CONFIG.PROTOCOL.VALUE_SRC WEAK [get_bd_intf_pins $cellpath/M_AXI]
}

proc pre_propagate {cellpath otherInfo } {
	# puts "pre_propagate"

	propagate_axi $cellpath $otherInfo
}

proc propagate {cellpath otherInfo } {
	# puts "propagate"

	propagate_axi $cellpath $otherInfo

	set ip [get_bd_cells $cellpath]

	# if {[get_property CONFIG.M_AXI_BASEADDR.VALUE_SRC $ip] != "USER"} {
	# 	set_property CONFIG.M_AXI_BASEADDR [get_property OFFSET [get_bd_addr_segs $ip/M_AXI/*]] $ip
	# }

}
