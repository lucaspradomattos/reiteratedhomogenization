
K_red(1,e)=k(1,2);
K_red(2,e)=k(1,3);
K_red(3,e)=k(1,4);
K_red(4,e)=k(2,3);
K_red(5,e)=k(2,4);
K_red(6,e)=k(3,4);

for i=1:4
    
    F(LM(i,e))=F(LM(i,e))+f(i);
    
    
end