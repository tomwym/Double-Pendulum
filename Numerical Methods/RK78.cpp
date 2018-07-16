#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define PI 3.14159265358979323846
#define ERRTOL (1.e-13)
#define ZERO (1.e-15)

#define RUNTIME 25.
#define hSTEP .01

#define m1 1
#define m2 1
#define l1 1
#define l2 1
#define g 10

#define M11 (l1*l1*(m1+m2))
#define M12 (m2*l1*l2)
#define M21 (m2*l1*l2)
#define M22 (m2*l2*l2)
#define V1 ((m1+m2)*l1*g)
#define V2 (m2*l2*g)

int main(void)
{
   int i,j,k,N;
   double **traj;
   double x[4];
   double t,h,hmin,hmax;  //Integrator Parameters
   void ELfield(double t,double *x,int n,double *f);
   void ini_rk78(int n);
   void end_rk78(int n); 
   void rk78(double *at, double x[], double *ah, double tol,
            double hmin, double hmax, int n,
            void (*deriv)(double, double *, int, double *));
   double calc_E(double *x);
   double calc_H(double *x);

   N=1+floor(RUNTIME/hSTEP);
    
   traj=(double**)calloc(N,sizeof(double*));
   for(i=0;i<N;i++) {
      traj[i]=(double*)calloc(4,sizeof(double));
      if(traj[i]==NULL) {puts("Out of memory!"); exit(1);}
   } 
   
   ini_rk78(4);
   t=0.e0;
   h=hSTEP;
   hmin=hSTEP;
   hmax=hSTEP;

   /*IC1
   traj[0][0] = PI;
   traj[0][1] = PI;
   traj[0][2] = 0.3;
   traj[0][3] = 0.3;*/

   /*IC2
   traj[0][0] = PI;
   traj[0][1] = PI;
   traj[0][2] = .05;
   traj[0][3] = .05;*/
  
   /*IC3*/
   traj[0][0] = PI/2;
   traj[0][1] = PI/2;
   traj[0][2] = 0;
   traj[0][2] = 0;

   for(i=1;i<N;i++) {
        for(j=0;j<4;j++) traj[i][j] = traj[i-1][j];
        rk78(&t,traj[i],&h,1.e-15,hmin,hmax,4,ELfield);
   }
   end_rk78(4);
   for(i=1;i<N;i=i+1) printf("%e %e %e %e %e %e\n",traj[i][0],traj[i][1],traj[i][2],traj[i][3],i*hSTEP,calc_E(traj[i]));
   return(0);
}

void ELfield(double t,double *x,int n,double *f)
{
   double y[2];
   double denom;
   denom = M12*M12*cos(x[0]-x[1])*cos(x[0]-x[1])-M11*M22;
   y[0] = -M12*x[2]*x[3]*sin(x[0]-x[1])-V1*sin(x[0])+(x[2]-x[3])*M12*x[3]*sin(x[0]-x[1]);
   y[1] = M12*x[2]*x[3]*sin(x[0]-x[1])-V2*sin(x[1])+(x[2]-x[3])*M12*x[2]*sin(x[0]-x[1]);
   
   f[0] = x[2];
   f[1] = x[3];
   f[2] = (M12*cos(x[0]-x[1])*y[1]-M22*y[0])/denom;
   f[3] = (M12*cos(x[0]-x[1])*y[0]-M11*y[1])/denom;
}

double calc_E(double *x)
{
   double kin,pot,value;
   kin = .5*M11*x[2]*x[2]+.5*M22*x[3]*x[3]+M12*x[2]*x[3]*cos(x[0]-x[1]);
   pot = V1*(1-cos(x[0]))+V2*(1-cos(x[1]));
   value = kin+pot;
   return value;
}

static double alfa[13]={
           0.e0,      2.e0/27.e0,       1.e0/9.e0,        1.e0/6.e0,
     5.e0/12.e0,           0.5e0,       5.e0/6.e0,        1.e0/6.e0,
      2.e0/3.e0,       1.e0/3.e0,            1.e0,             0.e0,
           1.e0};

