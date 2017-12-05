.EXTERN	 fft;

.section/pm seg_ivt;

JUMP start;NOP;NOP;

.section/pm program;
start:
	CALL fft;
	IDLE;

