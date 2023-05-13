% % 这个函数用于对序列进行比特重排；
% % innum为需要重排的序列；
% % chongpaishu为重排后的序列。

function chongpaishu=chongpai(innum)
%%%%%%%十进制小数变成二进制
N=12;
count=0;
tempnum=innum;
record=zeros(1,N);
while(N)
    count=count+1;
    if(count>N)
        N=0;
    end
    tempnum=tempnum*2;
    if tempnum>1
        record(count)=1;
        tempnum=tempnum-1;
    elseif(tempnum==1)
        record(count)=1;
        N=0;
    else
        record(count)=0;
    end
end
if length(record)>12;
    record(13:length(record))=[];
end
a=record;
b=record;
%     b(6)=a(1);b(12)=a(2);b(5)=a(3);b(11)=a(4);b(4)=a(5);b(10)=a(6);
%     b(3)=a(7);b(9)=a(8);b(2)=a(9);b(8)=a(10);b(1)=a(11);b(7)=a(12);
for i=1:2:N
    b(N/2-(i+1)/2)=a(i);
end
for i=2:2:N
    b(N-(i-2)/2)=a(i);
end
% 整数部分
bit1 = 1;
bit_integer=[0];
% 小数部分
bit2 = 12;
bit_decimal =b;
integer = 0;
decimal = 0;
% 计算整数部分
for p = 1 : bit1
    integer = integer + bit_integer(p) * (2^(bit1 -p));
end
% 计算小数部分
for p = 1 : bit2
    decimal = decimal + bit_decimal(p) * (2^(-p));
end
% 整合
chongpaishu = integer + decimal;
end
