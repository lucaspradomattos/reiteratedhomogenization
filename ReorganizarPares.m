for i=length(PARES(:,1)):-1:1
    bool=0;
    for j=1:length(PARES(1,:))
        if ismember(PARES(i,j),IEN)
            bool=1;
        end
    end
    if ~bool
        PARES(i,:)=[];
    end
end

A=[];
for i=1:nnp
    if ismember(i,IEN)
                    A=[A i];
        if ~ismember(i,PARES)
            PARES(length(PARES(:,1))+1,:)=i*[1 1 0 0 0 0 0 0];
        end
    end
end
