.text
.global __testandset
.type	__testandset,@function
__testandset:
	la	%r1,0(%r2)
	lghi	%r0,1
	lghi	%r2,0
	cs	%r2,%r0,0(%r1)
	xr	%r2,%r0
	br	%r14

