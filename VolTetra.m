function V=VolTetra(x1,x2,x3,x4,y1,y2,y3,y4,z1,z2,z3,z4)

A= [x1, y1, z1];
B =[x2, y2, z2];
C =[x3, y3, z3];
D =[x4, y4, z4];


AB=[B(1)-A(1),B(2)-A(2),B(3)-A(3)];
AC=[C(1)-A(1),C(2)-A(2),C(3)-A(3)];
AD=[D(1)-A(1),D(2)-A(2),D(3)-A(3)];

V=(det([AB;AC;AD])/6);