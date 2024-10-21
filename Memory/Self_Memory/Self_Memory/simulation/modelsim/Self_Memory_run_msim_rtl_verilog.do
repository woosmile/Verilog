transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/user/Desktop/Self_Memory {C:/Users/user/Desktop/Self_Memory/Self_Memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/user/Desktop/Self_Memory {C:/Users/user/Desktop/Self_Memory/ADD_SUB.v}

vlog -vlog01compat -work work +incdir+C:/Users/user/Desktop/Self_Memory {C:/Users/user/Desktop/Self_Memory/tb_Self_Memory.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone_ver -L rtl_work -L work -voptargs="+acc" tb_Self_Memory

add wave *
view structure
view signals
run -all
