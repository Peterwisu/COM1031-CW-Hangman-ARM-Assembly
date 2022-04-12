/* This is a HANGMAN GAME created by Wish Suharitdamrong  for COM1031 Computer Logic CourseWork 2020/21 University of Surrey*/



	invalidinput: 			//method to display a prompt to tell player that theirs input is in wrong format on a terminal and go back to loop game and let player type input again
	push {r0}
	ldr r0, =wronginputformat	//load a prompt for invalid input format to r0
	bl puts				//print a prompt to a terminal
	pop {r0}
	b loopgame			//go back to loopgame

	formatcheck1:			//This function will validate a player input whether its ascii number is in valid range or not
	cmp r2, #123			//compare player input with 123
	blge invalidinput		//if input is greater than equal to 123 call function invalidinput because ascii number after 122 is not a character a-z
	cmp r2, #64			//compare player input with 64
	ble invalidinput		//if input is less than equal to 64 call function invalidinput because ascii number before 64 is not a character A-Z 
	bx lr
	formatcheck2:			/*this function will be call after subtract a input whihc are greater than 64 by 32 for converting to Uppercase letters for validate a ascii number
					 *between 91 to 96 which are neither A-Z or a-z */
	cmp r2, #91			//compare r2 with 91
	blge invalidinput		//if r2 is greater or equal to 91 call function invalidinput
	bx lr

	alreadyprompt:			//This method will display a prompt on terminal to tell player that they already guessed this letter.
	push {r0}
	ldr r0, =sameinput		//load a prompt for a already guessed letter to r0.
	bl puts				//print a prompt to a terminal.
	pop {r0}
	b loopgame			//go back to loop game


	print_guess:			//This method will display a Hangman graphic on a terminal according to a chances left for a player to guess
	push {r0, lr}
	cmp r4, #0
	ldreq r0, =zeroguess		/*This method will compare a counter of wrong guess of a user to a number 0-6 respectively */
	cmp r4, #1
	ldreq r0, =oneguess		/** If player have no wrong guess the counter still remain 0 and keep on display graphic for 0 missed guess unless the counter value change*/
	cmp r4, #2
	ldreq r0, =twoguess
	cmp r4, #3
	ldreq r0, =threeguess
	cmp r4, #4
	ldreq r0, =fourguess
	cmp r4, #5
	ldreq r0, =fiveguess
	cmp r4, #6
	ldreq r0, =sixguess
	bl puts				//Print a Hangman graphic to a terminal.
	pop  {r0, lr}
	bx lr


	correct:			//method to display a prompt to tell player that their input is correct
	push {r0, lr}
	ldr r0, =correctword		//load a correct word prompt to r0
	bl puts				//Print the prompt to a terminal
	pop {r0, lr}
	bx lr


	wrong:				//method to display a prompt to tell player that their input is wrong
	push {r0, lr}
	ldr r0, =wrongword		//load a wrong word prompt to a r0
	bl puts				//Print a prompt to a terminal
	pop {r0, lr}
	bx lr


	Quit:				//Quit  method will display a prompt and exit the game
	push {r0, lr}
	ldr r0, =bye			//load a bye prompt to r0
	bl puts				//print a prompt to a terminal
	bl exit				//exit a game
	pop {r0, lr}
	bx lr


	losemessage:			//This function will be call when players have take more than 6 chance to guess a word and  lost the game to display a loser message
	push {r0, lr}
	ldr r0, =losegraphic
	bl printf
	ldr r0, =loseprompt		//load a loser prompt to r0
	bl puts				//print a message to a terminal
	pop {r0, lr}
	bx lr


	winmessage:			//This function will be call when players take less than 6 chance to guess a word and win the game  to display a win message
	push {r0, lr}
	ldr r0, =wingraphic
	bl printf
	ldr r0, =winprompt		//load a win prompt to r0
	bl puts				//Print a message to a terminal
	pop {r0, lr}
	bx lr


	dashprint:			//This method will print a dash to a terminal according to a correct a player have guess the number of dash is a length of a secret word"
	push {r0, lr}
	/******

	r8 is a counter of letter 'T' if r8 is 0 means player haven't guess 'T' yet
	r9 is a counter of letter 'E' if r9 is 0 means player haven't guess 'E' yet
	r10 is a counter of letter 'S' if r10 is 0 means player haven't guess 'S' yet

	*****/
	cmp r8, #0			//compare r8 which is a counter of letter T to 0
	cmpeq r9, #0			//if equal next compare r9 a counter of E to 0
	cmpeq r10, #0			//if equal next compare r10 a counter of S to 0
	ldreq r0, =dash			//if equal mean players haven't guess any correct letter yet ,So load r0 to dash which will display "Secret word: -----" 

	cmp r8, #1			//compare r8 to 1
	ldreq r0, =dashT		//if equal means player have guess correct letter 'T' load dashT to r0 which contain ascii value "Secret word: T--T-"

	cmp r9, #1			//compare r9 to 1
	ldreq r0, =dashE		//if equal means player have guess correct letter 'E' load dashE to r0 which contain ascii value "Secret word: -E---"

	cmp r10, #1			//compare r10 to 1
	ldreq r0, =dashS		//if equal means player have guess correct letter 'S' load dashS to r0 which contain ascii value "Secret word: --S-S"

	/*
	If player have guess correct more than two letter ,r0 which loaded from 3 condition statement above for single letter will be replaced by next three condition statement
	*/
	cmp r8, #1			//compare r8 to 1
	cmpeq r9, #1			//if equal compare r9 to 1
	ldreq r0, =dashTE		//if equal mean player have guess two correct letters which are 'T' and 'E' ,So load dashTE to r0  contain ascii value "Secret word: TE-T-"

	cmp r8, #1			//compare r8 to 1
	cmpeq r10, #1			//if equal compare r10 to 1
	ldreq r0, =dashTS		//If equal mean player have guess two correct letters which are 'T' and 'S' ,So load dashTS to r0 contain ascii value "Secret word: T-STS"

	cmp r9, #1			//compare r9 to 1
	cmpeq r10, #1			//If equal compare r10 to 1
	ldreq r0, =dashES		//If equal mean player have guess two correct letters which are 'E' and 'S' ,So load dashES to r0 contain ascii value "Secret word: -ES-S"


	bl printf			//print a value in r0
	pop {r0, lr}
	bx lr

	game:
	push {r0-r6, lr}
	mov r4, #0			//Set r4 as 0 for a counter of wrong guess
	mov r5, #0			//Set r5 as 0 for a counter of correct guess
	mov r6, #0			//Set r6 as 0 for a counter to exit a loopgame
	mov r8, #0			//counter of letter T
	mov r9, #0			//counter of letter E
	mov r10, #0			//counter of letter S

		loopgame:
		push {r0, r1}
		bl dashprint		//call function dashprint to print a dash for a secret word
		bl print_guess		//Call function print guess to display Hangman Graphic according to value in r4
 		ldr r0, =secondprompt	//load prompt to tell player to guess a letters
		bl puts			//Print prompt in the terminal
		ldr r1, =guess
		ldr r0, =inputformatchar
		bl scanf		//Scanf a player input from the terminal
		ldr r1, =guess
		ldr r2, [r1]
		pop {r0, r1}
		cmp r2, #'0'		//compare player input with 0(zero)
		bleq Quit		//if player input is equal to 0 then call function Quit to exit the game

		bl formatcheck1		//call a method formatcheck1 to validate player input

		cmp r2, #97		//compare player input with 97
		subge r2, r2, #32	//if player input is greater than equal to 97 means a character is in Lowercase letters ,Substract it by 32 to convert letters to Uppercase letters

		bl formatcheck2		//call a method formatcheck2 to validate the player after convert to Uppercase 

		mov r3, #0		//Set r3 to 0as a counter to indicate that if the input match one of character in a word r3 will be increase by 1 if not remain 0

		cmp r2, #'T'		//compare input with letter T
		addeq r8, r8, #1	//if the input is T increase r8 by 1
		addeq r3, r3, #1	//if the input is T increase r3 by 1
		cmp r8, #2		//compare r8 with 2
		moveq r8, #1		/*if r8 equal to 2 set r8 as 1 because next loop if the player input different character and r8 is still 2
					 the program will automatically cal function alreadypropmt*/ 
		bleq alreadyprompt	//if r8 equal to 2 then call function alreadyprompt

		cmp r2, #'E'		//same  as letter T
		addeq r9, r9, #1
		addeq r3, r3, #1
		cmp r9, #2
		moveq r9, #1
		bleq alreadyprompt

		cmp r2, #'S'		//same as letter T
		addeq r10, r10, #1
		addeq r3, r3, #1
		cmp r10, #2
		moveq r10, #1
		blge alreadyprompt



		cmp r3, #1		//compare r3 to 1
		addeq r5, r5, #1	//if r3 equal to 1 the guess word is correct ,increase r5 by 1
		bleq correct		//call function correct to display prompt
		addne r4, r4 , #1	//if r3 not equal to 1 the guess word is wrong, increase r4 by 1
		blne wrong		//call function wrong to display prompt


		cmp r5, #3		//compare r5 to 3 ,if r5 equal to 3 means player have guess all the letter correct
		bleq winmessage		//if equal call function winmessage
		addeq r6, r6, #1	//if equal increase r6 by 1 to exit the loop
		cmp r4, #6		//compare r4 to 6 ,if r4 eqaul to 6 means player have use all a chance for a guess
		bleq losemessage	//if equal call function losemessage
		addeq r6, r6, #1	//if equal increase r6 by 1 to exit the loop
		cmp r6, #1		//compare r6 to 1
		bne loopgame		//if 6 not equal to 1 keep on looping in loopgame

	cmp r4, #6 			//compare r4 to 6
	bleq print_guess		//if equal call print_guess to display Hangman graphic
	push {r0}
	ldr r0, =thewordwas		//load the prompt to r0
	bl puts				//print a prompt to terminal
	ldr r0, =word			//load a secret word to r0
	bl puts				//print a secret word to terminal
	pop {r0}
	pop {r0-r6, lr}
	bx lr

	play:				//This function will start a game and when game finished allow player to choose to exit or play a game again
	bl game				//call a function game to let player play a game
	ldr r0, =restartprompt		//load restartprompt to r0
	bl printf			//print restart prompt to terminal to tell player to decide whether to quit a game or play again
	push {r0, r1, r2, lr}
	ldr r1, =input
	ldr r0, =inputformatdecimal
	bl scanf			//scan a player input decision
	ldr r1, =input
	ldr r2, [r1]
	cmp r2, #0			//compare player input decision with 0
	bleq Quit			//if player decision is equal to 0 call function Quit to exit the game
	bne play			//if not equal to 0 keep on looping
	pop  {r0, r1, r2, lr}
	bx lr



