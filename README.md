# DE1_SoC_template 

A reusable Quartus Prime project template for the Terasic DE1-SoC development board.

This repository provides a clean starting point for projects using the Cyclone V SoC FPGA and its Hard Processor System (HPS), avoiding the need to repeatedly configure board-level pin assignments and HPS settings.

## Target Hardware

- **Board:** Terasic DE1-SoC
- **FPGA:** Intel/Altera Cyclone V SoC
- **Device:** `5CSEMA5F31C6`

## Repository Structure

```text
DE1_SoC_template/
├── .gitignore
├── README.md
├── DE1_SoC_template.qpf
├── top.qsf
├── top.sv
└── platform_designer_module.tcl
```

### `top.sv`

Top-level SystemVerilog module containing the physical interfaces available on the DE1-SoC.

This acts as the board-level wrapper for the design. Project-specific RTL can be instantiated beneath this module as required.

### `top.qsf`

Contains the Quartus project assignments, including:

- target Cyclone V device
- DE1-SoC pin assignments
- I/O standards
- board-level configuration

The intention is that the board-specific assignments can be reused between projects rather than recreated manually.

### `platform_designer_module.tcl`

Tcl representation of the base Platform Designer system.

It contains the configuration required to recreate the Platform Designer design, including the preconfigured DE1-SoC HPS setup.

The generated `.qsys` file is deliberately not stored in the repository. Instead, it can be recreated from this script.

## Starting a New Project

The repository is intended to be used as a template for new DE1-SoC projects.

After creating a new project from the template, enter the project directory and recreate the Platform Designer system:

```bash
export PATH="$PATH:/path/to/quartus/sopc_builder/bin"
qsys-script --script=platform_designer_module.tcl
```

This creates:

```text
platform_designer_module.qsys
```

The generated `.qsys` file can then be opened in Platform Designer.

## Platform Designer Workflow

After generating `platform_designer_module.qsys`:

1. Open the `.qsys` file in Platform Designer.
2. Keep the existing HPS configuration as the base system.
3. Add any project-specific peripherals or interfaces.
4. Connect them to the required HPS-to-FPGA bridge or other interfaces.
5. Generate the Platform Designer HDL.
6. Compile the Quartus project.

In general:

```text
platform_designer_module.tcl
              │
              ▼
platform_designer_module.qsys
              │
              ▼
      Platform Designer
              │
        Generate HDL
              │
              ▼
     Generated synthesis files
              │
              ▼
          Quartus build
```

## Why the Platform Designer System is Stored as Tcl

Platform Designer generates a large number of files which do not need to be stored in version control.

Instead, this repository keeps the Tcl script required to recreate the system.

This provides a small, readable and reproducible source for the Platform Designer configuration while allowing generated files to remain excluded from Git.

In particular:

```text
TRACKED
    platform_designer_module.tcl

GENERATED
    platform_designer_module.qsys
    .qsys_edit/
    platform_designer_module/
```

## Adding Project-Specific RTL

Additional SystemVerilog modules can be added alongside `top.sv` or organised into an `rtl/` directory.

For example:

```text
DE1_SoC_template/
├── top.sv
├── rtl/
│   ├── peripheral.sv
│   └── controller.sv
└── ...
```

Add any new RTL source files to the Quartus project as normal.

The board-level `top.sv` and pin assignments can remain largely unchanged between projects.

## Generated Files

Quartus and Platform Designer produce build databases, reports, synthesis output and programming files.

These are intentionally excluded using `.gitignore`.

Examples include:

```text
db/
incremental_db/
output_files/
.qsys_edit/
platform_designer_module/
*.sof
*.rpt
*.sopcinfo
```

These files should be regenerated locally rather than committed to the repository.

## Typical Workflow

```text
Create project from template
          │
          ▼
Generate .qsys from Tcl
          │
          ▼
Open Platform Designer
          │
          ▼
Add project-specific hardware
          │
          ▼
Generate HDL
          │
          ▼
Add/write project RTL
          │
          ▼
Compile in Quartus
          │
          ▼
Program DE1-SoC
```

## Toolchain

The template was created using:

- **Quartus Prime Lite 25.1**
- **Platform Designer**
- **SystemVerilog**

Other Quartus versions may also work, although generated IP or Platform Designer configuration may require upgrading when moving between versions.

## Note: This README file was generated with the assistance of AI and reviewed by the project author.
