% % 这个函数用于对求解相关性；
% % picture表示待测试图像的矩阵；
% % direction有三个取值1、2、3，当direction=1表示选择计算水平方向相邻点，当direction=2表示选择计算垂直方向相邻点，当direction=3表示选择计算对角方向相邻点；
% % Rab表示该picture矩阵的相关性系数值。

function Rab=re_lativity(picture7,direction)
x=round(rand(1,5000)*256);
y=round(rand(1,5000)*256);
result1=zeros(1,5000);
result2=zeros(1,5000);
for i=1:5000
    if x(i)==0
        x(i)=x(i)+1;
    end
    if y(i)==0
        y(i)=y(i)+1;
    end
    result1(i)=picture7(x(i),y(i));
    if direction==1
        % %水平方向
        if y(i)==256
            result2(i)=picture7(x(i),y(i)-1);
        else 
            result2(i)=picture7(x(i),y(i)+1);
        end
    end
    %垂直方向
    if direction==2
        if x(i)==256
            result2(i)=picture7(x(i)-1,y(i));
        else result2(i)=picture7(x(i)+1,y(i));
        end
    end
    %  %对角线
    if direction==3
        if    x(i)==256||y(i)==256
            result2(i)=picture7(x(i)-1,y(i)-1);
        else
            if y(i)==256
                result2(i)=picture7(x(i)+1,y(i)-1);
            end
            if  x(i)==256
                result2(i)=picture7(x(i)-1,y(i)+1);
            end
            result2(i)=picture7(x(i)+1,y(i)+1);
        end
    end
end
figure
plot(result1,result2,'b.');
xlabel('(x,y)处的像素值')
ylabel('(x+1,y)处的像素值')
axis([0 255 0 255])

a=result1;
b=result2;
da=sum((a(1,:)-mean(a)).^2)/length(a);
db=sum((b(1,:)-mean(b)).^2)/length(b);
covab=sum((a(1,:)-mean(a)).*(b(1,:)-mean(b)))/length(a);
Rab=covab/sqrt((da*db))
end
