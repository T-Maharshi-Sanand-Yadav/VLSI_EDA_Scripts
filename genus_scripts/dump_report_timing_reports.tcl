# Cadence Genus report_timing dump helper.
#
# Goal:
#   Dump timing reports under the current working directory in:
#     ./reports/
#
# Usage inside Genus:
#   source genus_scripts/dump_report_timing_reports.tcl
#
# Output example:
#   ./reports/report_timing_default.rpt
#
# Notes:
#   - Keep this script in the repository.
#   - Run it from the design/run directory where you want reports created.
#   - If an option is not supported by your Genus version, the script writes
#     the error message into that report file and continues.

set report_dir [file normalize [file join [pwd] reports]]

if {![file isdirectory $report_dir]} {
    file mkdir $report_dir
}

# EDIT HERE:
# Add report_timing combinations in this list.
#
# Format:
#   {output_file_name_without_extension {report_timing command and options}}
#
# Start with conservative commands. Add more combinations as needed.
set report_timing_jobs {
    {report_timing_default {report_timing}}
}

# Optional examples to copy into report_timing_jobs after checking your
# Genus report_timing help/man page:
#
#   {report_timing_max_paths_10 {report_timing -max_paths 10}}
#   {report_timing_late {report_timing -delay_type max}}
#   {report_timing_early {report_timing -delay_type min}}
#   {report_timing_from_ports {report_timing -from [all_inputs]}}
#   {report_timing_to_ports {report_timing -to [all_outputs]}}

proc safe_file_name {name} {
    regsub -all {[^A-Za-z0-9_.-]} $name "_" clean_name
    return $clean_name
}

proc write_text_file {file_name text} {
    set fp [open $file_name w]
    puts $fp $text
    close $fp
}

proc dump_one_report_timing {report_dir report_name report_cmd} {
    set safe_name [safe_file_name $report_name]
    set report_file [file join $report_dir "${safe_name}.rpt"]

    puts "Dumping: $report_file"
    puts "Command: $report_cmd"

    if {[catch {redirect $report_file $report_cmd} error_message]} {
        write_text_file $report_file "FAILED COMMAND:\n  $report_cmd\n\nERROR:\n  $error_message\n"
        puts "WARNING: Failed to dump $report_file"
        puts "         $error_message"
    }
}

puts "============================================================"
puts "Genus report_timing report dump"
puts "Working directory : [pwd]"
puts "Report directory  : $report_dir"
puts "============================================================"

foreach job $report_timing_jobs {
    set report_name [lindex $job 0]
    set report_cmd  [lindex $job 1]

    dump_one_report_timing $report_dir $report_name $report_cmd
}

puts "============================================================"
puts "Done. Reports are under:"
puts "  $report_dir"
puts "============================================================"
