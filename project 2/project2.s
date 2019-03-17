ldr r0,=textfile    @load in the file named textfile defined in the bottom
mov r1,#0   @put it in input mode

swi 0x66    @Open file
bcs FileMissing @In case of a missing file it branches and reports a missing file

ldr r1,=MyString @ loads mystring into r1
mov r2, #4000   @ skips 4000 bytes just in case you want to put an entire essay in there


mov r9,r0   @ moves the read file handle and saves it in r9

swi 0x6a    @ reads a String from a file
bcs FileEmpty   @If the file is empty it branches to FileEmpty and reports file is empty

@ checks to see if the letters are already uppercase or vowels. If they're lowercase then make them uppercase and if they're vowels then loop back again
CheckUppercase:

    msr CPSR_f, #0x00000000
    ldrb r3, [r1]
    cmp r3, #0 @ checking to see if we have finished reading the file
        beq OutputToFile    @if we are equal then branch to the Output

            @ Checks it for vowels in case the character is already capital
            cmp r3, #65 @checks for A
                moveq r3, #42   @replace the vowel with *
            
            cmp r3, #69 @checks for E
                moveq r3, #42   @replace the vowel with *

            cmp r3, #73 @Checks for I
                moveq r3, #42   @replace the vowel with *


            cmp r3, #79 @Checks for O
                moveq r3, #42   @replace the vowel with *


            cmp r3, #85 @Checks for U
                moveq r3, #42   @replace the vowel with *

                    strb r3, [r1]

    cmp r3, #96 @ begining of the first lower case letter
        addlt r1, r1, #1    @increments 

        blt CheckUppercase  @if its less than 

     cmpGt r3, #123 
         sublt r3, r3, #32  @if its less than 123 then we are in lower case letters and we subtract 32 to make it uppercase


            cmp r3, #65 @checks for A
                moveq r3, #42   @replace the vowel with *
            
            cmp r3, #69 @checks for E
                moveq r3, #42   @replace the vowel with *

            cmp r3, #73 @Checks for I
                moveq r3, #42   @replace the vowel with *


            cmp r3, #79 @Checks for O
                moveq r3, #42   @replace the vowel with *


            cmp r3, #85 @Checks for U
                moveq r3, #42   @replace the vowel with *


         strb r3, [r1]

    add r1, r1, #1  @increments 
    b CheckUppercase    @branches back up to check uppercase



@If the file is missing this branch is executed and reports the file is missing then goes to done branch
FileMissing:
    mov r0,#1
    ldr r1,=MissingFile
    swi 0x69

    b Done

@If the file is empty this branch is executed and it reports the file is empty and then goes to done branch
FileEmpty:
    mov r0,#1
    ldr r1,=EmptyFile
    swi 0x69
    
    b Done




@outputs from memory to a file
OutputToFile:
    ldr r0,=OutFileName @ set Name for output file
    mov r1,#1 @ mode is output
    swi 0x66 @ open file for output
    ldr r1,=MyString    @puts my string in and gets ready to print it
    swi 0x69 @Write String to a File



@Branch of Done that will run at the end
Done:
    swi 0x68	@ close output file thats already open with r0
    mov r0,r9   @move the file handle back for the file that was opened to read from to r0
    swi 0x68	@ close the read file
    swi 0x11    @ends program




.data
textfile: .ASCIZ "input.txt"

OutFileName: .asciz "output.txt"
NL: .ASCIZ "\n"
MissingFile: .ASCIZ "The File is missing"
EmptyFile: .ASCIZ "The File is Empty"

MyString: .skip 4001
MyFileHandle: .skip 4
.align
OutFileHandle:.skip 4001