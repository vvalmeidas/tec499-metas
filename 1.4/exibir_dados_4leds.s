		.data
		.equ LED_END, 0x810
		.equ BOTÃO_END, 0x840
		
		.global main
		.text
main:		movia r12, LED_END
		movia r14, BOTÃO_END
		movi r5, 500 #Contador para delay
		movi r6, 1
		movia r7, 0b10101011111010001010101111101000 #Entrada a ser exibida
		movi r8, 4

checando_botao:		ldb r9, 0(r14)
			beq r9, r6, delay
			br checando_botao

delay:		subi r5, r5, 1
		bne r5, r0, delay
		call exibe_dados

exibe_dados:	stb r7, 0(r12)
		ror r7, r7, r8 #Move os últimos 4 bits para direita
		movi r5, 500 #Reinicia contador do delay
		call checando_botao
		


