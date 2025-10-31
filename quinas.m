function [pares,ndof]=quinas(x,y,z,PARES,nnp)


k=1;
I=[];
for i=1:nnp
    bool_x(i)=x(i) == 0 || x(i) == 1;
    bool_y(i)=y(i) == 0 || y(i) == 1;
    bool_z(i)=z(i) == 0 || z(i) == 1;

    if bool_x(i) && bool_y(i) && bool_z(i)
        I=[I i];
        %         QUINAS(k)=i;
        %         k=k+1;
    end
end



PARES=[PARES,zeros(length(PARES(:,1)),6)];
QUADRAS=quadras(x,y,z,nnp);

for j=1:length(I)
    for i=length(PARES):-1:1
        if any(PARES(i,:)==I(j)) 
            PARES(i,:)=[];
        end
    end
end

BOOL_APAGAR_PARES=zeros(length(PARES),1);

if ~ isempty(QUADRAS)
    for j=1:length(QUADRAS(:,1))
        for i=length(PARES):-1:1
            if any(ismember(PARES(i,:),QUADRAS))
                BOOL_APAGAR_PARES(i)=1;
            end
        end
    end


for i=length(PARES):-1:1
    if BOOL_APAGAR_PARES(i)
        PARES(i,:)=[];
    end
end

QUADRAS=[QUADRAS zeros(length(QUADRAS(:,1)),4)];
PARES=[I;QUADRAS;PARES];
else
    PARES=[I;PARES];
end
pares=PARES;
ndof=length(PARES(:,1));
