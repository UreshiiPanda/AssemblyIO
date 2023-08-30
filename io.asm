

; Author:  Joseph Houghton
; Last Modified:  3/11/2023
; email address:   jojohoughton22@gmail.com
; Description:   reads strings of digits from user and displays the numbers, their sum, and their average


INCLUDE Irvine32.inc


mGetString MACRO    get_string:REQ,  input_str:REQ,  input_str_len:REQ,  input_str_chars:REQ

	MOV		EDX, get_string								; print out the prompt
	Call	WriteString

	MOV		EDX, input_str								; get input number from user
	MOV		ECX, input_str_len
	Call	ReadString
	MOV		input_str_chars, EAX						; store the number of chars read from string
	MOV		ESI, EDX									; store the new string's address in ESI

ENDM


mDisplayString MACRO    print_str:REQ

	MOV		EDX, print_str								; print out the given string
	Call	WriteString

ENDM



.data


intro_1				BYTE	"Welcome to low-level IO procedures in Assembly. ", 13, 10, 0
intro_2				BYTE	"Written by: Joseph Houghton", 13, 10, 0
intro_3				BYTE	"Please provide 10 signed decimal integers.", 13, 10, 0
intro_4				BYTE	"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting", 13, 10, 0
intro_5				BYTE	"the raw numbers I will display a list of the integers, their sum, and their average value.", 13, 10, 0
outro				BYTE	"Thanks for playing  :)", 13, 10, 0
get_string			BYTE	"Please enter a signed number: ", 0
error_1				BYTE	"ERROR: You did not enter a signed number or your number was too big. ", 13, 10, 0
error_2				BYTE	"Please try again: ", 0
nums_prompt			BYTE	"You entered the following numbers: ", 13, 10, 0
sum_prompt			BYTE	"The sum of these numbers is: ", 0
avg_prompt			BYTE	"The truncated average is: ", 0
num_space			BYTE	", ", 0

input_str			DWORD		100		DUP(0)
print_str			DWORD		100		DUP(0) 
print_sum			DWORD		100		DUP(0)
print_avg			DWORD		100		DUP(0)
main_arr			DWORD		10		DUP(0)
input_str_len		DWORD		100
input_str_chars		DWORD		0
input_val			SDWORD		0




.code
main PROC

; introduction
	
	PUSH	OFFSET	intro_1									; push input parameters to the stack by reference
	PUSH	OFFSET	intro_2
	PUSH	OFFSET	intro_3
	PUSH	OFFSET	intro_4
	PUSH	OFFSET	intro_5
	Call	Introduction


; retrieve 10 integers from user

	MOV		ECX, 10
	MOV		EDI, OFFSET main_arr

_get_ten_integers:


; receive user input

	PUSH	OFFSET error_1
	PUSH	OFFSET error_2
	PUSH	OFFSET get_string
	PUSH	input_str_len									; pass string size by value
	PUSH	OFFSET input_str
	PUSH	OFFSET input_str_chars
	PUSH	OFFSET input_val
	Call	ReadVal


; store the value in an array

	CLD
	MOV		EBX, input_val
	MOV		[EDI], EBX

	ADD		EDI, 4

	LOOP	_get_ten_integers

	Call	CrLf


; display user input

	mDisplayString   OFFSET nums_prompt
	MOV		ECX, 10
	XOR		EAX, EAX										; clear EAX for sum accumulation
	MOV		EDI, OFFSET main_arr

_display_ten_integers:		

	CLD

	PUSH	OFFSET print_str
	XOR		EBX, EBX
	MOV		EBX, [EDI]
	PUSH	EBX												; pass user-input-value by value

	Call	WriteVal

	ADD		EAX, EBX										; EAX will hold the sum, EBX still holds curr value
	
	CMP		ECX, 1											; don't print a comma after the last number
	JE		_no_comma

	mDisplayString	 OFFSET num_space

_no_comma:

	
	ADD		EDI, 4
	LOOP	_display_ten_integers

	Call	CrLf
	Call	CrLf


; display sum 

	mDisplayString   OFFSET sum_prompt
	PUSH	OFFSET print_sum								; sum already in EAX, just display it 
	PUSH	EAX
	Call	WriteVal
	Call	CrLf


; display truncated avg

	mDisplayString   OFFSET avg_prompt
	MOV		EBX, 10											; divide sum by number of integers for avg
	CDQ
	IDIV	EBX

	PUSH	OFFSET print_avg								; avg is now in EAX, display it 
	PUSH	EAX
	Call	WriteVal

	Call	CrLf
	Call	CrLf

; outro
	
	PUSH	OFFSET outro
	Call	Goodbye

	Invoke ExitProcess,0									; exit to operating system
main ENDP


