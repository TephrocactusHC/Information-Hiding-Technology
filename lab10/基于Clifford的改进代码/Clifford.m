clc;clear;
I=imread('lena.jpg');
img=rgb2gray(I);
[m,n]=size(img);
P=reshape(img,1,m*n);
total=sum(P);
%-----------------------Henonӳ��----------------------------------------%
 %-�Ľ���Henonӳ�� 
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
%-----------------------�������ϵͳ�ĳ�ֵ-------------------------------%
X0=[total/2^23 0 0];
for i=1:2
  X0(i+1)=mod(X0(i)*10^6,1);
end
%-----------------------�Ի���ϵͳ���е���--------------------------------%
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

B1=mod(ceil(XX(201:201+m*n-1)*10^6),7)+1;%���Ŷ�
B2=mod(ceil(YY(end-7:end)*10^7),m*n-1)+1;%���Ŷ�
B3=mod(floor((abs(X(201:208,:))-floor(abs(X(201:208,:))))*10^12),n-2);%�ֿ�
B4=X(end-16:2:end,:);%���� 

B5=reshape(Y(201:200+m*n,:),m,n);%�������
B51=mod(floor(B5*10^15),256);

B6=reshape(Z(201:200+m*n,:),m,n);%�������
B61=mod(floor(B6*10^15),256);

%--------------------����������ת���ɶ����ƾ���---------------------------
A_1=dec2bin(P);         %Pת�����ַ���
A_2=logical(A_1-'0');	%���ַ�ת���߼���
A1=double(A_2);	    %ǿ��תΪdouble��
%-------------------------------�Ŷ�--------------------------------------
A2=zeros(size(A1));
for i=1:m*n
  A2(i,:)=circshift(A1(i,:),B1(i),2);  %ÿ�ж�������A1�б��Ŷ��õ�����A3
end

A3=zeros(size(A2));
for i=1:8
  A3(:,i)=circshift(A2(:,i),B2(i),1);  %ÿ�ж�������A2�б��Ŷ��õ�����A3
end
%--------------------------ת��ʮ����--------------------------------------
[nSamples,nbits] = size(A3);
nwords = ceil(nbits/8);%����ȡ�����������ѹ��bit->word.
A_3 = zeros([nSamples nwords], 'uint8'); 
for i = 1:nbits
  w = ceil(i/8);
  A_3(:,w) = bitset(A_3(:,w), mod(i-1,8)+1, A3(:,i));
end
A4=reshape(A_3,m,n);
%---------------------------------�ֿ�-------------------------------------
d0=zeros(1,4);

for j=1:4
  d0(j)=max(B3(2*j-1),B3(2*j))+1;
end
d=sort(d0);
A5=mat2cell(A4,[d(1),d(2)-d(1),n-d(2)],[d(3),d(4)-d(3),m-d(4)]);

%--------------------------------�������----------------------------------

%T11=B4(end-16:2:end,:);  %ȡ�������еĺ�9������
[T1_1,index1]=sort(B4);        %Ԫ����������
S=reshape(index1,3,3);

A6=cell(3,3);
for i=1:9
  A6{S(i)}=A5(i);        %9����֮����ݻ���任
end

A7=cell(3,3);
for i=1:9
  A7{i}=A6{i}{1};   
end

%------------------------------��������-----------------------------------
A8=cell(3,3);
M=zeros(1,9);
N=zeros(1,9);
count1=zeros(1,9);
count2=zeros(1,9);

for i=1:9
    [M(i),N(i)]=size(A7{i});  
    count1(i)=sum(sum(rem(A7{i},2))); %��������
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
A11=bitxor(bitxor(A10,uint8(B51)),uint8(B61));  %�������

imwrite(A11,'new1.jpg');
IMG=imread('new1.jpg');
subplot(1,2,1),imshow(img),title('ԭͼ');
subplot(1,2,2),imshow(A11),title('����');
%--------------------��Ϣ�ط���--------------------------------------------
 
 ENTR=entropy(img);%������
 ENTR1=entropy(A11);%������
 
%----------------------ֱ��ͼ----------------------------------------------
figure(2);
imhist(img); set(gca,'linewidth',1)
xlabel('�Ҷ�')
ylabel('������/��') 
set(gca,'FontSize',20);
figure(2)
imhist(A11); set(gca,'linewidth',1)
xlabel('�Ҷ�')
ylabel('������/��') 
set(gca,'FontSize',20);

% %----------------------����ֹ���----------------------------------------
% NPCR=mesure_npcr(A11,img);
% u=sum(abs(double(A11(:))-double(img(:)))/255);
% UACI=(u*100)/(m*n);

% %----------------------���������------------------------------------------
%�������ص������
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


%----------------------ԭͼ�����------------------------------------------
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
%ɢ��ͼ
scatter(xx0,h0);title('ԭͼ��ˮƽ����ɢ��ͼ');
set(gca,'linewidth',1)
xlabel('\itx')
ylabel('\ity') 
set(gca,'FontSize',20);
subplot(2,3,2)
scatter(xx0,v0);title('ԭͼ��ֱ����ɢ��ͼ');
subplot(2,3,3)
scatter(xx0,d0);title('ԭͼ��ԽǷ���ɢ��ͼ');
subplot(2,3,4)
figure
scatter(xm,h);title('����ͼ��ˮƽ����ɢ��ͼ'); 
set(gca,'linewidth',1)
xlabel('\itx')
ylabel('\ity') 
set(gca,'FontSize',20);
subplot(2,3,5)
scatter(xm,v);title('����ͼ��ֱ����ɢ��ͼ');
subplot(2,3,6)
scatter(xm,d);title('����ͼ��ԽǷ���ɢ��ͼ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ��֪��զ���¶������������û����ܵ��¶���
% % ����Ҳûչʾ���ܺ��ͼ�񡣡���
% % �����Լ�д���ˡ���������������
% % ��дһ�½��ܺ������ܼ�
% % ��������ͼ��
IMG = imread('new1.jpg');

% % ���Ľ��ܹ���
B11 = im2gray(IMG);

% % �����ҿ���ͼ��
A8_inv = cell(3, 3);
for i = 1:9
    if count1(i) > count2(i)
        A8_inv{i} = circshift(A8{i}, -1, 1);
    else
        A8_inv{i} = circshift(A8{i}, 1, 2);
    end
end

% % ������ͼ��ָ�Ϊ������
A9_inv = cell(1, 9);
for i = 1:9
    A9_inv{i} = reshape(A8_inv{i}, 1, M(i) * N(i));
end

% % ���ָ��Ŀ��������Ϊ����ͼ��
A10_inv = reshape(cell2mat(A9_inv), m, n);

% % ����������㣬��ԭԭʼͼ��
A11_inv = bitxor(bitxor(A10_inv, uint8(B51)), uint8(B61));

% % ��ʾԭʼͼ��ͽ��ܺ��ͼ��
subplot(1, 2, 1);
imshow(A11_inv);
title('���ܺ��ͼ');
subplot(1, 2, 2);
imshow(img);
title('���ܺ��ͼ��');

