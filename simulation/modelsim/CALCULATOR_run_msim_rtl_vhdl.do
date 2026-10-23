transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/Academic Courses_Year_1to5/2nd_Year/EE 214 DIGITAL CIRCUITS LAB/LAB_Project/seven_seg_decoder.vhd}
vcom -93 -work work {D:/Academic Courses_Year_1to5/2nd_Year/EE 214 DIGITAL CIRCUITS LAB/LAB_Project/seven_seg_scroll.vhd}

vcom -93 -work work {D:/Academic Courses_Year_1to5/2nd_Year/EE 214 DIGITAL CIRCUITS LAB/LAB_Project/tb_seven_seg_scroll.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  tb_seven_seg_scroll

add wave *
view structure
view signals
run -all
