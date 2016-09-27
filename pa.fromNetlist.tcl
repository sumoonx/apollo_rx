
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name apollo_rx -dir "E:/Workspace/CompanyProjects/VLC/apollo_rx/planAhead_run_1" -part xc6slx25ftg256-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/Workspace/CompanyProjects/VLC/apollo_rx/apollo_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/Workspace/CompanyProjects/VLC/apollo_rx} }
set_property target_constrs_file "apollo.ucf" [current_fileset -constrset]
add_files [list {apollo.ucf}] -fileset [get_property constrset [current_run]]
link_design
