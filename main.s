;When key 4 is pressed, digit should move to the 
;left. When 6 is pressed, digit moves to the right.
;When 5 is pressed, digit should move up/down.
ORG &000
start
    ; reset to start of game state
    LDA one
    STA upOrDown
    LDA zero
    STA playerPos
    LDA three
    STA enemyMoveCounter
    ; display 'START'
    LDA zero
    STA dig5
    LDA s
    STA dig4
    LDA t
    STA dig3
    STA dig0
    LDA a
    STA dig2
    LDA r
    STA dig1
isStartPressed
    LDA seed ; to get a psuedo random number
    ADD one
    STA seed
    ; check if start button is pressed (SW-H)
    LDA buttons
    SUB one
    JNE isStartPressed
    LDA sound1
    STA buzzer
    ; delay 
    LDA delay
delayLoopSound
    SUB one
    JNE delayLoopSound
    LDA sound2
    STA buzzer

    ; GENERATE ENEMY POS   
    ; seed = (seed * 3) + 1
    LDA seed
    ADD seed
    ADD seed
    ADD one
    JGE positiveSeed
    SUB mostSig
positiveSeed
    STA seed
modLoop
    SUB five
    JGE modLoop 
    ADD five
    ADD one

    STA enemyPos
    STA nextEnemyPos
; GENERATE ENEMY height
    LDA seed
parity
    SUB two
    JGE parity  
    ADD two
    JNE skip
    ADD down
skip
    STA enemyHeight
    STA nextEnemyHeight

; reset board
    LDA zero
    STA dig1
    STA dig2
    STA dig3
    STA dig4
    STA dig5
    LDA one
    STA dig0 ;first digit should display 1

;****checkCurrentDigit(set enemy)****
    LDA enemyPos
    JNE notE0

    LDA enemyHeight
    STA dig0
    JMP mainLoop
notE0
    LDA enemyPos
    SUB one
    JNE notE1

    LDA enemyHeight
    STA dig1
    JMP mainLoop
notE1
    LDA enemyPos
    SUB two
    JNE notE2

    LDA enemyHeight
    STA dig2
    JMP mainLoop
notE2
    LDA enemyPos
    SUB three
    JNE notE3
    
    LDA enemyHeight
    STA dig3
    JMP mainLoop
notE3
    LDA enemyPos
    SUB five
    ADD one
    JNE notE4
    
    LDA enemyHeight
    STA dig4
    JMP mainLoop
notE4
    LDA enemyHeight
    STA dig5
;****checkCurrentDigit(set enemy)****



mainLoop
    ; Check if playerPos == enemyPos
    ; Check height
    LDA upOrDown
    SUB enemyHeight
    JNE notTouching

    ; Check digit
    LDA playerPos
    SUB enemyPos
    JNE notTouching

    LDA sound2
    STA buzzer

    ; win delay 1
    LDA delay
winDelayLoop1
    SUB one
    JNE winDelayLoop1
    ; win delay 2
    LDA delay
winDelayLoop2
    SUB one
    JNE winDelayLoop2
    LDA zero
    STA dig0
    STA dig5
    STA dig4
    LDA w
    STA dig3
    LDA i
    STA dig2
    LDA n
    STA dig1

checkForReplay
    LDA buttons
    SUB one
    JNE checkForReplay
    JMP start


notTouching
    ; delay 1
    LDA delay
delayLoop1
    SUB one
    JNE delayLoop1
    ; delay 2
    LDA delay
delayLoop2
    SUB one
    JNE delayLoop2

; GET NEXT ENEMY POSITION
    LDA enemyMoveCounter
    SUB one
    STA enemyMoveCounter
    JGE movement
    LDA three
    STA enemyMoveCounter
    JMP keyLoop
movement   
    JNE moveSide
    LDA enemyPos
    SUB playerPos
    JNE heightChange
    JMP moveSide
heightChange
    LDA enemyHeight
    SUB one
    JNE curLow
    LDA down
    STA nextEnemyHeight
    JMP moveEnem
curLow
    LDA one
    STA nextEnemyHeight
    JMP moveEnem

moveSide

    LDA enemyPos
    JNE notZerothPos
    LDA five
    STA enemyPosSub
    LDA one
    STA enemyPosAdd
    JMP calcLongestDist
notZerothPos
    SUB five
    JNE notFifthPos
    LDA five
    SUB one
    STA enemyPosSub
    LDA zero
    STA enemyPosAdd
    JMP calcLongestDist
notFifthPos
    LDA enemyPos
    SUB one
    STA enemyPosSub
    ADD two
    STA enemyPosAdd
