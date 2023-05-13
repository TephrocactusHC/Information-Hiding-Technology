clc;clear;
I=imread('lena.jpg');
img=rgb2gray(I);
[m,n]=size(img);
P=reshape(img,1,m*n);
total=sum(P);
%-----------------------Henon映射----------------------------------------%
 %-改进的Henon映射 
a0=2.1;
b0=40 ;

x0=0.2;
y0=0.5;

z=zeros(200+m*n,2);
 for i=1:200+m*n
  
    x=(1-a0 * x0^2)*sin(y0) ;
    y=sin(b0*y0)+x0;
    
    x0=x;
    y0=y;
    
    z(i,1)=x;
    z(i,2)=y;
 end

XX=z(:,1)';
YY=z(:,2)';
%-----------------------计算混沌系统的初值-------------------------------%
X0=[total/2^23 0 0];
for i=1:2
  X0(i+1)=mod(X0(i)*10^6,1);
end
%-----------------------对混沌系统进行迭代--------------------------------%
x=X0(1);y=X0(2);z=X0(3);
a=3.89; b=0.51; c=2.73;
L=zeros(200+m*n,3);
for i=1:200+m*n
    x1=sin(a*y)-z*b;
    y1=(z*sin(c*x)-cos(y))*cos(1/z);
    z1=atan(b*x)*sin(1/y);
    x=x1;
    y=y1;
    z=z1;
    L(i,1)=x1;
    L(i,2)=y1;
    L(i,3)=z1;  
end

X=L(:,1);
E11=abs(X)-fix(abs(X));
Y=L(:,2);
E12=abs(Y)-fix(abs(Y));
Z=L(:,3);

B1=mod(ceil(XX(201:201+m*n-1)*10^6),7)+1;%列扰动
B2=mod(ceil(YY(end-7:end)*10^7),m*n-1)+1;%行扰动
B3=mod(floor((abs(X(201:208,:))-floor(abs(X(201:208,:))))*10^12),n-2);%分块
B4=X(end-16:2:end,:);%置乱 

B5=reshape(Y(201:200+m*n,:),m,n);%异或运算
B51=mod(floor(B5*10^15),256);

B6=reshape(Z(201:200+m*n,:),m,n);%异或运算
B61=mod(floor(B6*10^15),256);

%--------------------矩阵行向量转化成二进制矩阵---------------------------
A_1=dec2bin(P);         %P转换成字符型
A_2=logical(A_1-'0');	%将字符转成逻辑量
A1=double(A_2);	    %强制转为double型
%-------------------------------扰动--------------------------------------
A2=zeros(size(A1));
for i=1:m*n
  A2(i,:)=circshift(A1(i,:),B1(i),2);  %每列二进制数A1中被扰动得到矩阵A3
end

A3=zeros(size(A2));
for i=1:8
  A3(:,i)=circshift(A2(:,i),B2(i),1);  %每行二进制数A2中被扰动得到矩阵A3
end
%--------------------------转成十进制--------------------------------------
[nSamples,nbits] = size(A3);
nwords = ceil(nbits/8);%向上取整（正无穷方向）压缩bit->word.
A_3 = zeros([nSamples nwords], 'uint8'); 
for i = 1:nbits
  w = ceil(i/8);
  A_3(:,w) = bitset(A_3(:,w), mod(i-1,8)+1, A3(:,i));
end
A4=reshape(A_3,m,n);
%---------------------------------分块-------------------------------------
d0=zeros(1,4);

for j=1:4
  d0(j)=max(B3(2*j-1),B3(2*j))+1;
end
d=sort(d0);
A5=mat2cell(A4,[d(1),d(2)-d(1),n-d(2)],[d(3),d(4)-d(3),m-d(4)]);

%--------------------------------块间置乱----------------------------------

%T11=B4(end-16:2:end,:);  %取混沌序列的后9个数字
[T1_1,index1]=sort(B4);        %元素升序排列
S=reshape(index1,3,3);

A6=cell(3,3);
for i=1:9
  A6{S(i)}=A5(i);        %9个块之间根据混沌变换
end

A7=cell(3,3);
for i=1:9
  A7{i}=A6{i}{1};   
end

%------------------------------块内置乱-----------------------------------
A8=cell(3,3);
M=zeros(1,9);
N=zeros(1,9);
count1=zeros(1,9);
count2=zeros(1,9);

for i=1:9
    [M(i),N(i)]=size(A7{i});  
    count1(i)=sum(sum(rem(A7{i},2))); %计算奇数
    count2(i)=M(i)*N(i)-count1(i);
    if count1(i)>count2(i)
        A8{i}=circshift(A7{i},1,1);
    else
        A8{i}=circshift(A7{i},-1,2);
    end