static double beta[79]={
           0.e0,      2.e0/27.e0,      1.e0/36.e0,       1.e0/12.e0,
     1.e0/24.e0,            0.e0,       1.e0/8.e0,       5.e0/12.e0,
           0.e0,    -25.e0/16.e0,     25.e0/16.e0,            .5e-1,
           0.e0,            0.e0,           .25e0,             .2e0,
  -25.e0/108.e0,            0.e0,            0.e0,    125.e0/108.e0,
   -65.e0/27.e0,    125.e0/54.e0,    31.e0/300.e0,             0.e0,
           0.e0,            0.e0,    61.e0/225.e0,       -2.e0/9.e0,
   13.e0/900.e0,            2.e0,            0.e0,             0.e0,
    -53.e0/6.e0,    704.e0/45.e0,    -107.e0/9.e0,      67.e0/90.e0,
           3.e0,   -91.e0/108.e0,            0.e0,             0.e0,
   23.e0/108.e0,  -976.e0/135.e0,    311.e0/54.e0,     -19.e0/60.e0,
     17.e0/6.e0,     -1.e0/12.e0, 2383.e0/4100.e0,             0.e0,
           0.e0,  -341.e0/164.e0, 4496.e0/1025.e0,    -301.e0/82.e0,
2133.e0/4100.e0,     45.e0/82.e0,    45.e0/164.e0,      18.e0/41.e0,
    3.e0/205.e0,            0.e0,            0.e0,             0.e0,
           0.e0,     -6.e0/41.e0,    -3.e0/205.e0,      -3.e0/41.e0,
     3.e0/41.e0,      6.e0/41.e0,            0.e0, -1777.e0/4100.e0,
           0.e0,            0.e0,  -341.e0/164.e0,  4496.e0/1025.e0,
  -289.e0/82.e0, 2193.e0/4100.e0,     51.e0/82.e0,     33.e0/164.e0,
    12.e0/41.e0,            0.e0,            1.e0};

static double c7[11]={
   41.e0/840.e0,            0.e0,            0.e0,             0.e0,
           0.e0,    34.e0/105.e0,      9.e0/35.e0,       9.e0/35.e0,
    9.e0/280.e0,     9.e0/280.e0,    41.e0/840.e0};

static double c8[13]={
           0.e0,            0.e0,            0.e0,             0.e0,
           0.e0,    34.e0/105.e0,      9.e0/35.e0,       9.e0/35.e0,
    9.e0/280.e0,     9.e0/280.e0,            0.e0,     41.e0/840.e0,
   41.e0/840.e0};

static double *x7,*x8,*xpon,*dx,*k[13];
static int neq=0;

#define MAX(a,b) (((a)<(b)) ? (b) : (a))
#define SGN(a) (((a)<0) ? -1 : 1)
#define NEG(a) (((a)<0) ? 1 : 0)
#define SGNCHG(y1,y2,x) (SGN(y1)*SGN(y2)>0 ? 0 : SGN(y2)*NEG(x))