; ---------------------------------------------------------------------------------
; Name:  Introduction
;
; Description:  writes an introduction to the console
;
; Preconditions:  None
;
; Postconditions:  None
;
; Receives:  5 input parameters:  intro_1, intro_2, intro_3, intro_4, intro_5
;
; Returns:  prints to console
; ---------------------------------------------------------------------------------
Introduction PROC	USES EDX					; preserve EDX via PUSH, and POP it back off before RET

	PUSH	EBP									; preserve EBP
	MOV		EBP, ESP							; assign EBP as a static stack-frame pointer, by moving it to where ESP is

	mDisplayString   [EBP + 28]					;  use EBP pointer to access parameters via Base+Offest method	

	mDisplayString   [EBP + 24]

	Call	CrLf

	mDisplayString   [EBP + 20]

	mDisplayString   [EBP + 16]

	mDisplayString   [EBP + 12]

	Call	CrLf

	POP		EBP
	RET		20									; de-reference the parameters

Introduction ENDP


; ---------------------------------------------------------------------------------
; Name:  ReadVal
;
; Description:  takes in a string of digits, validates it, and stores it as a signed integer
;
; Preconditions:  mGetString MACRO is set up and it accepts a user-input number as a string
;
; Postconditions:  None
;
; Receives:   4 input parameters,  3 output parameters:  error_1, error_2, get_string, input_str_len   input_str, input_str_chars, input_val
;
; Returns:    a signed integer in input_val variable
; ---------------------------------------------------------------------------------
ReadVal PROC	USES EDI EAX EBX ESI ECX EDX		; preserve registers via PUSH, and POP them back off before RET
	
	PUSH	EBP										; preserve EBP
	MOV		EBP, ESP								; assign EBP as a static stack-frame pointer, by moving it to where ESP is


_get_new_str:
	mGetString    [EBP + 48],  [EBP + 40],  [EBP + 44],  [EBP + 36]
	JMP		_initial_check

_get_new_str_after_error:
	mGetString    [EBP + 52],  [EBP + 40],  [EBP + 44],  [EBP + 36]
	
_initial_check:
	MOV		ECX, [EBP + 36]							; loop over all chars in the input string
	CMP		ECX, 0									; if user entered nothing, print error and re-prompt user
	JE		_error		

	XOR		EBX, EBX								; clear EBX to accumulate digits into it for the output

	LODSB											; load first value of ESI into AL
	SUB		ESI, 1									; place ESI back at beginning, it will increment later

	CMP		AL, '+'									; check for plus or minus signs in the first char of the input string
	JE		_plus
	CMP		AL, '-'
	JE		_minus

	ADD		ESI, ECX								; read digits from the least-significant digit 
	SUB		ESI, 1									; take off 1 index for "0-indexing"
	MOV		EDI, 1									; set up EDI as a positive x10 multiplier

	JMP		_validator								; if there's no sign, just jump to number validation


_plus: 
	MOV		EDI, 1									; set up EDI as a positive x10 multiplier
	DEC		ECX										; we've already checked the first character
	ADD		ESI, ECX								; read digits from the least-significant digit 
	JMP		_validator


_minus:
	MOV		EDI, 1									; set up EDI as a positive x10 multiplier
	DEC		ECX										; we've already checked the first character
	ADD		ESI, ECX								; read digits from the least-significant digit 
	JMP		_neg_validator


_validator:
	STD
	XOR		EAX, EAX								; clear EAX before loading 
	LODSB											; load the next digit from ESI into AL
	Call	IsDigit									; make sure each index holds a digit
	JNZ		_error
	SUB		EAX, 48									; convert the ascii char to its number
	MOVZX	EAX, AL									; extend EAX in case value is already too big for a 32-bit register
	XOR		EDX, EDX
	MUL		EDI										; multiply by the multiplier to get the correct place-value
	JO		_error

	ADD		EBX, EAX								; EBX will be accumulating and storing the output value
	CMP		EBX, 0
	JL		_error									; handling overflows

	MOV		EAX, EDI
	MOV		EDI, 10
	MUL		EDI
	MOV		EDI, EAX								; multiply the multiplier by 10 to move to next place-value

	LOOP	_validator								; run validation loop for each digit in user-input string

	JMP		_end


_neg_validator:
	STD
	XOR		EAX, EAX								; clear EAX before loading 
	LODSB											; load the next digit from ESI into AL
	Call	IsDigit									; make sure each index holds a digit
	JNZ		_error
	SUB		EAX, 48									; convert the ascii char to its number
	MOVZX	EAX, AL									; extend EAX in case value is already too big for a 32-bit register
	XOR		EDX, EDX

	MUL		EDI										; multiply by the multiplier to get the correct place-value
	JO		_error

	NEG		EAX										; change EAX to negative for accumulating value of negative user input
	ADD		EBX, EAX								; EBX will be accumulating and storing the output value
	CMP		EBX, 0
	JG		_error									; handling overflows 

	MOV		EAX, EDI
	MOV		EDI, 10
	MUL		EDI
	MOV		EDI, EAX								; multiply the multiplier by 10 to move to next place-value

	LOOP	_neg_validator							; run validation loop for each digit in user-input string

	JMP		_end
	

_error:
	mDisplayString	  [EBP + 56]

	JMP		_get_new_str_after_error				; re-prompt the user without the opening prompt

_end:
	MOV		EDI, [EBP + 32]
	MOV		[EDI], EBX								; store the user-input-value into an output parameter

	POP		EBP
	RET		28										; de-reference the parameters

