		.data
		.equ POLINOMIO, 0x82608edb #Polinômio sem o LSB, que sempre é 1
		.equ ENTRADA, 0x61 #Entrada
		.equ UM_BIT, 2147483648 #10000000000000000000000000000000, para utilização no algoritmo
		
		.global main
		.text
main:		movia r1, POLINOMIO 
		movia r9, POLINOMIO
		
		movia r2, ENTRADA
		movia r3, ENTRADA
		
		movia r11, UM_BIT
		movia r23, UM_BIT

		
busca_0:	and r5, r11, r3 #AND utilizado para verificar se há 0 nas primeiras posições da entrada
		beq r5, r0, achou_0 #Caso seja encontrado um 0
		call ajusta_pt2_polinomio #Inicia o ajuste da segunda parte do polinômio

achou_0:	srli r9, r9, 1 #Realiza um shift com a primeira parte do polinômio, encaminhando-a para a direita
		roli r11, r11, 31 #Move UM_BIT para a direita, para que o próximo bit mais significativo da entrada possa ser checado
		addi r22, r22, 1 #Contador para armazenar o total de movimentos à direita para o polinômio
		call loop_busca_0 
		
loop_busca_0: 	call busca_0 #Reinicia a busca por 0 no inicio do polinômio

ajusta_pt2_polinomio: 	mov r10, r1
			movia r21, 32 
			call ajusta_bits_movidos
			call add_1_no_fim
			mov r20, r0 
			call realizar_operacao
			
ajusta_bits_movidos:	sub r20, r21, r22 #Calcula o quanto o polinômio precisa ser movido para à esquerda
			sll r10, r1, r20 #Realiza shift à esquerda no polinômio
			ret
			
add_1_no_fim:		movia r23, UM_BIT
			rol r23, r23, r20 #Move o bit único para a esquerda e o adiciona na posição correta
			or r10, r10, r23 #Realiza OR para que o BIT seja posicionado ao final do polinômio
			ret

realizar_operacao:	xor r3, r3, r9 #Realiza XOR com a primeira parte do polinômio
			xor r4, r4, r10 #Realiza XOR com a segunda parte do polinômio (Resultado do CRC)
			bne r3, r0, busca_0 #Refaz o processo até que a entrada esteja zerada
