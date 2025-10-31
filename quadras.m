function [J]=quadras(x,y,z,nnp)
NosNasArestas=[];
for i=1:nnp
    if x(i)==0 || x(i)==1
        if y(i)==0 || y(i)==1
            NosNasArestas=[NosNasArestas i];
        end
        if z(i)==0 || z(i)==1
            NosNasArestas=[NosNasArestas i];
        end
    end
    if y(i)==0 || y(i)==1
        if z(i)==0 || z(i)==1
            NosNasArestas=[NosNasArestas i];
        end
    end
end

NosNasArestas2=[];
for i=1:length(NosNasArestas)
    if ~ismember(NosNasArestas(i),NosNasArestas2)
        NosNasArestas2=[NosNasArestas2 NosNasArestas(i)];
    end
end

NosNasArestas=NosNasArestas2;
clear NosNasArestas2

NumeroDeNosNasArestas=length(NosNasArestas);

J=[];
K=[];
X=[];
m=1;
for i=1:NumeroDeNosNasArestas
    if x(NosNasArestas(i))~=0 && x(NosNasArestas(i))~=1
        for j=1:NumeroDeNosNasArestas
            if abs(x(NosNasArestas(j))-x(NosNasArestas(i)))<0.001
                K=[K NosNasArestas(j)];
            end
        end
        if length(K)==4
            J(m,:)=[K];
            m=m+1;
        end
        K=[];
        
    elseif y(NosNasArestas(i))~=0 && y(NosNasArestas(i))~=1

        for j=1:NumeroDeNosNasArestas
            if abs(y(NosNasArestas(j))-y(NosNasArestas(i)))<0.001
                K=[K NosNasArestas(j)];
            end
        end
        if length(K)==4
            J(m,:)=[K];
            m=m+1;
        end
        K=[];
        
    elseif z(NosNasArestas(i))~=0 && z(NosNasArestas(i))~=1
        for j=1:NumeroDeNosNasArestas
            if abs(z(NosNasArestas(j))-z(NosNasArestas(i)))<0.001
                K=[K NosNasArestas(j)];
            end
        end
        if length(K)==4
            J(m,:)=[K];
            m=m+1;
        end
        K=[];
        
    end
        
end


for i=1:NumeroDeNosNasArestas
    count(i)=sum(J(:) == NosNasArestas(i));
    %scatter3(x(NosNasArestas(i)),y(NosNasArestas(i)),z(NosNasArestas(i)),'MarkerFaceColor','r','MarkerFaceAlpha',.2,'MarkerEdgeColor','None'); hold on;
end
%figure;


J2=[];
m=1;
if ~ isempty(J)
    for i=1:length(J(:,1))
        if any(~ismember(J(i,:),J2))
            J2(m,:)=J(i,:);
            m=m+1;
        end
    end
end
J=J2;

% figure;
% for i=1:length(J)
%     c=[0.5*rand 0.5*rand 0.5*rand];
%     for j=1:4
%     scatter3(x(J(i,j)),y(J(i,j)),z(J(i,j)),'MarkerFaceColor','r','MarkerFaceAlpha',.2,'MarkerEdgeColor','None'); hold on;
%     end
% end

end