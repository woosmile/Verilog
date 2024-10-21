transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/user/Desktop/RAM {C:/Users/user/Desktop/RAM/RAM1.v}

vlog -vlog01compat -work work +incdir+C:/Users/user/Desktop/RAM {C:/Users/user/Desktop/RAM/tb_RAM1.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone_ver -L rtl_work -L work -voptargs="+acc" tb_RAM1

add wave *
view structure
view signals
run -all
