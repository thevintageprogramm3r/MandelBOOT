; theVintage Programm3r
; MandelBOOT.asm
; Programming a bootable sector that will produce a Mandelbrot Fractal
; VGA at 320x200x256
; Works on i386+

[org 0x7c00]
_start:

	; es = Beginning of video memory
	; di = Current pixel 0 <= di < 0xFA00
	; cx = Column (x)
	; dx = Row (y)
	; bx = Counter 
	; bl = Counter % 255 + 32 (final color)

	; Make data segment at 0
	xor 	ax, ax
	mov		ds, ax

	; Set video mode to 320x200x256 (video mode 0x13)
    mov     al, 0x13
    mov     ah, 0x00
    int     0x10

	push	0xA000
	pop		es		; Set extra segment to screen memory at 0xA000
	
	; Prepare the rest of the registers for use
	xor		di,di
	xor		si,si
	xor		al, al
	xor		cx, cx
	xor 	dx, dx	
	


loop_begin:

	; Clear values in memory; make bl point to the 32nd color
	xor		bx, bx
	mov		dword [z_x], 0x0
	mov		dword [z_y], 0x0
	

mdbt:

	cmp		bx, [max_i]	; Break out of loop if max_i has been reached
	je		plot_max
	
	; Calculate next point on the real axis

	fld		dword [z_x]
	fmul	dword [z_x] ; z_x * z_x
	
	fld		dword [z_y]
	fmul	dword [z_y] ; z_y * z_y
	fsubp				; z_x * z_x - z_y * z_y
	fadd	dword [a] 	; z_x * z_x - z_y * z_y + a
	fstp	dword [z_x_temp]

	fld		dword [two]
	fmul 	dword [z_x]
	fmul 	dword [z_y]
	fadd	dword [b] 	; 2 * z_x * z_y + b
	fstp	dword [z_y]
	
	push 	dword [z_x_temp]
	pop		dword [z_x]
	
	fld		dword [z_y]
	fmul	dword [z_y] ; z_y * z_y
	

	fld		dword [z_x]
	fmul	dword [z_x]	; z_x * z_x
	faddp				; z_y * z_y + z_x * z_x
	fld		dword [two]
	fadd	dword [two] ; 2 + 2 = 4
	
	fcompp	
	fstsw	ax			; Store flags in ax
	inc		bx
	sahf				; Set flags in FLAGS register
	
	jnc		mdbt		; If carry is down, z_y * z_y + z_x * z_x <= 4
	
	add		bl, 0x20	; I like the palette starting at color 32
	mov		[es:di], bl ; Place resulting color into memory address
	jmp		continue

plot_max:
	mov		byte [es:di], 0x0	; If i = max_i, plot black pixel

continue:
	
	; Increment to next pixel
	inc		di
	inc		cx
	cmp		di, 0xFA00	; Escape loop if end of screen is reached
	je		exit
	
	; Get new x-value (y value stays the same)
	fld		dword [x_scf]
	fadd	dword [a] 		; ST(0) = a + x_scf
	fstp	dword [a]


	; Determine whether a new row has been reached
	cmp		cx, 320
	jne		loop_begin

	; Get new y-value and reset x value
	fld		dword [b]
	fsub	dword [y_scf] 	; ST(0) = b - y_scf
	fstp	dword [b]

	push	dword [x_min]	; a = lb
	pop		dword [a]
	
	xor 	cx, cx
	inc 	dx

	jmp 	loop_begin	; Begin mandelbrot again for the next pixel
			
exit:

; System hangs here	
pc:
    jmp 	pc

x_min      dd      -2.0
x_max      dd      1.0
y_min      dd      -1.125
y_max      dd      1.125
x_scf      dd      0.009375
y_scf      dd      0.01125
z_x        dd      0.0
z_x_temp   dd      0.0
z_y        dd      0.0
a		   dd	   -2.0
b		   dd	   1.125
max_i	   dw	   96		; DO NOT SET OVER 65535
two		   dd	   2.0

times 510 - ($-$$)  db  0	
dw  0xaa55					; Boot Sector requires bytes 511 and 512 to be 0x55 and 0xaa respectively

times 1474560 - ($-$$)	db 0	; Grow image to the size of a 1.44 MB floppy disk




