set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT2]]
set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT3]]

set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT2]]
set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT3]]

set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT2]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT2]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT2]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT3]]

set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT3]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT3]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT3]] -to [get_clocks -of_objects [get_pins pll_inst/inst/mmcm_adv_inst/CLKOUT2]]


