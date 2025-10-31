function [pares]=ParesCorrespondentes_linear(x,y,z,nnp)

k=1;

for i=1: nnp
    if x(i)==0
        for j=1:nnp
            if x(j)==1 && y(j)==y(i) && z(j)==z(i) && x(i)==0
                pares(k,:)=[i j];
                k=k+1;
            end
        end
    end
end

for i=1: nnp
    if y(i)==0
        for j=1:nnp
            if y(j)==1 && x(j)==x(i) && z(j)==z(i) && y(i)==0
                pares(k,:)=[i j];
                k=k+1;
            end
        end
    end
end

for i=1: nnp
    if z(i)==0
        for j=1:nnp
            if z(j)==1 && x(j)==x(i) && y(j)==y(i) && z(i)==0
                pares(k,:)=[i j];
                k=k+1;
            end
        end
    end
end

%%demais pontos
for i=1:nnp
    if ~any(any(pares==i))
      
        pares(k,:)=[i i];
        k=k+1;
    end
end
pares=sortrows(pares,1);




