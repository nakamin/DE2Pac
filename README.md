# DE2Pac

A synthesizer built on the Altera DE2 board for CSCB58

# Compile and flash

To compile run from WSL

```bash
$: cd quartus
$: make
```

To program the DE2 board run from WSL

```bash
$: cd quartus
$: make program
```

# VSCode workflow

Press `Ctrl-shift-b` to see the build tasks
First run Synthesis and make sure there are no errors
Then run Compile
Then program
If anything weird happens run Clean

# Demo video
https://youtu.be/RyISh3d2zlY