calcLongestDist
    SUB playerPos
    JGE positiveDist1
    LDA playerPos
    SUB enemyPosAdd
positiveDist1
    STA tempDistAdd
    SUB three
    JNE checkValidDist1
    JMP moveAdd
checkValidDist1
    JGE impossibleDistAdd ; distance between can never be more than 3
    JMP calcNextDist
impossibleDistAdd
    LDA five
    ADD one
    SUB tempDistAdd
    STA tempDistAdd
calcNextDist
    LDA enemyPosSub
    SUB playerPos
    JGE positiveDist2
    LDA playerPos
    SUB enemyPosSub
positiveDist2
    STA tempDistSub
    SUB three
    JNE checkValidDist2
    JMP moveSub
checkValidDist2
    JGE impossibleDistSub
    JMP calcDistDiff
impossibleDistSub
    LDA five
    ADD one
    SUB tempDistSub
    STA tempDistSub
calcDistDiff
    LDA tempDistSub
    SUB tempDistAdd
    JGE moveSub 
moveAdd
    LDA enemyPosAdd
    STA nextEnemyPos
    JMP moveEnem
moveSub
    LDA enemyPosSub
    STA nextEnemyPos

moveEnem
;****MOVE ENEMY(move enemy)****
;REMOVE CURRENT ENEMY POSITION
    LDA enemyPos
    JNE notE00

    LDA dig0
    SUB enemyHeight
    STA dig0
    JMP setEnemyPos
notE00
    LDA enemyPos
    SUB one
    JNE notE10

    LDA dig1
    SUB enemyHeight
    STA dig1
    JMP setEnemyPos
notE10
    LDA enemyPos
    SUB two
    JNE notE20

    LDA dig2
    SUB enemyHeight
    STA dig2
    JMP setEnemyPos
notE20
    LDA enemyPos
    SUB three
    JNE notE30
    
    LDA dig3
    SUB enemyHeight
    STA dig3
    JMP setEnemyPos
notE30
    LDA enemyPos
    SUB five
    ADD one
    JNE notE40
    
    LDA dig4
    SUB enemyHeight
    STA dig4
    JMP setEnemyPos
notE40
    LDA dig5
    SUB enemyHeight
    STA dig5

setEnemyPos
; MOVE TO NEW ENEMY POSITION
    LDA nextEnemyHeight
    STA enemyHeight
    LDA nextEnemyPos
    STA enemyPos

    JNE notE000

    LDA dig0
    ADD enemyHeight
    STA dig0
    JMP keyLoop
notE000
    LDA nextEnemyPos
    SUB one
    JNE notE100

    LDA dig1
    ADD enemyHeight
    STA dig1
    JMP keyLoop
notE100
    LDA nextEnemyPos
    SUB two
    JNE notE200

    LDA dig2
    ADD enemyHeight
    STA dig2
    JMP keyLoop
notE200
    LDA nextEnemyPos
    SUB three
    JNE notE300
    
    LDA dig3
    ADD enemyHeight
    STA dig3
    JMP keyLoop
notE300
    LDA nextEnemyPos
    SUB five
    ADD one
    JNE notE400
    
    LDA dig4
    ADD enemyHeight
    STA dig4
    JMP keyLoop
notE400
    LDA dig5
    ADD enemyHeight
    STA dig5

;****MOVE ENEMY(move enemy)****




keyLoop
    ; check if stop button is pressed (SW-H)
    LDA buttons
    SUB one
    JNE isKey4

    LDA zero
    STA dig0
    STA dig1
    STA dig2
    STA dig3
    STA dig4
    STA dig5
    STP
    ; check if key 4 is pressed
isKey4
    LDA keypad
    SUB key4
    JNE isKey6

; IS KEY 4
;****checkCurrentDigit(move left)****
    LDA playerPos
    JNE not00

    LDA dig0
    SUB upOrDown
    STA dig0
    LDA dig1
    ADD upOrDown
    STA dig1
    LDA playerPos
    ADD one
    STA playerPos
    JMP mainLoop
not00
    LDA playerPos
    SUB one
    JNE not01

    LDA dig1
    SUB upOrDown
    STA dig1
    LDA dig2
    ADD upOrDown
    STA dig2
    LDA playerPos
    ADD one
    STA playerPos
    JMP mainLoop
not01
    LDA playerPos
    SUB two
    JNE not02

    LDA dig2
    SUB upOrDown
    STA dig2
    LDA dig3
    ADD upOrDown
    STA dig3
    LDA playerPos
    ADD one
    STA playerPos
    JMP mainLoop
