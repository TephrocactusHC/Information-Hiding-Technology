%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 解密
clear ,close all
load('jiamizuizhong.mat','picture3')
picture5=picture3;
r1=500;a1=127;t1=0.8;%t2=0.12;
imshow(picture5)
title('密文图像')
%加密
[M,N]=size(picture5);
x=1/a1+t1;%%x取值（0,1）
% u=1/a1+t2+3.9;
%改进型logistic
for i=1:r1+N*M
    x=(3.569945973+(4-3.569945973)*sin(pi*x/2))*x*(1-x);
end
A=zeros(1,r1+M*N);
A(1)=x;
for i=1:r1+M*N
    A(i)=chongpai(A(i));
    A(i+1)=(3.569945973+(4-3.569945973)*sin(pi*A(i)/2))*A(i)*(1-A(i));
end
for i=1:M*N
    AA(i)=A(r1+i);
end
% %重排序列
% for j=1:M*N
% AAA(j)=chongpai(AA(j));
% end
AAA=AA;

AAA=uint8(mod(AAA*10E6,256));
A=reshape(AAA,M,N);

A1=AAA(1:M/2*N/2);
A2=AAA(M/2*N/2+1:M*N/2);
A3=AAA(M*N/2+1:3*M/4*N);
A4=AAA(3*M/4*N+1:M*N);
A=reshape(AAA,M,N);

% tent
a3=117;t5=0.001;t6=0.001;r3=500;
x=1/a3+t5;ahap=1/a3+t6;
B(1)=0.4;
ahap=0.35;
for i=1:r3+M*N
    if(x>=ahap)
        x=(1-x)/(1-ahap);
    else
        x=x/ahap;
    end
end
for i=1:r3+M*N
    B(i)=chongpai(B(i));
    if(B(i)>=ahap)
        B(i+1)=(1-B(i))/(1-ahap);
    else
        B(i+1)=B(i)/ahap;
    end
end
for i=1:M*N
    BB(i)=B(r1+i);
end
% %重排序列
% for j=1:M*N
% BBB(j)=chongpai(BB(j));
% end
BBB=BB;
BBB=uint8(mod(BBB*10E6,256));

B1=BBB(1:M/2*N/2);B1=reshape(B1,M/2,N/2);
B2=BBB(M/2*N/2+1:M*N/2);B2=reshape(B2,M/2,N/2);
B3=BBB(M*N/2+1:3*M/4*N);B3=reshape(B3,M/2,N/2);
B4=BBB(3*M/4*N+1:M*N);B4=reshape(B4,M/2,N/2);
B=reshape(BBB,M,N);

%%%分块

picture51=picture5(1:M/2,1:N/2);picture511=picture51;
picture52=picture5(1:M/2,N/2+1:N);picture521=picture52;
picture53=picture5(M/2+1:M,1:N/2);picture531=picture53;
picture54=picture5(M/2+1:M,N/2+1:N);picture541=picture54;

picture511=reshape(picture511,1,M*N/4);
picture521=reshape(picture521,1,M*N/4);
picture531=reshape(picture531,1,M*N/4);
picture541=reshape(picture541,1,M*N/4);

picture511=niyiwei(A1,picture511);
picture521=niyiwei(A2,picture521);
picture531=niyiwei(A3,picture531);
picture541=niyiwei(A4,picture541);
%%%%排序索引1
B1=reshape(B1,M/2,N/2);picture511=reshape(picture511,M/2,N/2);
B2=reshape(B2,M/2,N/2);picture521=reshape(picture521,M/2,N/2);
B3=reshape(B3,M/2,N/2);picture531=reshape(picture531,M/2,N/2);
B4=reshape(B4,M/2,N/2);picture541=reshape(picture541,M/2,N/2);
[New_mat,Index_ij]= sort_mat(B1);
for i=1:128
    for j=1:128
        y=Index_ij{i,j};
        picture512(i,j)= picture511(y(1),y(2));
    end
end

%%%%排序索引2
B1=reshape(B1,M/2,N/2);
[New_mat,Index_ij]= sort_mat(B2);
for i=1:128
    for j=1:128
        y=Index_ij{i,j};
        picture522(i,j)= picture521(y(1),y(2));
    end
end
%%%%排序索引3
B1=reshape(B3,M/2,N/2);
[New_mat,Index_ij]= sort_mat(B3);
for i=1:128
    for j=1:128
        y=Index_ij{i,j};
        picture532(i,j)= picture531(y(1),y(2));
    end
end

%%%%排序索引4
B1=reshape(B4,M/2,N/2);
[New_mat,Index_ij]= sort_mat(B4);
for i=1:128
    for j=1:128
        y=Index_ij{i,j};
        picture542(i,j)= picture541(y(1),y(2));
    end
end

%%%%%%%%%%%%%
picture333=picture5;
picture333(1:M/2,1:N/2)=picture512;
picture333(1:M/2,N/2+1:N)=picture522;
picture333(M/2+1:M,1:N/2)=picture532;
picture333(M/2+1:M,N/2+1:N)=picture542;

%%%模加
%  picture444=bitxor( bitxor(picture333,B),A);

picture333=uint8(reshape(picture333,1,M*N));

picture444(1)=bitxor(bitxor(picture333(1),AAA(1)),BBB(1));
for i=2:M*N
    picture444(i)=bitxor(bitxor(bitxor(picture333(i),picture333(i-1)),AAA(i)),BBB(i));
end
picture444=reshape(picture444,M,N);

%Arnold复原
%置乱与复原的共同参数,就相当于密码，有了这几个参数，图片就可以复原
[h,w]=size(picture444);
n=10;%迭代次数
a=3;b=5;
N=h;%N代表图像宽高，宽高要一样
img2=picture444;

for i=1:n
    for y=1:h
        for x=1:w
            xx=mod((a*b+1)*(x-1)-b*(y-1),N)+1;
            yy=mod(-a*(x-1)+(y-1),N)+1  ;
            imgn(yy,xx)=img2(y,x);
        end
    end
    img2=imgn;
end
imgn = uint8(imgn);
figure
picture444=imgn;
%%%%%%%%%结果
imshow(picture444)
title('解密图像')
