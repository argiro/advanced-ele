

#file mkdir work

set RTL_DIR [pwd]/../rtl
set TB_DIR  [pwd]/../testbench

create_project -force sim [pwd] -part xc7a35ticsg324-1L


add_files -norecurse -fileset sources_1 [glob ${RTL_DIR}/*.v]
add_files -norecurse -fileset sources_1 [glob ${RTL_DIR}/UART/*.v]
add_files -norecurse -fileset sim_1     [list ${TB_DIR}/tb_overflow.v]

import_files -force -norecurse

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1 


#launch_simulation
launch_simulation -simset sim_1 -step all -mode behavioral -verbose


#report_property [current_project]
#report_property [current_sim]


start_gui

#relaunch_simulation
