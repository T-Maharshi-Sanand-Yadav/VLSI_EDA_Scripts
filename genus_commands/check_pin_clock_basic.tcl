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

