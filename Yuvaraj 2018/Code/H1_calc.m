function H1=H1_calc(Bspec)
Babs=abs(Bspec);
Blog=log(Babs);
 H1=sum(sum(Blog));