void ini_rk78(int n)
/*
this is to allocate space for the package. it must be called before
calling the rk78 routine.

parameters:
n: dimension of the system to be integrated.
*/
{
   int j;
   if (n < 1) {puts("ini_rk78: n must be at least 1"); exit(1);}
   if (neq != 0)
      {
         free(x7);
         free(x8);
         free(xpon);
         free(dx);
         for (j=0; j<13; j++) free(k[j]);
      }
   neq=n;
   x7=(double*)malloc(n*sizeof(double));
   if (x7 == NULL) {puts("ini_rk78: out of memory (1)"); exit(1);}
   x8=(double*)malloc(n*sizeof(double));
   if (x8 == NULL) {puts("ini_rk78: out of memory (2)"); exit(1);}
   xpon=(double*)malloc(n*sizeof(double));
   if (xpon == NULL) {puts("ini_rk78: out of memory (3)"); exit(1);}
   dx=(double*)malloc(n*sizeof(double));
   if (dx == NULL) {puts("ini_rk78: out of memory (4)"); exit(1);}
   for (j=0; j<13; j++)
   {
      k[j]=(double*)malloc(n*sizeof(double));
      if (k[j] == NULL) {puts("ini_rk78: out of memory (5)"); exit(1);}
   }
   return;
}
void end_rk78(int n)
/*
this is to free the memory previously allocated by ini_rk78.

parameter:
n: dimension of the systems of odes. it should coincide with the value
   previously used by ini_rk78.
*/
{
   int j;
   if (n != neq) puts("end_rk78 warning: dimensions do not coincide!");
   free(x7);
   free(x8);
   free(xpon);
   free(dx);
   for (j=0; j<13; j++) free(k[j]);
   return;
}
void rk78(double *at, double x[], double *ah, double tol,
            double hmin, double hmax, int n,
            void (*deriv)(double, double *, int, double *))
/*
this routine performs one step of the integration procedure.
the initial condition (at,x) is changed by a new one corresponding
to the same orbit. the error is controlled by the threshold tol,
and an estimate of the error produced in the actual step is returned
as the value of the function.

parameters:
at:   time. input: time corresponding to the actual initial condition.
            output: new value corresponding to the new initial condition.
x:    position. same remarks as at.
ah:   time step (it can be modified by the routine according to the
      given threshold).
tol:  threshold to control the integration error.
hmin: minimun time step allowed.
hmax: maximum time step allowed.
n:    dimension of the system of odes.
deriv: function that returns the value of the vectorfield.

returned value: WHETHER OR NOT THE SIGN CHANGES!!! IN TERMS OF 0,+1,-1 !!! 


an estimate of the error produced in the actual step of
integration.
*/
{
   double tpon,tol1,err,nor,kh,beth,h1;
   int i,j,l,m;
   if (n > neq) {printf("rk78: wrong dimension (%d and %d)\n",n,neq); exit(1);}
   do {
/*
      this is to compute the values of k
*/
      m=0;
      for (i=0; i<13; i++)
      {
         tpon=*at+alfa[i]*(*ah);
         for (j=0; j<n; j++ ) xpon[j]=x[j];
         for ( l=0; l<i; l++ )
         {
            ++m;
            beth=*ah*beta[m];
            for (j=0; j<n; j++) xpon[j] += beth*k[l][j];
         }
         (*deriv)(tpon,xpon,n,dx);
         for (j=0; j<n; j++ ) k[i][j] = dx[j];
      }
/*
      this is to compute the rk7 and rk8 predictions
*/
      err=nor=0.e0;
      for (j=0; j<n; j++)
      {
         x7[j]=x8[j]=x[j];
         for (l=0; l<11; l++)
         {
            kh=*ah*k[l][j];
            x7[j] += kh*c7[l];
            x8[j] += kh*c8[l];
         }
         x8[j] += *ah*(c8[11]*k[11][j]+c8[12]*k[12][j]);
         err += fabs(x8[j]-x7[j]);
         nor += fabs(x8[j]);
      }
      err /= n;
/*
      next lines compute the new time step h
*/
      tol1=tol*(1+nor/100);
      if (err < tol1) err=MAX(err,tol1/256);
      h1=*ah;
      *ah*=0.9*pow(tol1/err,0.125);
      if (fabs(*ah) < hmin ) *ah=hmin*SGN(*ah);
      if (fabs(*ah) > hmax ) *ah=hmax*SGN(*ah);
   } while ((err >= tol1) && (fabs (*ah) > hmin));
   *at += h1;
   //i=SGNCHG(x[1],x8[1],x[0]);
   for (j=0; j<n; j++) x[j]=x8[j];
   return;// (i);
}


