chars4	DCD		' ', 'H', 'i', 'n', 't', 'o', 'n',  44, ' ', 'a', 'n'
chars5	DCD		'd', ' ', 'L', 'e', 'C', 'u', 'n', 'n', ' ', 'f', 'o'
chars6	DCD		'r', ' ', 't', 'h', 'e', 'i', 'r', ' ', 'w', 'o', 'r'
chars7	DCD		'k', ' ', 'o', 'n', ' ', 'n', 'e', 'u', 'r', 'a', 'l'
chars8	DCD		'n', 'e', 't', 'w', 'o', 'r', 'k', 's', '.'
count	DCD		97
string	FILL		200
		
		ADR		r1, string
		ADR		r2, count
		LDR		r2, [r2]
		ADR		r0, chars0
		B		run
loop
		LDR		r3, [r0], #4
		STR		r3, [r1], #4
		SUB		r2, r2, #1
		CMP		r2, #0
		BGT		loop
		MOV		r3, #0
		STR		r3, [r0]
		MOV		r0, #0
		B		main
run
		BL		loop
		END