end

A9=cell(1,9);
M1=zeros(1,9);
N1=zeros(1,9);
for i=1:9
   [M1(i),N1(i)]=size(A8{i});  
   A9{i}=reshape(A8{i},1,M(i)*N(i));
end
A10=reshape(cell2mat(A9),m,n);
A11=bitxor(bitxor(A10,uint8(B51)),uint8(B61));  %异或运算

imwrite(A11,'new1.jpg');
IMG=imread('new1.jpg');
subplot(1,2,1),imshow(img),title('原图');
subplot(1,2,2),imshow(A11),title('密文');
%--------------------信息熵分析--------------------------------------------
 
 ENTR=entropy(img);%明文熵
 ENTR1=entropy(A11);%密文熵
 
%----------------------直方图----------------------------------------------
figure(2);
imhist(img); set(gca,'linewidth',1)
xlabel('灰度')
ylabel('像素数/个') 
set(gca,'FontSize',20);
figure(2)
imhist(A11); set(gca,'linewidth',1)
xlabel('灰度')
ylabel('像素数/个') 
set(gca,'FontSize',20);

% %----------------------抗差分攻击----------------------------------------
% NPCR=mesure_npcr(A11,img);
% u=sum(abs(double(A11(:))-double(img(:)))/255);
% UACI=(u*100)/(m*n);

% %----------------------密文相关性------------------------------------------
%相邻像素点相关性
xm=[];h=[];v=[];d=[];
N0=5000;
for k=1:N0
    ki=fix(rand*(m-1))+1;kj=fix(rand*(m-1))+1;
    xm(k)=A11(ki,kj);
    h(k)=A11(ki+1,kj);
    v(k)=A11(ki,kj+1);
    d(k)=A11(ki+1,kj+1);
end
xm=double(xm);h=double(h);
v=double(v);d=double(d);
corh = corrcoef(xm,h);
corv = corrcoef(xm,v);
cord = corrcoef(xm,d);


%----------------------原图相关性------------------------------------------
xx0=[];h0=[];v0=[];d0=[];
im0=img;N1=3000;
for k=1:5000
    ki=fix(rand*(m-1))+1;kj=fix(rand*(n-1))+1;
    xx0(k)=im0(ki,kj);
    h0(k)=im0(ki+1,kj);
    v0(k)=im0(ki,kj+1);
    d0(k)=im0(ki+1,kj+1);
end
xx0=double(xx0);h0=double(h0);
v0=double(v0);d0=double(d0);
corh0 = corrcoef(xx0,h0);
corv0 = corrcoef(xx0,v0);
cord0 = corrcoef(xx0,d0);
%散点图
scatter(xx0,h0);title('原图像水平方向散点图');
set(gca,'linewidth',1)
xlabel('\itx')
ylabel('\ity') 
set(gca,'FontSize',20);
subplot(2,3,2)
scatter(xx0,v0);title('原图像垂直方向散点图');
subplot(2,3,3)
scatter(xx0,d0);title('原图像对角方向散点图');
subplot(2,3,4)
figure
scatter(xm,h);title('加密图像水平方向散点图'); 
set(gca,'linewidth',1)
xlabel('\itx')
ylabel('\ity') 
set(gca,'FontSize',20);
subplot(2,3,5)
scatter(xm,v);title('加密图像垂直方向散点图');
subplot(2,3,6)
scatter(xm,d);title('加密图像对角方向散点图');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 不知道咋回事儿，论文里根本没提解密的事儿，
% % 论文也没展示解密后的图像。。。
% % 那我自己写得了。。。就是逆运算
% % 简单写一下解密函数，很简单
% % 加载密文图像
IMG = imread('new1.jpg');

% % 密文解密过程
B11 = im2gray(IMG);

% % 反置乱块内图像
A8_inv = cell(3, 3);
for i = 1:9
    if count1(i) > count2(i)
        A8_inv{i} = circshift(A8{i}, -1, 1);
    else
        A8_inv{i} = circshift(A8{i}, 1, 2);
    end
end

% % 将块内图像恢复为行向量
A9_inv = cell(1, 9);
for i = 1:9
    A9_inv{i} = reshape(A8_inv{i}, 1, M(i) * N(i));
end

% % 将恢复的块重新组合为整个图像
A10_inv = reshape(cell2mat(A9_inv), m, n);

% % 进行异或运算，还原原始图像
A11_inv = bitxor(bitxor(A10_inv, uint8(B51)), uint8(B61));

% % 显示原始图像和解密后的图像
subplot(1, 2, 1);
imshow(A11_inv);
title('加密后的图');
subplot(1, 2, 2);
imshow(img);
title('解密后的图像');

