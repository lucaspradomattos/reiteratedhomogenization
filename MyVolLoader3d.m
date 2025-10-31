function [x,y,z,surfnr_BOOL,IEN,nel,Srf,nnp]=MyVolLoader3d(filename)

fid = fopen(filename,'r');
textscan(fid,'%*s',4,'delimiter','\n'); % Read strings delimited by a carriage return

while (~feof(fid))
    InputText=textscan(fid,'%s',1,'delimiter','\n'); % Read line
    if strcmp(InputText{1},'surfaceelements')
        textscan(fid,'%*f',1); % discard element count
        FormatString='%f %f %f %f %f %f %f %f %f %f %f';
        InputText=textscan(fid,FormatString); % Read data block
        Srf=cell2mat(InputText); % Convert to numerical array from cell
    elseif strcmp(InputText{1},'points')
        textscan(fid,'%*f',1); % discard element count
        FormatString='%f %f %f';
        InputText=textscan(fid,FormatString); % Read data block
        X=cell2mat(InputText); % Convert to numerical array from cell
    elseif strcmp(InputText{1},'volumeelements')
        textscan(fid,'%*f',1); % discard element count
        FormatString='%f %f %f %f %f %f %f %f %f %f %f %f';
        InputText=textscan(fid,FormatString); % Read data block
        VolElem=cell2mat(InputText); % Convert to numerical array from cell
    end
    
end
fclose(fid);
y=X(:,1);
x=X(:,2);
z=X(:,3);
surfnr=VolElem(:,1);
IEN=VolElem(:,3:12);
nel=length(IEN(:,1));
nnp=length(x);
IEN=IEN';
IEN=IEN(1:4,:);
RegiaoComMaisElemento=find(hist(surfnr,max(surfnr))==max(hist(surfnr,max(surfnr))));
for e=1:nel
    %if surfnr(e)==surfnr(1)
    if surfnr(e)==RegiaoComMaisElemento(1)
        surfnr_BOOL(e)=0;
    else
        surfnr_BOOL(e)=1;
    end
end