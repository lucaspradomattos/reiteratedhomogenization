function I=SomatorioKElLinear(x,y,z,IEN,LM,e,chi,surfnr_BOOL,SIGMA,DIRECTION)
    for i=1:4
        X(i)=x(IEN(i,e));
        Y(i)=y(IEN(i,e));
        Z(i)=z(IEN(i,e));
        PSI(i)=chi(LM(i,e));
        %text(X(i),Y(i),Z(i),num2str(i),'HorizontalAlignment','left','FontSize',18);hold on;
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
    
    v(e)=abs(det(J)/6);
    
    InversaDoJacobiano=inv(J);
    
    LAMBDA1=InversaDoJacobiano(1,1);
    LAMBDA2=InversaDoJacobiano(1,2);
    LAMBDA3=InversaDoJacobiano(1,3);
    
    MU1=InversaDoJacobiano(2,1);
    MU2=InversaDoJacobiano(2,2);
    MU3=InversaDoJacobiano(2,3);
    
    NU1=InversaDoJacobiano(3,1);
    NU2=InversaDoJacobiano(3,2);
    NU3=InversaDoJacobiano(3,3);
    
    if DIRECTION=='F1'
        q=1;
    elseif DIRECTION=='F2'
        q=2;
    elseif DIRECTION=='F3'
        q=3;
    end

    sigma=eye(3);
    if surfnr_BOOL(e)==1
        sigma=sigma*SIGMA;
    end
    
    A=(DELTA(1,q)-(PSI(2)-PSI(1))*LAMBDA1-(PSI(3)-PSI(1))*MU1-(PSI(4)-PSI(1))*NU1);
    B=(DELTA(2,q)-(PSI(2)-PSI(1))*LAMBDA2-(PSI(3)-PSI(1))*MU2-(PSI(4)-PSI(1))*NU2);
    C=(DELTA(3,q)-(PSI(2)-PSI(1))*LAMBDA3-(PSI(3)-PSI(1))*MU3-(PSI(4)-PSI(1))*NU3);
    
    I=v(e)*(sigma(q,1)*A+sigma(q,2)*B+sigma(q,3)*C);
    
   