 
#include "mex.h" 

void mexFunction(int nlhs, mxArray *plhs[], 
    int nrhs, const mxArray *prhs[]) 
{ 


	double *uk; 
	double *ip, *d3, *d4; 
	int M1, N1; 
	int i, temp;
    
	uk = mxGetPr(prhs[0]);

	M1 = mxGetM(prhs[0]);
	N1 = mxGetN(prhs[0]);

	plhs[0] = mxCreateDoubleMatrix(M1, N1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(M1, N1, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(M1, N1, mxREAL); 
	ip = mxGetPr(plhs[0]);
    d3 = mxGetPr(plhs[1]);
    d4 = mxGetPr(plhs[2]);
    
    for(i=0; i<N1; i++) {
        d3[i] = 0;
        d4[i] = 0;
    }

	for (i=0; i<N1; i++) { 
        temp = uk[i]+d3[i]+d4[i];
        ip[i] = temp % 2;
        if (i+3 < N1) 
            d3[i+3] = ip[i];
        if (i+4 < N1)
            d4[i+4] = ip[i];
    }
} 

