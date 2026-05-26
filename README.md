# VLSI EDA Scripts

[![Tcl](https://img.shields.io/badge/Language-Tcl-blue.svg)](https://www.tcl.tk/)
[![VLSI](https://img.shields.io/badge/Domain-VLSI%20EDA-orange.svg)](#)
[![YouTube](https://img.shields.io/badge/YouTube-Maharshi%20Sanand%20Yadav-red.svg)](https://www.youtube.com/@maharshisanandyadav)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-T.%20Maharshi%20Sanand%20Yadav-blue.svg)](https://www.linkedin.com/in/t-maharshi-sanand-yadav/)

Reusable Tcl helpers for VLSI, ASIC, FPGA, synthesis, STA, PnR, and implementation flows.

This repository is a growing collection of practical EDA scripts designed for engineers who work inside tool shells such as Synopsys PrimeTime/DC/ICC2, Cadence Genus/Innovus, and Xilinx Vivado.

## Why This Repo Exists

EDA tools often return objects as special collections instead of normal Tcl lists. That makes simple tasks like printing cells, counting pins, or exporting object names tool-specific and repetitive.

`eda_collection_utils.tcl` provides a small compatibility layer so the same commands work across common EDA environments.

## Current Contents

| File | Purpose |
| --- | --- |
| `eda_collection_utils.tcl` | Universal helpers for printing, counting, exporting, and converting EDA collections or Tcl lists. |
| `genus_commands/` | Cadence Genus manual command reference. |

## Genus Command Reference

Cadence Genus-specific examples are collected here:

```text
genus_commands/
```

Current Genus reference:

| File | Purpose |
| --- | --- |
| `genus_commands/README.md` | Reference notes for Genus `get_db`, pin attributes, clock checks, timing checks, and redirect usage. |
| `genus_commands/check_pin_clock_basic.tcl` | Copy/paste Genus command note for checking `.clocks` and related pin/net attributes. |

Quick Genus clock-pin check:

```tcl
get_db [get_pins -of_objects [get_cells {core/w_mem_inst_w_mem_reg[3][25]}] -filter "full_name=~*CK*"] .clocks
```

Useful related attributes:

```tcl
get_db $pin .?
get_db $pin .name
get_db $pin .full_name
get_db $pin .direction
get_db $pin .clocks
get_db $pin .net
```

## Supported Tool Styles

The helpers are written to auto-detect available commands and work with both collection-based and list-based APIs.

| Tool family | Typical commands supported |
| --- | --- |
| Synopsys DC / PrimeTime / ICC2 | `get_cells`, `get_pins`, `get_ports`, `all_registers`, `foreach_in_collection`, `sizeof_collection`, `get_object_name` |
| Cadence Genus / Innovus | `get_cell`, `get_cells`, collection-style query results |
| Xilinx Vivado | Tcl list-style results from commands such as `get_cells` |

## Quick Start

Clone the repository:

```bash
git clone https://github.com/T-Maharshi-Sanand-Yadav/VLSI_EDA_Scripts.git
cd VLSI_EDA_Scripts
```

Source the utility file inside your EDA tool shell:

```tcl
source eda_collection_utils.tcl
```

Print objects one per line:

```tcl
list_lines [get_cells -hierarchical *]
list_lines [get_pins *]
list_lines [get_ports *]
```

Get object names as a Tcl list:

```tcl
set port_names [list_names [get_ports *]]
set reg_names  [list_names [all_registers]]
```

Count objects:

```tcl
list_count [get_cells -hierarchical *]
```

Export object names to a file:

```tcl
list_lines_to_file [get_cells -hierarchical *] cells.rpt
```

## Hierarchical Cell Helpers

Print all hierarchical cells:

```tcl
eda_print_hier_cells
```

Print cells matching a hierarchy pattern:

```tcl
eda_print_hier_cells "sha256/core/*"
```

Return matching hierarchical cell objects:

```tcl
set cells [eda_get_hier_cells *]
```

Return only matching hierarchical cell names:

```tcl
set cell_names [eda_get_hier_cell_names "top/u_cpu/*"]
```

Short aliases are also available for interactive shells:

```tcl
print_hier_cells *
get_hier_cell_names *
```

## Command Reference

| Command | Description |
| --- | --- |
| `list_lines objects` | Prints object names one per line. |
| `list_names objects` | Returns object names as a Tcl list. |
| `list_count objects` | Returns the number of objects. |
| `list_lines_with_count objects` | Prints the object count, then prints names one per line. |
| `list_lines_to_file objects file_name` | Writes object names to a text file. |
| `eda_get_hier_cells ?pattern?` | Returns hierarchical cells matching a pattern. |
| `eda_get_hier_cell_names ?pattern?` | Returns hierarchical cell names matching a pattern. |
| `eda_print_hier_cells ?pattern?` | Prints matching hierarchical cell names with a count. |
| `get_hier_cell_names ?pattern?` | Short alias for `eda_get_hier_cell_names`. |
| `print_hier_cells ?pattern?` | Short alias for `eda_print_hier_cells`. |

## Example Use Cases

- Quickly inspect hierarchical instance names during synthesis or implementation.
- Convert EDA tool collection handles into regular Tcl name lists.
- Create simple reports without rewriting collection loops for each vendor tool.
- Make interactive debugging commands shorter and more consistent.
- Export cell, pin, port, or register lists for review.

## Design Principles

- Keep scripts small, readable, and easy to source.
- Prefer portable Tcl that works across multiple EDA shells.
- Avoid binding basic utilities to one vendor unless the script is explicitly tool-specific.
- Make commands friendly for both automation scripts and interactive debug sessions.

## Repository Roadmap

Planned script categories:

- Timing analysis helpers
- SDC query and validation helpers
- Netlist exploration utilities
- Physical design reporting helpers
- Library and Liberty inspection helpers
- QoR summary automation

## Naming Convention

Scripts follow this pattern:

```text
eda_<topic>_utils.tcl
```

Examples:

```text
eda_collection_utils.tcl
eda_timing_utils.tcl
eda_sdc_utils.tcl
eda_qor_utils.tcl
```

## Requirements

- Tcl-enabled EDA shell
- No external package dependency

The scripts are intended to be sourced directly inside tool environments.

## Contributing

Contributions are welcome, especially practical utilities that help VLSI engineers save time in real tool flows.

Good additions include:

- Small reusable Tcl procedures
- Tool-portable reporting helpers
- Clear examples and tested command snippets
- Scripts for synthesis, STA, PnR, signoff, and debug workflows

## Connect and Learn

Follow my VLSI learning content, tutorials, and updates here:

| Platform | Link |
| --- | --- |
| YouTube | [Maharshi Sanand Yadav T](https://www.youtube.com/@maharshisanandyadav) |
| YouTube Membership | [Join the TMSY community](https://www.youtube.com/@maharshisanandyadav/join) |
| LinkedIn | [T. Maharshi Sanand Yadav](https://www.linkedin.com/in/t-maharshi-sanand-yadav/) |
| Udemy | [Digital System Design using Verilog HDL](https://www.udemy.com/course/digital-system-design-using-verilog-hdl/) |

## License

No license file has been added yet. If you plan to reuse this code publicly or contribute, add a license such as MIT, Apache-2.0, or BSD-3-Clause.

## Author

Created and maintained by **T. Maharshi Sanand Yadav**.

If this repository helps you, consider starring it on GitHub and sharing it with other VLSI learners and engineers.