/* Main method of  a program the program will execute this method first*/

	.global main
	main:
	ldr r0, =graphic
	bl printf
	ldr r0, =welcome		//Display a welcome prompt in the terminal
	bl printf
	push {r0, r1, r2, lr}

	ldr r0, =firstprompt		//Display a prompt to let player decide whether to enter the game or exit in the terminal
	bl puts
	ldr r1, =input
	ldr r0, =inputformatdecimal
	bl scanf			//scan a user input from terminal
	ldr r1, =input
	ldr r2 , [r1]

	cmp r2, #0			//compare player input with 0
	bleq Quit			//if equal to 0 call function Quit to exit the game
	cmp r2, #1			//compare player input with 1
	bleq play			//if user input is equal to 1 call function play to play the game
	pop {r0, r1, r2, lr}
	mov r7, #1
	svc 0



	.data
	graphic:	.asciz "     __   __  _______  __    _  _______  __   __  _______  __    _       \n    |  | |  ||   _   ||  |  | ||       ||  |_|  ||   _   ||  |  | |      \n    |  |_|  ||  |_|  ||   |_| ||    ___||       ||  |_|  ||   |_| |      \n    |       ||       ||       ||   | __ |       ||       ||       |      \n    |       ||       ||  _    ||   ||  ||       ||       ||  _    |      \n    |   _   ||   _   || | |   ||   |_| || ||_|| ||   _   || | |   |      \n    |__| |__||__| |__||_|  |__||_______||_|   |_||__| |__||_|  |__|\n"      
	losegraphic:    .asciz "      __         _________     ________     ________  \n     |  |       |   ___   |   |  _____|    |   _____| \n     |  |       |  |   |  |   |  |_____    |   |____  \n     |  |       |  |   |  |   |____   |    |   _____| \n     |  |__     |  |___|  |    ____|  |    |   |____  \n     |_____|    |_________|   |_______|    |________| \n\n" 	
	wingraphic:     .asciz "      __    __    __       ___      ___    __  \n     |  |  |  |  |  |     |   |    |   |  |  | \n     |  |  |  |  |  |     |   |    |    |_|  | \n     |  |  |  |  |  |     |   |    |         | \n     |  |__|  |__|  |     |   |    |   __    | \n     |     ____     |     |   |    |  |  |   | \n     |____/    \\____|     |___|    |__|   |__| \n\n"
	welcome:	.asciz "\n\n  Welcome to HANGMAN GAME\n   created by Wish Suharitdamrong\n\n"
	bye: 		.asciz "\nYou have exit a game\n"
	firstprompt:    .asciz "\nEnter 1 to start the game  or 0(zero) to exit the game\n"
	secondprompt:   .asciz "\nGuess any character(A-Z) or Enter 0(zero) to quit a game\n"
	winprompt:   	.asciz "\nCongratulation!!!!!! You win the game!!!!\n"
	loseprompt: 	.asciz "\nYou lose the game\n"
	thewordwas:	.asciz "\nThe word was: \n"
	restartprompt:  .asciz "\n\nEnter 1 to play again or 0 zero to Exit\n"
	wronginputformat: .asciz "\n\nInvalid input type please Enter any character(A-Z) or Enter 0(zero) to quit a game \n"
	inputformatdecimal: .asciz "%d"
	inputformatchar: .asciz "%s"
	dash:		.asciz "\n         Secret word: -----\n\n"
	dashT:		.asciz "\n	   Secret word: T--T-\n\n"
	dashS:		.asciz "\n	   Secret word: --S-S\n\n"
	dashE:		.asciz "\n         Secret word: -E---\n\n"
	dashTS:		.asciz "\n         Secret word: T-STS\n\n"
	dashTE:		.asciz "\n	   Secret word: TE-T-\n\n"
	dashES:		.asciz "\n	   Secret word: -ES-S\n\n"
	zeroguess: .asciz "  |-------|\n  |       |\n          |\n          |\n          |\n          |\n  ________|\n"
	oneguess:  .asciz "  |-------|\n  |       |\n  O       |\n          |\n          |\n          |\n  ________|\n"
	twoguess:  .asciz "  |-------|\n  |       |\n  O       |\n  |       |\n  |       |\n          |\n  ________|\n"
	threeguess:.asciz "  |-------|\n  |       |\n  O       |\n \\|       |\n  |       |\n          |\n  ________|\n"
	fourguess: .asciz "  |-------|\n  |       |\n  O       |\n \\|/      |\n  |       |\n          |\n  ________|\n"
	fiveguess: .asciz "  |-------|\n  |       |\n  O       |\n \\|/      |\n  |       |\n /        |\n  ________|\n"
	sixguess:  .asciz "  |-------|\n  |       |\n  O       |\n \\|/      |\n  |       |\n / \\      |\n  ________|\n"
	wrongword: .asciz "\n Wrong character\n"
	correctword: .asciz "\n Correct Character\n"
	sameinput: .asciz "\nthis word already been guess\n"
	
	.align 2
	input:	.word 0
	guess: .word 0
	word: .asciz "TESTS"	
