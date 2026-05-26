# Basic Genus Tcl script to check what clock is associated with selected pins.
#
# Usage from repository root inside Genus:
#   source genus_commands/check_pin_clock_basic.tcl
#
# If you source this script from inside the genus_commands folder:
#   source check_pin_clock_basic.tcl
#
# To check more pins later, update only the pin_checks block below.
# Add one line per instance/pin pattern pair, then source this file again.
#
# Example:
#   set pin_checks {
#       {core/w_mem_inst_w_mem_reg[3][25] *CK*}
#       {core/w_mem_inst_w_mem_reg[3][26] *CK*}
#       {top/u_cpu/u_reg0 *CLK*}
#   }

# Load shared collection helpers if they are not already loaded.
if {[llength [info commands list_count]] == 0} {
    set script_dir [file dirname [info script]]
    set util_file [file normalize [file join $script_dir .. eda_collection_utils.tcl]]

    if {[file exists $util_file]} {
        source $util_file
    } else {
        puts "WARNING: Could not find eda_collection_utils.tcl at:"
        puts "  $util_file"
        puts "Please source eda_collection_utils.tcl before this script."
    }
}

# EDIT HERE: Add or change entries in this block for multiple pins.
#
# Format:
#   {instance_name pin_name_pattern}
#
# Use braces around names containing [ ] so Tcl treats them as literal text.
set pin_checks {
    {core/w_mem_inst_w_mem_reg[3][25] *CK*}
}

proc get_genus_cell_objects {inst_name} {
    if {[llength [info commands get_cells]] > 0} {
        return [get_cells $inst_name]
    }

    if {[llength [info commands get_cell]] > 0} {
        return [get_cell $inst_name]
    }

    error "No get_cells or get_cell command found in this tool shell."
}

proc print_collection_or_string {objects_or_text} {
    if {[llength [info commands list_lines]] > 0} {
        if {![catch {list_lines $objects_or_text}]} {
            return
        }
    }

    puts $objects_or_text
}

proc check_pin_clock {inst_name pin_pattern} {
    puts "============================================================"
    puts "Instance pattern : $inst_name"
    puts "Pin pattern      : $pin_pattern"

    set cells [get_genus_cell_objects $inst_name]

    if {[list_count $cells] == 0} {
        puts "ERROR: No cell found for: $inst_name"
        return
    }

    puts ""
    puts "Matched cell(s):"
    print_collection_or_string $cells

    set pins [get_pins -of_objects $cells -filter "full_name=~$pin_pattern"]

    if {[list_count $pins] == 0} {
        puts ""
        puts "ERROR: No pin found with pattern: $pin_pattern"
        return
    }

    puts ""
    puts "Matched pin(s):"
    print_collection_or_string $pins

    puts ""
    puts "Clock check:"

    if {[llength [info commands get_db]] > 0} {
        if {![catch {set clocks [get_db $pins .clocks]} error_message]} {
            if {[string length $clocks] > 0} {
                puts "Clock(s) from Genus get_db pin .clocks:"
                puts $clocks
                return
            }

            puts "No clock found from get_db pin .clocks."
        } else {
            puts "get_db pin .clocks failed:"
            puts "  $error_message"
        }
    }

    puts ""
    puts "Fallback checks to run manually:"
    foreach pin_name [list_names $pins] {
        puts "  report_timing -to $pin_name"
        puts "  report_timing -through $pin_name"
        puts "  report_property $pin_name"
        puts "  get_db \[get_pins $pin_name\] .?"
        puts "  get_db \[get_pins $pin_name\] .clocks"
        puts "  get_db \[get_pins $pin_name\] .net"
    }
}

foreach check $pin_checks {
    set inst_name [lindex $check 0]
    set pin_pattern [lindex $check 1]

    check_pin_clock $inst_name $pin_pattern
}