ReadVal ENDP


; ---------------------------------------------------------------------------------
; Name:  WriteVal
;
; Description:  takes in a signed value and writes it as its ascii representation to the console
;
; Preconditions:  mDisplayString has been set up, input_val has been obtained from user
;
; Postconditions:  None
;
; Receives:  1 input parameter,  1 output parameter:   input_val,  print_str
;
; Returns:  prints the input value as an ascii string to the console
; ---------------------------------------------------------------------------------
WriteVal PROC	USES EAX EBX ECX EDX ESI EDI		; preserve registers via PUSH, and POP them back off before RET
	LOCAL	counter:DWORD


	MOV		EAX, 0
	MOV		counter, EAX							; start counter at 0, this will be used only at the end
	 
	CLD
	MOV		EDI, [EBP + 12]							; point EDI to the output string
	XOR		EAX, EAX								; clear EAX to prepare for any size of input
	MOV		EAX, [EBP + 8]							; load input value into EAX
	CMP		EAX, 0
	JL		_neg_number
	MOV		ECX, 1									; set ECX to "true" for the positive input
	MOV		EBX, 10									; set up EBX as a /10 divider


_pos_number_loop:
	ADD		counter, 1
	XOR		EDX, EDX
	DIV		EBX

	MOV		ESI, EAX								; preserve the leftover quotient in ESI
	MOV		EAX, EDX								; move the remainder to AL
	STOSB											; store that remainder into EDI
	MOV		EAX, ESI								; put the quotient back in EAX for next loop iteration
	CMP		EAX, 0									; if quotient is 0, we have all of the digits in reverse in EDI, leave loop
	JE		_reverse_output
	JMP		_pos_number_loop
	

_neg_number:
	MOV		ECX, 0									; set ECX to "false" for the negative input
	MOV		EBX, 10									; set up EBX as a /10 divider
	NEG		EAX										; treat the negative value as a positive value
	JMP		_pos_number_loop				


_reverse_output:
	CMP		ECX, 0									; check if input was positive or negative
	JE		_reverse_output_neg

	SUB		EDI, 1									; move EDI back to the last element in the string
	MOV		ESI, [EBP + 12]							; set ESI at front of string, EDI is already at back of string
	CMP		ESI, EDI					
	JE		_last_digit								; in this case, there is only 1 digit, no reversal needed

	XOR		EAX, EAX
	XOR		EBX, EBX								; clear these registers for value-swapping 
	JMP		_reverse_output_loop


_reverse_output_neg:
	MOV		EAX, -3									; move the pre-conversion ascii value for "-" into output string
	STOSB											; place that "-" at the back of the current output string, before reversal

	SUB		EDI, 1									; move EDI back to the last element in the string
	MOV		ESI, [EBP + 12]							; set ESI at front of string, EDI is already at back of string
	CMP		ESI, EDI					
	JE		_last_digit								; in this case, there is only 1 digit, no reversal needed

	XOR		EAX, EAX
	XOR		EBX, EBX								; clear these registers for value-swapping 


_reverse_output_loop:								; reverse the output string in-place by swapping EDI and ESI values
	MOV		BL, [ESI]
	MOV		AL, [EDI]

	ADD		BL, 48									; convert the numbers to ascii
	ADD		AL, 48									; convert the numbers to ascii

	MOV		[ESI], AL								; swap values btw EDI and ESI
	MOV		[EDI], BL

	ADD		ESI, 1									; move ESI forward to next index
	CMP		ESI, EDI
	JE		_end									; if ESI and EDI have reached each other in middle then reversal is finished
	SUB		EDI, 1									; move EDI backward to previous index
	CMP		ESI, EDI
	JE		_last_digit								; in this case, if ESI and EDI have reached each other in middle then 1 digit remains
	JMP		_reverse_output_loop


_last_digit:										; in these cases, the total number of digits is odd, the middle digit only needs ascii conversion
	MOV		AL, [ESI]
	ADD		EAX, 48									; convert middle digit to ascii
	MOV		[ESI], AL


_end:
	mDisplayString   [EBP + 12]
	MOV		ECX, counter							; use local variable to clear the array

_clear_array:										; clear array to prepare for next value
	MOV		EAX, 0
	MOV		[ESI], AL
	MOV		[EDI], AL
	DEC		ESI 
	INC		EDI

	LOOP	_clear_array


	RET		8										; de-reference the parameters

WriteVal ENDP



; ---------------------------------------------------------------------------------
; Name:  Goodbye
;
; Description:  writes a goodbye message to the console
;
; Preconditions:  None
;
; Postconditions:  None
;
; Receives:  1 input parameter:  outro
;
; Returns:  prints to console
; ---------------------------------------------------------------------------------
Goodbye PROC	USES EDX						; preserve EDX via PUSH, and POP it back off before RET

	PUSH	EBP									; preserve EBP
	MOV		EBP, ESP							; assign EBP as a static stack-frame pointer

	mDisplayString   [EBP + 12]

	Call	CrLf

	POP		EBP
	RET		4									; de-reference the parameter

Goodbye ENDP


END main
