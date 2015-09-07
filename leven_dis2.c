 
#include "mex.h" 

void mexFunction(int nlhs, mxArray *plhs[], 
    int nrhs, const mxArray *prhs[]) 
{ 


	double *inData1, *inData2, *d; 
	double *outData; 
	int M1,N1; 
	int i, j;

	inData1 = mxGetPr(prhs[0]); 
	inData2 = mxGetPr(prhs[1]); 
	d = mxGetPr(prhs[2]);

	M1 = mxGetM(prhs[2]);
	N1 = mxGetN(prhs[2]);

	plhs[0] = mxCreateDoubleMatrix(M1, N1, mxREAL); 
	outData = mxGetPr(plhs[0]); 

	// source prefixes can be transformed into empty string by
	// dropping all characters
	for(i=1; i<M1; i++)
		d[i] = i;
	// target prefixes can be reached from empty source prefix
	// by inserting every character
	for(j=1; j<N1; j++)
		d[j*M1] = j;

	for(j=1; j<N1; j++) {
		for(i=1; i<M1; i++) {
			if(inData1[i-1] == inData2[j-1])
				d[j*M1+i] = d[(j-1)*M1+i-1];
			else {
				if(d[(j-1)*M1+i] > d[j*M1+i-1]) {
					if(d[j*M1+i-1] > d[(j-1)*M1+i-1])
						d[j*M1+i] = d[(j-1)*M1+i-1] + 1;
					else
						d[j*M1+i] = d[j*M1+i-1] + 1;
				}
				else {
					if(d[(j-1)*M1+i] > d[(j-1)*M1+i-1])
						d[j*M1+i] = d[(j-1)*M1+i-1] + 1;
					else
						d[j*M1+i] = d[(j-1)*M1+i] + 1;
				}
			}
		}
	}
			

	for(i=0; i<M1; i++)
		for(j=0; j<N1; j++)
			outData[j*M1+i] = d[j*M1+i];
} 

