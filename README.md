# YANI

**YANI** (Yet Another NEANDER Implementation), as the name suggests, is a microarchitecture implementation of the hypothetical processor NEANDER written in VHDL. The project was developed as an assignment for the Sistemas Digitais (INF01175) class.

### Introduction

NEANDER is a simple hypothetical processor developed for educational purposes by Raul and Taisy Weber. Some of its main features are:

- 8-bit data and address bus;
- Unified memory of 256 bytes for both instructions and data, based on the von Neumann architecture;
- Multicycle datapath, i.e., each instruction is executed across multiple clock cycles;
- Accumulator-based architecture with a single operand;
- Direct addressing to fetch the operand.

The NEANDER processor is best described in [1].

In this project, the original ISA will be extended to include four more instructions: `SUB`, `XOR`, `SHR` and `SHL`. The following table describes each instruction:

| **Value** | **Instruction**           | **Description**               |
|-----------|---------------------------|-------------------------------|
| 0000      | `NOP`                     | -                             |
| 0001      | `STA` &lt;addr&gt;        | MEM(addr) &larr; ACC          |
| 0010      | `LDA` &lt;addr&gt;        | ACC &larr; MEM(addr)          |
| 0011      | `ADD` &lt;addr&gt;        | ACC &larr; ACC + MEM(addr)    |
| 0100      | `OR`  &ensp;&lt;addr&gt;  | ACC &larr; ACC or MEM(addr)   |
| 0101      | `NOT`                     | ACC &larr; not ACC            |
| 0110      | `XOR` &lt;addr&gt;        | ACC &larr; ACC xor MEM(addr)  |
| 1000      | `JMP` &lt;addr&gt;        | PC &larr; addr                |
| 1001      | `JN`  &ensp;&lt;addr&gt;  | if N=1 then PC &larr; addr    |
| 1010      | `JZ`  &ensp;&lt;addr&gt;  | if Z=1 then PC &larr; addr    |
| 1011      | `SUB` &lt;addr&gt;        | ACC &larr; ACC - MEM(addr)    |
| 1100      | `SHR` &lt;addr&gt;        | ACC &larr; ACC >> MEM(addr)   |
| 1101      | `SHL` &lt;addr&gt;        | ACC &larr; ACC << MEM(addr)   |
| 1111      | `HLT`                     | -                             |

The main entities of YANI are the ALU, memory, register bank, and control unit. The following block diagram illustrates how they are connected:

![YANI block diagram](assets/yani_diagram.svg)

One thing to note is that the memory was implemented as an asynchronous read RAM, but the memory unit can be made compatible with synchronous block RAMs and other memories after some tweaks.

### RTL simulation

The design can be simulated using [`yani_tb.vhd`](src/tb/yani_tb.vhd). This testbench is pretty simple: it instantiates the top entity and executes the program in [`mult_sum.mem`](sw/mult_sum.mem), which defines the multiplication of 3 and 5 as repeated addition. Other example memory images can be found in the [`sw/`](sw/) directory.

When simulating, it is important to confirm that the memory image is accessible to the simulator. If you are having problems with this, copy the memory image to the current working directory or use its full path in the `MEMORY_IMAGE_FILE_PATH` top parameter.

Additionally, the work library should be named `yani` instead of the default `work`. This can be set with the `--work` flag in GHDL or configured in the project settings in ModelSim and other simulators.

After simulating the testbench, we can view the resulting waveforms in GTKWave:

![Simulation viewed in GTKWave](assets/sim_gtkwave.png)

The other testbenches in [`src/tb/`](src/tb/) verify the individual units composing the top entity.

### References

**[1]** WEBER, R. F. *Fundamentos de arquitetura de computadores*. 4. ed. Porto Alegre: Bookman, 2012. 424 p. (Série Livros Didáticos Informática UFRGS, v. 8).
