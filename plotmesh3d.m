

X=[x,y,z];
T=IEN(1:4,:)';
figure;
DesenhaCelula;
for e=1:nel
    if surfnr_BOOL(e)==1
        tetramesh(T(e,:),X,'FaceColor','red','FaceAlpha',1);hold on;
        for i=1:Nnl
            
            %text(x(IEN(i,e)),y(IEN(i,e)),z(IEN(i,e)),num2str((IEN(i,e))),'HorizontalAlignment','left','FontSize',18);hold on;
            
           
        end
    else
         tetramesh(T(e,:),X,'FaceColor','w','FaceAlpha',0);hold on;
        for i=1:Nnl
            
            %text(x(IEN(i,e)),y(IEN(i,e)),z(IEN(i,e)),num2str((IEN(i,e))),'HorizontalAlignment','left','FontSize',18);hold on;
           
            end
    end
end
clear X;


% for i=1:nnp
% 	text(x(i),y(i),z(i),num2str(i),'HorizontalAlignment','left','FontSize',18);hold on;
% end
view (45,20)
xlim([0 1])
ylim([0 1])
zlim([0 1])
%camorbit(20,0)

xlabel('X')
ylabel('Y')
zlabel('Z')
view(45,45)  % XY
% pause
% view(0,0)   % XZ
% pause
% view(90,0)  % YZ
