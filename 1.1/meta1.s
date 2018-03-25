######################################
# Xor, if e laço de repetição em Assembly
# Autor: Valmir Vinicius de Almeida Santos
######################################

		.global main
		.text
main:		movia r1, 1 #move o valor 1 para o registrador r1
		movia r2, 1 #move o valor 1 para o registrador r2
		beq r1, r2, verdadeiro #transfere o fluxo para verdadeiro, caso os valores de r1 e r2 sejam iguais
		br falso #transfere o fluxo para falso
		
verdadeiro:	movia r3, 1 
		movia r4, 0
		call continua #transfere o fluxo para continua
		
falso:		movia r3, 1 
		movia r4, 1

continua:	xor r5, r4, r3 #realiza a operação xor entre os valores armazenados nos registradores r4 e r3
		movia r6, 5 #move o valor 5 para o registrador r6, esse registrador será decrementado durante o loop abaixo
		
loop:		beq r0, r6, parar #transfere o fluxo de execução para parar, caso r6 contenha o mesmo valor de r0 (que sempre possui o valor 0)
		subi r6, r6, 1 #subtrai 1 de r6
		br loop #transfere o fluxo de execução para o inicio do loop
		
parar:		
