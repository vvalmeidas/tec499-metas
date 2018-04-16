.data
tabela: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
entrada: .ascii "babababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababa"

.global main
.text
main: movia r1, 0x814141AB #Polinômio
movia r2, 0x80000000 #Máscara para verificar o primeiro bit da entrada
movia r3, tabela #Move o endereço base da tabela para r3
movia r4, 0 #Primeira entrada
movia r6, 256 #Valor máximo da entrada para o polinômio
movi r22, 1
call define_proximo_valor_calculo_crc

define_proximo_valor_calculo_crc:	mov r5, r4 #Move a entrada para r5
					slli r5, r5, 24
					call calcula_crc_para_valor

calcula_crc_para_valor:	movi r20, 8
			call loop_crc_para_entrada

loop_crc_para_entrada: 	beq r20, r0, final_crc_para_valor
			and r19, r2, r5
			bne r19, r0, realiza_xor
			slli r5, r5, 1
			subi r20, r20, 1
			call loop_crc_para_entrada

realiza_xor:	slli r5, r5, 1
		xor r5, r5, r1
		subi r20, r20, 1
		call loop_crc_para_entrada


final_crc_para_valor: 	stw r5, 0(r3)
			addi r3, r3, 4
			addi r4, r4, 1
			bne r4, r6, define_proximo_valor_calculo_crc
			call iniciar_registradores

iniciar_registradores:	mov r1, r0 #Resultado do CRC
			movia r3, 0xff000000 #Mascara para ignorar 24 últimos 0s
			movi r4, 4 #Quantidades de iterações, ou seja, quantidade de bytes que serão selecionados
			mov r5, r2 #Realiza copia da entrada
			mov r6, r0
			movia r7, tabela #Primeiro endereço da tabela	
			movi r19, 0
			movia r20, 0
			mov r22, r0
			movia r10, entrada #Endereço base da entrada
			mov r11, r0 #Contador de quantas sequências de 32 bits já foram obtidas da memória e calculadas
			movi r14, 250
			call prepara_proxima_sequencia_32bits

prepara_proxima_sequencia_32bits:	beq r11, r14, fim
					muli r12, r11, 4 #Offset para próximo endereço de memória
					add r12, r12, r10 #Adiciona endereço base da entrada ao offset
					ldw r13, 0(r12) #Obtém a próxima entrada de 32 bits
					movi r4, 4
					call calculo_crc_para_32_bits
			
calculo_crc_para_32_bits:	beq r4, r0, finaliza_calculo_para_32bits
				and r6, r13, r3 #Obtém byte mais significativo
				xor r6, r6, r1 #Obtém a posição
				srli r6, r6, 24
				
				muli r6, r6, 4 #Posição com 4s necessários
				add r6, r6, r7 #Posição relativa + base (final)
				ldw r9, 0(r6) #Carrega valor pré-calculado no registrador
				ldw r21, 0(r6)
				
				slli r1, r1, 8
				xor r1, r1, r9
				subi r4, r4, 1
				slli r13, r13, 8 #Desloca primeiro byte para fora do registrador, adicionando 0s no final
				call calculo_crc_para_32_bits

finaliza_calculo_para_32bits:	addi r11, r11, 1
				call prepara_proxima_sequencia_32bits	

fim:
				

		
		
