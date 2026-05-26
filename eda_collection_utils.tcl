# Universal EDA collection helpers.
#
# File naming convention:
#   eda_<topic>_utils.tcl
#
# Usage:
#   source eda_collection_utils.tcl
#   list_lines [get_cells -hierarchical *]
#   list_lines [get_pins *]
#   list_lines [all_registers]
#   set names [list_names [get_ports]]
#   eda_print_hier_cells
#   eda_print_hier_cells "sha256/core/*"
#   set names [eda_get_hier_cell_names *]
#
# Tested command families:
#   Cadence Genus/Innovus style: get_cell
#   Synopsys DC/PT/ICC2 style:  get_cells
#   Xilinx Vivado style:        get_cells
#
# The helpers auto-detect whether the current tool returns an EDA
# collection handle or a normal Tcl list, then iterate accordingly.

namespace eval ::eda_collection_utils {
    variable version 1.0
}

proc ::eda_collection_utils::has_cmd {cmd_name} {
    expr {[llength [info commands $cmd_name]] > 0}
}

proc ::eda_collection_utils::query_hier_cells {pattern} {
    if {[has_cmd get_cells]} {
        if {![catch {get_cells -hierarchical $pattern} cells]} {
            return $cells
        }
    }

    if {[has_cmd get_cell]} {
        if {![catch {get_cell -hierarchical $pattern} cells]} {
            return $cells
        }
    }

    error "No supported hierarchical cell query command found. Expected get_cells or get_cell."
}

proc ::eda_collection_utils::collection_size {objects} {
    if {[has_cmd sizeof_collection]} {
        if {![catch {sizeof_collection $objects} size]} {
            return $size
        }
    }

    return [llength $objects]
}

proc ::eda_collection_utils::object_name {object} {
    if {[has_cmd get_object_name]} {
        if {![catch {get_object_name $object} name]} {
            return [display_name $name]
        }
    }

    return [display_name $object]
}

proc ::eda_collection_utils::display_name {name} {
    if {[regexp {^\{(.*)\}$} $name match inner_name]} {
        return $inner_name
    }

    return $name
}

proc ::eda_collection_utils::object_names {objects} {
    set names {}

    if {[has_cmd foreach_in_collection]} {
        if {![catch {
            foreach_in_collection object $objects {
                lappend names [object_name $object]
            }
        }]} {
            return $names
        }
    }

    foreach object $objects {
        lappend names [object_name $object]
    }

    return $names
}

proc list_lines {objects} {
    set names [::eda_collection_utils::object_names $objects]

    foreach name $names {
        puts $name
    }

    return ""
}

proc list_names {objects} {
    return [::eda_collection_utils::object_names $objects]
}

proc list_count {objects} {
    return [::eda_collection_utils::collection_size $objects]
}

proc list_lines_with_count {objects} {
    puts "Objects: [list_count $objects]"
    list_lines $objects

    return ""
}

proc list_lines_to_file {objects file_name} {
    set fp [open $file_name w]

    foreach name [::eda_collection_utils::object_names $objects] {
        puts $fp $name
    }

    close $fp
    return ""
}

proc eda_get_hier_cells {{pattern *}} {
    return [::eda_collection_utils::query_hier_cells $pattern]
}

proc eda_get_hier_cell_names {{pattern *}} {
    set cells [eda_get_hier_cells $pattern]
    return [::eda_collection_utils::object_names $cells]
}

proc eda_print_hier_cells {{pattern *}} {
    set cells [eda_get_hier_cells $pattern]
    puts "Hierarchical cells matching '$pattern': [::eda_collection_utils::collection_size $cells]"

    list_lines $cells
}

# Short aliases for interactive shells.
proc get_hier_cell_names {{pattern *}} {
    return [eda_get_hier_cell_names $pattern]
}

proc print_hier_cells {{pattern *}} {
    eda_print_hier_cells $pattern
}
