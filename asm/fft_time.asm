#define point_num 16

.global bit_reverse;
.global fft;

.section/data buffer;
.var reverse_index[point_num] = "data/reverse_index.dat";
.var input_real[point_num] = "data/input_real.dat";
.var input_virtual[point_num] = "data/input_virtual.dat";
.var output_real[point_num];
.var output_virtual[point_num];
.var output_tmp_real[point_num];
.var output_tmp_virtual[point_num];

.section/pm coeff;
.var coeff_real[point_num/2] = "data/coeff_real.dat";
.var coeff_virtual[point_num/2] = "data/coeff_virtual.dat";

.section/pm program;

bit_reverse:
	I4 = input_real;
	AX0 = I4;
	reg(B4) = AX0;
	I5 = output_real;
	AX0 = I5;
	reg(B5) = AX0;

	I6 = reverse_index;
	M6 = 1; M5 = 1;
	.repeat (point_num);
		AX0 = dm(I6, M6);
		M4 = AX0;
		AX0 = dm(I4 + M4);
		dm(I5, M5) = AX0;
	.end_repeat;

	I4 = input_virtual;
	AX0 = I4;
	reg(B4) = AX0;
	I5 = output_virtual;
	AX0 = I5;
	reg(B5) = AX0;

	I6 = reverse_index;
	.repeat (point_num);
		AX0 = dm(I6, M6);
		M4 = AX0;
		AX0 = dm(I4 + M4);
		dm(I5, M5) = AX0;
	.end_repeat;

	rts;


fft:
	call bit_reverse;


	SR0 = point_num/2;
	AY1 = 1;

	I0 = output_real;
	AX0 = I0;
	reg(B0) = AX0;
	I1 = output_virtual;
	AX0 = I1;
	reg(B1) = AX0;
	I2 = output_tmp_real;
	AX0 = I2;
	reg(B2) = AX0;
	I3 = output_tmp_virtual;
	AX0 = I3;
	reg(B3) = AX0;

	M0 = 1; M1 = 1;
	M2 = 1; M3 = 1;
	M4 = 1; M5 = 1;
	M6 = 1; M7 = 1;

	tag1:
	////////////////////////////////////
		AX0 = reg(B0);
		I0 = AX0;
		AR = AX0 + AY1;
		I4 = AR;
		AX0 = reg(B1);
		I1 = AX0;
		AR = AX0 + AY1;
		I5 = AR;
	
		AX0 = reg(B2);
		I2 = AX0;
		AR = AX0 + AY1;
		I6 = AR;
		AX0 = reg(B3);
		I3 = AX0;
		AR = AX0 + AY1;
		I7 = AR;
	

		/////////////////////////////////////
		tag11:
			AX1 = 0;
			ENA SEC_DAG;
			M0 = 0;
			M1 = 0;
			DIS SEC_DAG;
		//////////////////////////////////////
			tag111:
				Ena SEC_DAG;
				call get_coeff;
				AX0 = M0;
				AR = AX0 + SR0;
				M0 = AR;
				M1 = AR;
				DIS SEC_DAG;
			
				MX1 = dm(I4, M4);
				MY1 = dm(I5, M5);
			
				call complex_multiply;
			
				AX0 = dm(I0, M0);
				AY0 = dm(I1, M1);
			
				AR = MX0 + AX0;
				dm(I2, M2) = AR;
				AR = MY0 + AY0;
				dm(I3, M3) = AR;
			
				// I2,I3 += AY1
				AR = AX0 - MX0;
				dm(I6, M6) = AR;
				AR = AY0 - MY0;
				dm(I7, M7) = AR;
		
				AR = AX1 + 1;
				AX1 = AR;
				AR = AR - AY1;
				if NE jump tag111;
	
	//////////////////////////////////

			AX0 = I0;
			AR = AX0 + AY1;							     
			I0 = AR;
			
			AX0 = reg(B0);
			AR = AR - AX0;
			AR = AR - point_num;
			if EQ jump tag12;

			AX0 = I1;
			AR = AX0 + AY1;
			I1 = AR;
			AX0 = I2;
			AR = AX0 + AY1;
			I2 = AR;
			AX0 = I3;
			AR = AX0 + AY1;
			I3 = AR;
			AX0 = I4;
			AR = AX0 + AY1;
			I4 = AR;
			AX0 = I5;
			AR = AX0 + AY1;
			I5 = AR;
			AX0 = I6;
			AR = AX0 + AY1;
			I6 = AR;
			AX0 = I7;
			AR = AX0 + AY1;
			I7 = AR;

			jump tag11;

	tag12:
		ENA M_MODE;
		MR0 = 2;
		MR = AY1 * MR0(SS);
		AY1 = MR0;
		DIS M_MODE;

		I0 = output_real;
		I1 = output_virtual;
		I2 = output_tmp_real;
		I3 = output_tmp_virtual;
		CNTR = point_num;
		do end_copy until CE;
			AX0 = dm(I2, M2);
			dm(I0, M0) = AX0;
			AX0 = dm(I3, M3);
			dm(I1, M1) = AX0;
		end_copy: nop;nop;
	
	
		SR = ASHIFT SR0 by -1 (LO);
		
		AR = SR0 - 0;
		if NE jump tag1;
	
	rts;

complex_multiply:
	MR = MX0 * MX1(SS);
	MR = MR - MY0 * MY1(SS);
	AR = MR1;
	MR = MX0 * MY1(SS);
	MR = MR + MY0 * MX1(SS);
	MX0 = AR;
	MY0 = MR1;
	rts;

get_coeff:
//	DMPG2 = page(coeff);
	I0 = coeff_real; 
	I1 = coeff_virtual;
	MX0 = pm(I0 + M0);
	MY0 = pm(I1 + M1);
	rts;

