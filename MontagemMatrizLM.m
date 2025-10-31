LM=zeros(4,nel);

for i=1:Nnl
    for j=1:nel
        [row,col]=find(PARES==IEN(i,j));
        LM(i,j)=row(1);
    end
end

nin=max(max(LM)); %numero de incognitas
F=zeros(nin,1);