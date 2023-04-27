function [Pf, F]=power_calc1(xraw)
Fs=500;
config=[400 90 1024];
[Pf, F]=pwelch(xraw,config(1),config(2),config(3),Fs,'onesided');