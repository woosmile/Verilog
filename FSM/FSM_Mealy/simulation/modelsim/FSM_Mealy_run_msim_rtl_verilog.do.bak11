transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/user/Desktop/FSM_Mealy {C:/Users/user/Desktop/FSM_Mealy/FSM_Mealy.v}

vlog -vlog01compat -work work +incdir+C:/Users/user/Desktop/FSM_Mealy {C:/Users/user/Desktop/FSM_Mealy/tb_FSM_Mealy.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone_ver -L rtl_work -L work -voptargs="+acc" tb_FSM_Mealy

add wave *
view structure
view signals
run -all
