# MU0_Game
A game written in MU0 assembly. Works with a six-digit display in which you move a segment between digits with keypad keys 4, 5 and 6 to catch a moving enemy.

Ran on an FPGA synthesised with an MU0 processor.

## Controls

| Input | Action |
|---|---|
| Start button | Start the game / play again |
| Key 4 | Move left |
| Key 6 | Move right |
| Key 5 | Switch between top and bottom segment |

## Optimisations
Reduced size of player changeHeight code by 82% (33 to 6 instructions), by using self-modifying code.
Now, this section always executes 6 instructions rather than 5 to 18 (was dependant on playerPos).
Code shown here:
```asm
changeHeight
    LDA staDig0 ;loads the instruction STA dig0 (&1FF5)
    ADD playerPos
    STA setHeight
    LDA upOrDown
setHeight
    STA dig0 ; this instruction gets overwritten with STA dig(playerPos)
    JMP mainLoop
```
