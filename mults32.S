		;		ARM Programming Assignment #2: 32 bit signed integer multiplier
		;
		;		Write a 32-bit SIGNED multiplier. It should take only a small modification to your
		;       unsigned version. Remember (-6)*(-6) = 36, (-6)*6 = -36.
		;		Use the standard shift-and-add operation.
		;		Use the two numbers as an example but write it so it works for any two 16-bit numbers.
		;		Write the result in the provided "fill" word.
		;		Indicate if there was a high-bit carry using the provided "fill" word.

numbers	DCD		0xA0BCFF0D, 0xFFF0ADEA
result	FILL		8
carry	FILL		4
		
		ADR		r0, numbers		
		LDR		r3, [r0], #4		
		LDR		r5, [r0]			
		ADR		r0, result		
		MOV		r6, #0			
		
		MOVS		r1, r3, LSR #31	
		MVNNE		r3, r3			
		ADDNE		r3, r3, #1		
		ADDNE		r6, r6, #1		
		
		MOVS		r1, r5, LSR #31	
		MVNNE		r5, r5			
		ADDNE		r5, r5, #1		
		ADDNE		r6, r6, #1		
		
		
		MOV		r2, r3, LSR #16	
		BIC		r3, r3, r2, LSL #16 
		
		MOV		r4, r5, LSR #16	
		BIC		r5, r5, r4, LSL #16	
		
		
		MOV		r8, r2			
		MOV		r9, r4			
		BL		mul				
		MOV		r1, r10			
		
		MOV		r8, r2			
		MOV		r9, r5			
		BL		mul				
		MOV		r2, r10			
		
		MOV		r8, r3			
		MOV		r9, r4			
		BL		mul				
		MOV		r4, r10			
		
		MOV		r8, r3			
		MOV		r9, r5			
		BL		mul				
		MOV		r3, r10			
		
		ADDS		r2, r2, r4		
		ADDCS		r1, r1, #0x10000	
		ADDS		r3, r3, r2, LSL #16	
		ADC		r1, r1, r2, LSR #16	
		CMP		r6, #1			
		MVNEQ		r1, r1			
		MVNEQ		r3, r3			
		ADDEQ		r3, r3, #1
		STR		r3, [r0], #4		
		STR		r1, [r0]			
		ADR		r0, carry
		MOVCC		r2, #0
		MOVCS		r2, #1
		STR		r2, [r0]
		END
		
		
mul		MOV		r10, #0		
		
loop		MOVS		r9, r9, lsr #1	
		ADDCS		r10, r10, r8	
		MOV		r8, r8, lsl #1	
		CMP		r9, #1
		BGT		loop			
		
		MOVS		r9, r9, lsr #1	
		ADDCS		r10, r10, r8	
		MOV		pc, lr		
		

