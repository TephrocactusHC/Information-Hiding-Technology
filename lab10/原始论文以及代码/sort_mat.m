% % 这个函数用于对序列进行索引排序；
% % A表示一个图像像素点矩阵；
% % New_mat表示排序后新矩阵；
% % Index_ij表示新矩阵对应原矩阵的位置；

function [New_mat Index_ij]= sort_mat(A)
clc
[M,N]=size(A);
B=reshape(A,1,[]);
[new_xulie index]=sort(B);
% new_xulie=fliplr(new_xulie);    %逆序，即降序排列
% index=fliplr(index);            %逆序，即降序排列
for i=1:M*N
    for j=1:N
        if index(i)>(j-1)*M  &  index(i)<=j*M   %判断当前索引的位置
            l=j;                                %当前索引的列
            h=index(i)-(j-1)*M;                 %当前索引的行
            Index_ij{i}=[h l];
        end
    end
end
New_mat=reshape(new_xulie,M,N);  %新矩阵
Index_ij=reshape(Index_ij,M,N);  %新矩阵对应原矩阵的位置
end
