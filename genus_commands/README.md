# Cadence Genus Command Reference

Useful manual Tcl command patterns for Cadence Genus synthesis debug, collection handling, pin checks, and clock tracing.

## Folder Contents

| File | Purpose |
| --- | --- |
| `README.md` | Manual Genus command examples for copy/paste reference. |
| `check_pin_clock_basic.tcl` | Commented manual command note for checking the clock on a selected pin. |

## Check Clock on a Pin

Working Genus command:

```tcl
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .clocks
```

Expected style of output:

```text
clock:sha256/CLK
```

Meaning: the pin is associated with clock `sha256/CLK`.

## Why Braces Are Important

Use braces around names containing square brackets:

```tcl
{core/w_mem_inst_w_mem_reg[3][25]}
```

Do not write this without braces:

```tcl
core/w_mem_inst_w_mem_reg[3][25]
```

Tcl treats `[3]` and `[25]` as command substitutions when they are not protected.

## Try Multiple Pins Manually

Update the instance name in each command and run them one by one:

```tcl
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .clocks
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][26]}] -filter "full_name=~*CK*"] .clocks
get_db [get_pins -of_objects [get_cells {top/u_cpu/u_reg0}] -filter "full_name=~*CLK*"] .clocks
```

For learning, it is better to first store the objects in variables:

```tcl
set inst {core/w_mem_inst_w_mem_reg[3][25]}
set cell [get_cells $inst]
set pin  [get_pins -of_objects $cell -filter "full_name=~*CK*"]

get_db $pin .clocks
```

## Basic Object Queries

Get one cell:

```tcl
get_cells {core/w_mem_inst_w_mem_reg[3][25]}
```

Alternative Genus style:

```tcl
get_cell {core/w_mem_inst_w_mem_reg[3][25]}
```

Get pins of a cell:

```tcl
get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}]
```

Get only clock-like pins:

```tcl
get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"
```

## Useful `get_db` Attribute Commands

Store a pin collection:

```tcl
set pin [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"]
```

List available attributes:

```tcl
get_db $pin .?
```

Common pin attributes:

```tcl
get_db $pin .name
get_db $pin .full_name
get_db $pin .direction
get_db $pin .clocks
get_db $pin .net
```

Trace the net connected to a pin:

```tcl
set net [get_db $pin .net]
get_db $net .name
get_db $net .full_name
get_db $net .drivers
get_db $net .loads
```

## Timing-Based Checks

If attribute lookup is unclear, use timing reports:

```tcl
report_timing -to {core/w_mem_inst_w_mem_reg[3][25]/CK}
report_timing -through {core/w_mem_inst_w_mem_reg[3][25]/CK}
```

For a pin collection:

```tcl
set pin [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"]
report_timing -to $pin
report_timing -through $pin
```

## Redirect Output to a File

Use braces with `redirect` so the command runs inside the redirect block:

```tcl
redirect get_cells.rpt {
    list_lines [get_cells -hierarchical *]
}
```

Or use the helper:

```tcl
list_lines_to_file [get_cells -hierarchical *] get_cells.rpt
```

## Quick Debug Pattern

This is a useful step-by-step pattern while learning:

```tcl
set inst {core/w_mem_inst_w_mem_reg[3][25]}
set cell [get_cells $inst]
set pin  [get_pins -of_objects $cell -filter "full_name=~*CK*"]

list_lines $cell
list_lines $pin

get_db $pin .?
get_db $pin .clocks
get_db $pin .net
report_timing -to $pin
```
