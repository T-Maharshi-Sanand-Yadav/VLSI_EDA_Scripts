# Folder to store command man pages
set out_dir "man_pages"

# Create folder if it does not exist
if {![file exists $out_dir]} {
    file mkdir $out_dir
    puts "? Created folder: $out_dir"
} else {
    puts "?? Folder already exists: $out_dir"
}

# Open the command list
set cmd_file [open "sdc_cmds.txt" r]
set cmds [split [read $cmd_file] "\n"]
close $cmd_file

# Iterate through each command
foreach cmd $cmds {
    if {$cmd eq ""} {continue}

    # Output file for this command
    set out_file [file join $out_dir "${cmd}_man.txt"]

    # Write header to the file
    set fp [open $out_file w]
    puts $fp "======================"
    puts $fp "Command: $cmd"
    puts $fp "======================\n"
    close $fp

    # Append the man page output for this command
    redirect -append $out_file "man $cmd"
}

puts "?? Done! All command man pages are in the folder '$out_dir'."

