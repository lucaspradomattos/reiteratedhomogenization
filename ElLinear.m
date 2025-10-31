function [k,f]=ElLinear(x,y,z,IEN,e,surfnr_BOOL,SIGMA,DIRECTION)
    for i=1:4
        X(i)=x(IEN(i,e));
        Y(i)=y(IEN(i,e));
        Z(i)=z(IEN(i,e));
        %text(X(i),Y(i),Z(i),num2str(i),'HorizontalAlignment','left','FontSize',18);hold on;
    end
    
    sigma=eye(3);
    if surfnr_BOOL(e)==1
        sigma=sigma*SIGMA;
    end
    
    
    J(1,1)= X(2)-X(1);
    J(1,2)= X(3)-X(1);
    J(1,3)= X(4)-X(1);
    
    J(2,1)= Y(2)-Y(1);
    J(2,2)= Y(3)-Y(1);
    J(2,3)= Y(4)-Y(1);
    
    J(3,1)= Z(2)-Z(1);
    J(3,2)= Z(3)-Z(1);
    J(3,3)= Z(4)-Z(1);
    
    v(e)=(det(J)/6);
    
    LAMBDA1=(((Y(3)-Y(1))*(Z(4)-Z(1)))-((Y(4)-Y(1))*(Z(3)-Z(1))))*(1/(6*v(e)));
    LAMBDA2=(((X(4)-X(1))*(Z(3)-Z(1)))-((X(3)-X(1))*(Z(4)-Z(1))))*(1/(6*v(e)));
    LAMBDA3=(((X(3)-X(1))*(Y(4)-Y(1)))-((X(4)-X(1))*(Y(3)-Y(1))))*(1/(6*v(e)));
    
    MU1=(((Y(4)-Y(1))*(Z(2)-Z(1)))-((Y(2)-Y(1))*(Z(4)-Z(1))))*(1/(6*v(e)));
    MU2=(((X(2)-X(1))*(Z(4)-Z(1)))-((X(4)-X(1))*(Z(2)-Z(1))))*(1/(6*v(e)));
    MU3=(((X(4)-X(1))*(Y(2)-Y(1)))-((X(2)-X(1))*(Y(4)-Y(1))))*(1/(6*v(e)));
      
    
    
    
    NU1=(((Y(2)-Y(1))*(Z(3)-Z(1)))-((Y(3)-Y(1))*(Z(2)-Z(1))))*(1/(6*v(e)));
    NU2=(((X(3)-X(1))*(Z(2)-Z(1))-((X(2)-X(1)))*(Z(3)-Z(1))))*(1/(6*v(e)));
    NU3=(((X(2)-X(1))*(Y(3)-Y(1)))-((X(3)-X(1))*(Y(2)-Y(1))))*(1/(6*v(e)));

    %verifica se a inversa do jacobiano está correta
    DIFF=sum(sum(([LAMBDA1 LAMBDA2 LAMBDA3 ; MU1 MU2 MU3 ; NU1 NU2 NU3]*J)-eye(3)));
    
    if DIFF >10^(-6)
        formatSpec = 'Atencão no cálculo da inversa do jacobiano do elemento %i, pois a diferença é %2.2e\n';
	    fprintf(formatSpec,e,DIFF)
    end

    
