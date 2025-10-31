function [Vc,Vd]=calcPHI3d(x,y,z,IEN,nel,surfnr)
Vc=0;
Vd=0;
V=zeros(nel,1);
%surfnr=surfnr_BOOL;
for e=1:nel
    x1=x(IEN(1,e));
    y1=y(IEN(1,e));
    z1=z(IEN(1,e));
    x2=x(IEN(2,e));
    y2=y(IEN(2,e));
    z2=z(IEN(2,e));
    x3=x(IEN(3,e));
    y3=y(IEN(3,e));
    z3=z(IEN(3,e));
    x4=x(IEN(4,e));
    y4=y(IEN(4,e));
    z4=z(IEN(4,e));
    
    
    V(e)=VolTetra(x1,x2,x3,x4,y1,y2,y3,y4,z1,z2,z3,z4);
    
%     if V(e)<(10^-4)
%         formatSpec = 'O volume do elemento %i é %2.2e \n';
%         fprintf(formatSpec,e,V(e))
%     end
    
    if surfnr(e)==0
        Vc=Vc+V(e);
    else
        Vd=Vd+V(e);
    end
    
    

end

