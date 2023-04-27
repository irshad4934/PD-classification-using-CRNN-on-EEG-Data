function H2=H2_calc(Bspec)
Babs=abs(Bspec);
Blog=log(Babs);
Bdiag=diag(Blog);
H2=sum(sum(Bdiag));