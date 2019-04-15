			;		ArM Programming Assignment #2: 64 bit signed integer multiplier
			;
			;		Write a 64-bit SIGNED multiplier. It should take only a small modification to your
			;		unsigned version. remember (-6)*(-6) = 36,  (-6)*6 = -36.
			;		Use the standard shift-and-add operation.
			;		Use the two numbers as an example but write it so it works for any two 16-bit numbers.
			;		Note that in VisUAL you cannot store 64-bit values (double words) directly. The upper
			;		and lower words are your higher 32 bits and lower 32 bits of the two numbers,
			;		respectively.
			;		Write the result in the provided "fill" word.
			;		Indicate if there was a high-bit carry using the provided "fill" word.
			
upper		DCD		0xFFFFFFFF,  0x00000000
lower		DCD		0xFFFFFFFB,  0x82481248
rwidth		EQU		32
result		FILL		16
carry		FILL		4
			
			ADR		r0, upper
			LDR		r1, [r0], #4
			LDR		r3, [r0], #4
			LDR		r2, [r0], #4
			LDR		r4, [r0]
			MOV		r5, #0
			CMP		r1, #0
			MOVLT		r5, #1
			MVNLT		r1, r1
			MVNLT		r2, r2
			ADDSLT		r2, r2, #1
			BGE		skip
			ADDCS		r1, r1, #1
			END
			
bit
			CMP		r2, #rwidth
			BEQ		MRe
			LSLS		r1, r1, #1
			ADDCC		r2, r2, #1
			BCC		bit
			
MRe
			RSBS		r2, r2, #rwidth
			MOV		r0, r2
			LDMIA		SP!, {Lr}
			MOV		PC, Lr
			
mul
			LDMIA		SP!, {r0, r1, r2, r3}
			STMDB		SP!, {r4, r5, r6, r7, r8, r9, r10, Lr}
			MOV		r4, #1
			MOV		r5, #-1
			MOV		r6, #0
			MOV		r7, #0
			MOV		r8, #0
			MOV		r9, #0
			STMDB		SP!,  {r0, r1, r2, r3}
			STMDB		SP!,  {r3}
			LDMIA		SP!, {r0}
			STMDB		SP!, {Lr}
			MOV		r1, r0
			MOV		r2, #0
			MOV		r9, r0
			LDMIA		SP!, {r0, r1, r2, r3}
			
loop
			ADD		r5, r5, #1
			CMP		r5, #rwidth
			BGE		excupper
			TST		r1, r4, lsl r5
			BEQ		loop
			ADD		r10, r5, r9
			CMP		r10, #rwidth
			BLT		exclower
			SUB		r10, r10, #rwidth
			MOV		r10, r4, lsl r10
			SUB		r8, r10, #1
			MOV		r10, r5
			RSB		r10, r10, #rwidth
			LSL		r8, r8, r10
			AND		r8, r8, r3
			LSR		r8, r8, r10
			ADD		r7, r7, r8
			
exclower
			ADD		r6, r6, r3,  lsl r5
			ADD		r7, r7, r2,  lsl r5
			ADRCS		r10, carry
			STRCS		r4, [r10]
			MOV		r8, #0
			BAL		loop
			
excupper
			CMP		r5, #64
			BEQ		return
			SUB		r9, r5, #rwidth
			TST		r0, r4, lsl r9
			BEQ		loop
			ADD		r7, r7, r3, lsl r9
			ADRCS		r10, carry
			STRCS		r4, [r10]
			CMP		r2, #0
			ADRNE		r10, carry
			STRNE		r4, [r10]
			BL		loop
			
return
			MOV		r0, r7
			MOV		r1, r6
			LDMIA		SP!, {r4, r5, r6, r7, r8, r9, r10, Lr}
			MOV		PC, Lr
			
skip
			CMP		r3, #0
			EORLT		r5, r5, #1
			MVNLT		r3, r3
			MVNLT		r4, r4
			ADDSLT		r4, r4, #1
			BGE		cont
			ADDCS		r3, r3, #1
			
cont
			STMDB		SP!, {r1, r2, r3, r4}
			BL		mul
			ADr		r2, result
			
			CMP		r5, #1
			MVNEQ		r0, r0
			MVNEQ		r1, r1
			ADDSEQ		r1, r1, #1
			BGE		will_t
			ADDCS		r0, r0, #1
			
will_t
			STR		r0, [r2], #4
			STR		r1, [r2]
			
			
