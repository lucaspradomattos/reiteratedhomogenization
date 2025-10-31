function CHI=GC_red_precondicionado(b,K_red,LM,NEL)

LM=LM';

NEQ=length(b);

ANS=zeros(NEQ,1);
    
i=0;

q=zeros(NEQ,1);
d=ANS;

for e=1:NEL
    q(LM(e,1)) = q(LM(e,1)) + ((-(K_red(1,e)+K_red(2,e) + K_red(3,e)))*d(LM(e,1))) + K_red(1,e)*d(LM(e,2)) + K_red(2,e)*d(LM(e,3)) + K_red(3,e)*d(LM(e,4));
    q(LM(e,2)) = q(LM(e,2)) +  K_red(1,e)*d(LM(e,1)) + ((-(K_red(1,e)+K_red(4,e) + K_red(5,e)))*d(LM(e,2))) + K_red(4,e)*d(LM(e,3)) + K_red(5,e)*d(LM(e,4));
    q(LM(e,3)) = q(LM(e,3)) +  K_red(2,e)*d(LM(e,1)) + K_red(4,e)*d(LM(e,2)) + ((-(K_red(2,e)+K_red(4,e) + K_red(6,e)))*d(LM(e,3))) + K_red(6,e)*d(LM(e,4));
    q(LM(e,4)) = q(LM(e,4)) +  K_red(3,e)*d(LM(e,1)) + K_red(5,e)*d(LM(e,2)) + K_red(6,e)*d(LM(e,3)) + ((-(K_red(3,e)+K_red(5,e) + K_red(6,e)))*d(LM(e,4)));
end
    
r=b-q;
d=r;

DELTA_new=dot(r,r);
DELTA_0=DELTA_new;
ERRO=10^-8;


while (DELTA_new > (ERRO^2)*DELTA_0) && i<100000
    q=zeros(NEQ,1);
    
     for e=1:NEL
        q(LM(e,1)) = q(LM(e,1)) + ((-(K_red(1,e)+K_red(2,e) + K_red(3,e)))*d(LM(e,1))) + K_red(1,e)*d(LM(e,2)) + K_red(2,e)*d(LM(e,3)) + K_red(3,e)*d(LM(e,4));
        q(LM(e,2)) = q(LM(e,2)) +  K_red(1,e)*d(LM(e,1)) + ((-(K_red(1,e)+K_red(4,e) + K_red(5,e)))*d(LM(e,2))) + K_red(4,e)*d(LM(e,3)) + K_red(5,e)*d(LM(e,4));
        q(LM(e,3)) = q(LM(e,3)) +  K_red(2,e)*d(LM(e,1)) + K_red(4,e)*d(LM(e,2)) + ((-(K_red(2,e)+K_red(4,e) + K_red(6,e)))*d(LM(e,3))) + K_red(6,e)*d(LM(e,4));
        q(LM(e,4)) = q(LM(e,4)) +  K_red(3,e)*d(LM(e,1)) + K_red(5,e)*d(LM(e,2)) + K_red(6,e)*d(LM(e,3)) + ((-(K_red(3,e)+K_red(5,e) + K_red(6,e)))*d(LM(e,4)));
    end
    
    ALPHA=DELTA_new/dot(d,q);
    ANS=ANS+ALPHA*d;
      
    
    if mod(i,50)~=0
        
     q=zeros(NEQ,1);
    
     for e=1:NEL
        q(LM(e,1)) = q(LM(e,1)) + ((-(K_red(1,e)+K_red(2,e) + K_red(3,e)))*ANS(LM(e,1))) + K_red(1,e)*ANS(LM(e,2)) + K_red(2,e)*ANS(LM(e,3)) + K_red(3,e)*ANS(LM(e,4));
        q(LM(e,2)) = q(LM(e,2)) +  K_red(1,e)*ANS(LM(e,1)) + ((-(K_red(1,e)+K_red(4,e) + K_red(5,e)))*ANS(LM(e,2))) + K_red(4,e)*ANS(LM(e,3)) + K_red(5,e)*ANS(LM(e,4));
        q(LM(e,3)) = q(LM(e,3)) +  K_red(2,e)*ANS(LM(e,1)) + K_red(4,e)*ANS(LM(e,2)) + ((-(K_red(2,e)+K_red(4,e) + K_red(6,e)))*ANS(LM(e,3))) + K_red(6,e)*ANS(LM(e,4));
        q(LM(e,4)) = q(LM(e,4)) +  K_red(3,e)*ANS(LM(e,1)) + K_red(5,e)*ANS(LM(e,2)) + K_red(6,e)*ANS(LM(e,3)) + ((-(K_red(3,e)+K_red(5,e) + K_red(6,e)))*ANS(LM(e,4)));
    end
        
        r=b-q;        
    else
        r=r-ALPHA*q;
    end
    
    ANS=ANS-mean(ANS);
    r=r-mean(r);
    
    DELTA_old=DELTA_new;
    DELTA_new=dot(r,r);
    BETA=DELTA_new/DELTA_old;
    d=r+BETA*d;
    i=i+1;

    
end
i
CHI=ANS;