function out=BiEnt1_calc(Bspec)
Babs=abs(Bspec);
totalB=sum(sum(Babs));
q=Babs./totalB;
qlogq=q.*log(q);
out=-1* sum(sum(qlogq));