not02
    LDA playerPos
    SUB three
    JNE not03

    LDA dig3
    SUB upOrDown
    STA dig3
    LDA dig4
    ADD upOrDown
    STA dig4
    LDA playerPos
    ADD one
    STA playerPos
    JMP mainLoop
not03
    LDA playerPos
    SUB five
    ADD one
    JNE not04
    
    LDA dig4
    SUB upOrDown
    STA dig4
    LDA dig5
    ADD upOrDown
    STA dig5
    LDA playerPos
    ADD one
    STA playerPos
    JMP mainLoop
not04
    LDA dig5
    SUB upOrDown
    STA dig5
    LDA dig0
    ADD upOrDown
    STA dig0
    LDA playerPos
    SUB five
    STA playerPos
    JMP mainLoop
;****checkCurrentDigit(move left)****
; CHECK if 6 is pressed
isKey6
    LDA keypad
    SUB key6
    JNE isKey5
; IS KEY 6
;****checkCurrentDigit(move right)****
    

    ;check if position is 0
    LDA playerPos
    JNE not10
    LDA dig0
    SUB upOrDown
    STA dig0
    LDA dig5
    ADD upOrDown
    STA dig5
    LDA playerPos
    ADD five
    STA playerPos
    JMP mainLoop
not10
    LDA playerPos
    SUB one
    JNE not11

    LDA dig1
    SUB upOrDown
    STA dig1
    LDA dig0
    ADD upOrDown
    STA dig0
    LDA playerPos
    SUB one
    STA playerPos
    JMP mainLoop
not11
    LDA playerPos
    SUB two
    JNE not12
    
    LDA dig2
    SUB upOrDown
    STA dig2
    LDA dig1
    ADD upOrDown
    STA dig1
    LDA playerPos
    SUB one
    STA playerPos
    JMP mainLoop
not12
    LDA playerPos
    SUB three
    JNE not13

    LDA dig3
    SUB upOrDown
    STA dig3
    LDA dig2
    ADD upOrDown
    STA dig2
    LDA playerPos
    SUB one
    STA playerPos
    JMP mainLoop
not13
    LDA playerPos
    SUB five
    ADD one
    JNE not14

    LDA dig4
    SUB upOrDown
    STA dig4
    LDA dig3
    ADD upOrDown
    STA dig3
    LDA playerPos
    SUB one
    STA playerPos
    JMP mainLoop
not14
    LDA dig5
    SUB upOrDown
    STA dig5
    LDA dig4
    ADD upOrDown
    STA dig4
    LDA playerPos
    SUB one
    STA playerPos
    JMP mainLoop
;****checkCurrentDigit(move right)****

isKey5
    LDA keypad
    SUB key5
    JNE keyLoop

    LDA upOrDown
    SUB one
    JNE moveUp

    LDA down
    STA upOrDown
    JMP changeHeight
moveUp
    LDA one
    STA upOrDown

changeHeight
;****checkCurrentDigit(change height)****
    LDA staDig0 ;loads the instruction STA dig0
    ADD playerPos
    STA setHeight
    LDA upOrDown
setHeight
    STA dig0 ; this instruction gets overwritten with STA dig(playerPos)
    JMP mainLoop

; Old height code had 33 instruction. Now 6 (82% decrease)

;****checkCurrentDigit(change height)****


zero DEFW &0000
one DEFW &0001
two DEFW &0002
three DEFW &0003
five DEFW &0005
key4 DEFW &0010
key6 DEFW &0040
key5 DEFW &0020
playerPos DEFW &0000
down DEFW &0008
upOrDown DEFW &0001
staDig0 DEFW &1FF5


enemyPos DEFW &0000
enemyHeight DEFW &0001
enemyMoveCounter DEFW &0001
enemyPosSub DEFW &0000
enemyPosAdd DEFW &0000
tempDistAdd DEFW &0000
tempDistSub DEFW &0000
nextEnemyPos DEFW &0000
nextEnemyHeight DEFW &0000

delay DEFW &FFFF

;to generate enemyPos
seed DEFW &0000
mostSig DEFW &8000

;characters
s DEFW $00ED
t DEFW $1201
a DEFW $00F7
r DEFW $20F3
w DEFW $123E 
i DEFW $1209
n DEFW $2136

;sounds
sound1 DEFW &8240
sound2 DEFW &8645
    
ORG &FF1
buttons DEFW &0000
keypad DEFW &0000

ORG &FF5
dig0 DEFW &0000
dig1 DEFW &0000
dig2 DEFW &0000
dig3 DEFW &0000
dig4 DEFW &0000
dig5 DEFW &0000

ORG &FFD
buzzer DEFW &0000