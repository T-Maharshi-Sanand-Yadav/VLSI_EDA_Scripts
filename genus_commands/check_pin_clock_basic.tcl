# Cadence Genus manual command note:
# Check which clock is associated with a selected clock pin.
#
# This file is only for copy/paste command reference.
# It is not a reusable script.

# Your working command:
get_db [get_pins -of_objects [get_cells core/w_mem_inst_w_mem_reg[3][25]] -filter "full_name=~*CK*"] .clocks

# Safer Tcl version:
# Use braces around instance names that contain [ ].
# This prevents Tcl from treating [3] and [25] as command substitutions.
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .clocks

# Expected output style:
#   clock:sha256/CLK
#
# Meaning:
#   The selected CK pin is associated with clock sha256/CLK.

# First learn what attributes are available on this pin in your Genus version:
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .?

# Common pin identity attributes:
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .name
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .full_name
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .base_name

# Common pin type/connectivity attributes:
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .direction
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .net
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .clocks

# If .net returns a net object, inspect that net:
get_db [get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .net] .?
get_db [get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .net] .name
get_db [get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .net] .full_name
get_db [get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .net] .drivers
get_db [get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .net] .loads

# Cleaner manual debug style using variables:
set inst {core/w_mem_inst_w_mem_reg[3][25]}
set cell [get_cells $inst]
set pin  [get_pins -of_objects $cell -filter "full_name=~*CK*"]
set net  [get_db $pin .net]

get_db $pin .?
get_db $pin .name
get_db $pin .full_name
get_db $pin .direction
get_db $pin .clocks
get_db $pin .net

get_db $net .?
get_db $net .name
get_db $net .full_name
get_db $net .drivers
get_db $net .loads

# Timing-based checks if you want to see the clock through timing reports:
report_timing -to $pin
report_timing -through $pin