%     LAMBDA1=InversaDoJacobiano(1,1);
%     LAMBDA2=InversaDoJacobiano(1,2);
%     LAMBDA3=InversaDoJacobiano(1,3);
%     
%     MU1=InversaDoJacobiano(2,1);
%     MU2=InversaDoJacobiano(2,2);
%     MU3=InversaDoJacobiano(2,3);
%     
%     NU1=InversaDoJacobiano(3,1);
%     NU2=InversaDoJacobiano(3,2);
%     NU3=InversaDoJacobiano(3,3);

    k(1,1)=v(e)*(sigma(1,1)*(LAMBDA1+MU1+NU1)*(LAMBDA1+MU1+NU1)+2*sigma(1,2)*(LAMBDA1+MU1+NU1)*(LAMBDA2+MU2+NU2)+2*sigma(1,3)*(LAMBDA1+MU1+NU1)*(LAMBDA3+MU3+NU3)+sigma(2,2)*(LAMBDA2+MU2+NU2)*(LAMBDA2+MU2+NU2)+2*sigma(2,3)*(LAMBDA3+MU3+NU3)*(LAMBDA2+MU2+NU2)+sigma(3,3)*(LAMBDA3+MU3+NU3)*(LAMBDA3+MU3+NU3));
    
    k(1,2)=-v(e)*(sigma(1,1)*(LAMBDA1)*(LAMBDA1+MU1+NU1)+sigma(1,2)*((LAMBDA1)*(LAMBDA2+MU2+NU2)+(LAMBDA1+MU1+NU1)*(LAMBDA2))+sigma(1,3)*((LAMBDA1)*(LAMBDA3+MU3+NU3)+(LAMBDA1+MU1+NU1)*(LAMBDA3))+sigma(2,2)*(LAMBDA2)*(LAMBDA2+MU2+NU2)+sigma(2,3)*((LAMBDA3)*(LAMBDA2+MU2+NU2)+(LAMBDA3+MU3+NU3)*(LAMBDA2))+sigma(3,3)*(LAMBDA3+MU3+NU3)*(LAMBDA3));
    
    k(1,3)=-v(e)*(sigma(1,1)*(MU1)*(LAMBDA1+MU1+NU1)+sigma(1,2)*((MU1)*(LAMBDA2+MU2+NU2)+(LAMBDA1+MU1+NU1)*(MU2))+sigma(1,3)*((MU1)*(LAMBDA3+MU3+NU3)+(LAMBDA1+MU1+NU1)*(MU3))+sigma(2,2)*(MU2)*(LAMBDA2+MU2+NU2)+sigma(2,3)*((LAMBDA3+MU3+NU3)*(MU2)+(MU3)*(LAMBDA2+MU2+NU2))+sigma(3,3)*(LAMBDA3+MU3+NU3)*(MU3));
    
    k(1,4)=-v(e)*(sigma(1,1)*(NU1)*(LAMBDA1+MU1+NU1)+sigma(1,2)*((NU1)*(LAMBDA2+MU2+NU2)+(LAMBDA1+MU1+NU1)*(NU2))+sigma(1,3)*((NU1)*(LAMBDA3+MU3+NU3)+(LAMBDA1+MU1+NU1)*(NU3))+sigma(2,2)*(NU2)*(LAMBDA2+MU2+NU2)+sigma(2,3)*((LAMBDA3+MU3+NU3)*(NU2)+(NU3)*(LAMBDA2+MU2+NU2))+sigma(3,3)*(LAMBDA3+MU3+NU3)*(NU3));

    k(2,2)=v(e)*(sigma(1,1)*LAMBDA1*LAMBDA1+2*sigma(1,2)*LAMBDA1*LAMBDA2+2*sigma(1,3)*LAMBDA1*LAMBDA3+sigma(2,2)*LAMBDA2*LAMBDA2+2*sigma(2,3)*LAMBDA2*LAMBDA3+sigma(3,3)*LAMBDA3*LAMBDA3);
    
    k(2,3)=v(e)*(sigma(1,1)*LAMBDA1*MU1+2*sigma(1,2)*LAMBDA1*MU2+2*sigma(1,3)*LAMBDA1*MU3+sigma(2,2)*LAMBDA2*MU2+2*sigma(2,3)*LAMBDA2*MU3+sigma(3,3)*LAMBDA3*MU3);
    
    k(2,4)=v(e)*(sigma(1,1)*LAMBDA1*NU1+2*sigma(1,2)*LAMBDA1*NU2+2*sigma(1,3)*LAMBDA1*NU3+sigma(2,2)*LAMBDA2*NU2+2*sigma(2,3)*LAMBDA2*NU3+sigma(3,3)*LAMBDA3*NU3);
    
    k(3,3)=v(e)*(sigma(1,1)*MU1*MU1+2*sigma(1,2)*MU1*MU2+2*sigma(1,3)*MU1*MU3+sigma(2,2)*MU2*MU2+2*sigma(2,3)*MU2*MU3+sigma(3,3)*MU3*MU3);
    
    k(3,4)=v(e)*(sigma(1,1)*MU1*NU1+2*sigma(1,2)*MU1*NU2+2*sigma(1,3)*MU1*NU3+sigma(2,2)*MU2*NU2+2*sigma(2,3)*MU2*NU3+sigma(3,3)*MU3*NU3);
    
    k(4,4)=v(e)*(sigma(1,1)*NU1*NU1+2*sigma(1,2)*NU1*NU2+2*sigma(1,3)*NU1*NU3+sigma(2,2)*NU2*NU2+2*sigma(2,3)*NU2*NU3+sigma(3,3)*NU3*NU3);
    
    k(2,1)=k(1,2);
    
    k(3,1)=k(1,3);
        
    k(3,2)=k(2,3);
    
    k(4,1)=k(1,4);
    
    k(4,2)=k(2,4);
    
    k(4,3)=k(3,4);
    
    DIFF=(sum(sum(abs(k-k'))));
    
    if DIFF >10^(-6)
        formatSpec = 'A matriz de rigidez do elemento %i não é simétrica, pois a diferença é %2.2e\n';
	    fprintf(formatSpec,e,DIFF)
    end
    
    
    if DIRECTION=='F1'
        p=1;
    elseif DIRECTION=='F2'
        p=2;
    elseif DIRECTION=='F3'
        p=3;
    end

    f(1)=-v(e)*(sigma(1,p)*(LAMBDA1+MU1+NU1)+sigma(2,p)*(LAMBDA2+MU2+NU2)+sigma(3,p)*(LAMBDA3+MU3+NU3));
    
    f(2)=v(e)*(sigma(1,p)*(LAMBDA1)+sigma(2,p)*(LAMBDA2)+sigma(3,p)*(LAMBDA3));
    
    f(3)=v(e)*(sigma(1,p)*(MU1)+sigma(2,p)*(MU2)+sigma(3,p)*(MU3));
    
    f(4)=v(e)*(sigma(1,p)*(NU1)+sigma(2,p)*(NU2)+sigma(3,p)*(NU3));

    
end



