
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

##--------------------------------------------------------------
# IMPORTANT: Set AD7616 operation and interface mode
#
# The get_env_param procedure retrieves parameter value from the environment if exists,
# other case returns the default value specified in its second parameter field.
#
#   How to use over-writable parameters from the environment:
#
#    e.g.
#      make SI_OR_PI=0
#
#    SI_OR_PI  - Defines the interface type (serial OR parallel)
#
# LEGEND: Serial    - 0
#         Parallel  - 1
#
# NOTE : This switch is a 'hardware' switch. Please reimplenent the
# design if the variable has been changed.
#
##--------------------------------------------------------------

if {[info exists ::env(SI_OR_PI)]} {
  set S_SI_OR_PI $SI_OR_PI
  puts "param is $S_SI_OR_PI got from $SI_OR_PI"
} elseif {![info exists SI_OR_PI]} {
  set S_SI_OR_PI 0
  puts "param not found; set to 0"
}

adi_project ad7616_sdz_zc706 0 [list \
  SI_OR_PI  [get_env_param SI_OR_PI  0] \
]

adi_project_files ad7616_sdz_zc706 [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc"]

switch [get_env_param SI_OR_PI 2] {
  0 {
    puts "switch got $S_SI_OR_PI"
    adi_project_files ad7616_sdz_zc706 [list \
      "system_top_si.v" \
      "serial_if_constr.xdc"
    ]
  }
  1 {
    puts "switch got $S_SI_OR_PI"
    adi_project_files ad7616_sdz_zc706 [list \
      "system_top_pi.v" \
      "parallel_if_constr.xdc"
    ]
  }
}

adi_project_run ad7616_sdz_zc706
