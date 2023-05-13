% % 这个函数用于对求NPCR和NPCR的；
% % picture表示加密后的密文图像；
% % diffpicture表示与不同于picture而采用相同系统的加密图像；
% % NPCR,UACI分别表示计算出的值。

function [NPCR,UACI]= differential(picture,diffpicture)
picture10=int64(picture);
picture11=int64(fiffpicture);
npcr=0;
uaci=0;
M=256;N=256;
for i=1:M
    for j=1:N
        if   picture11(i,j)~=picture10(i,j)
            npcr=npcr+1;
        end
    end
end
NPCR=npcr/(M*N)
sum=0;
for i=1:M
    for j=1:N
        sum=sum+abs(picture11(i,j)-picture10(i,j));
    end
end
UACI=npcr/(M*N*255)
end
