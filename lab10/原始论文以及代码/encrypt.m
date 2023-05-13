%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 加密过程
clc;clear all;close all;
picture=imread('lena.jpg');
picture = imresize (picture,0.5) 
figure
imhist(picture)
title('明文直方图')

r1=500;a1=127;t1=0.8;%t2=0.12;
figure
% % imshow(picture)
% % title('明文图像')
%加密
[M,N]=size(picture);
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

% % %%%预加密
% % picture2=bitxor(bitxor(picture,A),B);
%
% picture=uint8(reshape(picture,1,M*N));
% picture2(1)=bitxor(bitxor(bitxor(picture(1),picture(M*N)),AAA(1)),BBB(1));
% for i=2:M*N
%    picture2(i)=bitxor(bitxor(bitxor(picture(i),picture(i-1)),AAA(i)),BBB(i));
% end
% picture2=reshape(picture2,M,N);

% picture2=bitxor(bitxor(picture,A),B);
% picture2=reshape(picture2,M,N);
img=picture;
mysize=size(img);%当只有一个输出参数时，返回一个行向量，该行向量的第一个元素时矩阵的行数，第二个元素是矩阵的列数。
if numel(mysize)>2%如果是彩色图像
    img=rgb2gray(img); %将彩色图像转换为灰度图像
    fprintf('图像为彩色图');
end
[h,w]=size(img);
if h>w
    img = imresize(img, [w w]);
    fprintf('图像长宽不一样，图像可能失真');
end
if h<w
    img = imresize(img, [h h]);
    fprintf('图像长宽不一样,图像可能失真');
end
[h,w]=size(img);

%置乱与复原的共同参数,就相当于密码，有了这几个参数，图片就可以复原
n=10;%迭代次数
a=3;b=5;
N=h;%N代表图像宽高，宽高要一样

%Arnold置乱操作
imgn=zeros(h,w);
for i=1:n
    for y=1:h
        for x=1:w
            xx=mod((x-1)+b*(y-1),N)+1;   %mod(a,b)就是a除以b的余数
            yy=mod(a*(x-1)+(a*b+1)*(y-1),N)+1;
            imgn(yy,xx)=img(y,x);
        end
    end
    img=imgn;
end
imgn = uint8(imgn);
picture2=imgn;
% %%模加
%picture2=bitxor(bitxor(picture2,A),B);

picture2=uint8(reshape(picture2,1,M*N));
picture2(1)=bitxor(bitxor(picture2(1),AAA(1)),BBB(1));
for i=2:M*N
    picture2(i)=bitxor(bitxor(bitxor(picture2(i),picture2(i-1)),AAA(i)),BBB(i));
end
picture2=reshape(picture2,M,N);

figure
imshow(picture2)

%%分快
picture21=picture2(1:M/2,1:N/2);picture211=picture21;
picture22=picture2(1:M/2,N/2+1:N);picture221=picture22;
picture23=picture2(M/2+1:M,1:N/2);picture231=picture23;
picture24=picture2(M/2+1:M,N/2+1:N);picture241=picture24;

%%%%排序索引1
[New_mat,Index_ij]= sort_mat(B1);
for i=1:128
    for j=1:128
        y=Index_ij{i,j};
        picture2111(y(1),y(2))=picture21(i,j);
    end
end
picture2111=reshape(picture2111,1,M*N/4);

picture211=yiwei(A1,picture2111);
picture211=reshape(picture211,M/2,N/2);
% %%%%排序索引2
[New_mat,Index_ij]= sort_mat(B2);
for i=1:128
    for j=1:128
        y=Index_ij{i,j};
        picture221(y(1),y(2))=picture22(i,j);
    end
end
picture221=reshape(picture221,1,M*N/4);

picture221=yiwei(A2,picture221);
picture221=reshape(picture221,M/2,N/2);
%%%%%%%%3
[New_mat,Index_ij]= sort_mat(B3);
for i=1:128
    for j=1:128
        y=Index_ij{i,j};
        picture231(y(1),y(2))=picture23(i,j);
    end
end
picture231=reshape(picture231,1,M*N/4);

picture231=yiwei(A3,picture231);
picture231=reshape(picture231,M/2,N/2);

%%%%%%%%4
[New_mat,Index_ij]= sort_mat(B4);
for i=1:128
    for j=1:128
        y=Index_ij{i,j};
        picture241(y(1),y(2))=picture24(i,j);
    end
end
picture241=reshape(picture241,1,M*N/4);

picture241=yiwei(A4,picture241);
picture241=reshape(picture241,M/2,N/2);
%%%%%%%%%%%%%
picture3=picture2;
picture3(1:M/2,1:N/2)=picture211;
picture3(1:M/2,N/2+1:N)=picture221;
picture3(M/2+1:M,1:N/2)=picture231;
picture3(M/2+1:M,N/2+1:N)=picture241;
imshow(picture3);
title('密文图像');
save('jiamizuizhong.mat','picture3');
figure
imhist(picture3)
title('密文直方图')
Rab=re_lativity(picture3,1)
Rab=re_lativity(picture3,2)
Rab=re_lativity(picture3,3)
Infor_entopy=Information_entropy(picture3)
