% % 这个函数用于对序列进行比特重排；
% % innum为需要重排的序列；
% % chongpaishu为重排后的序列。

function picturess= yiwei(B1,pictures)
%%%%移位的两个方法
% % for i=1:M*N/4
% %     ershu=dec2bin(picture211(i),8);
% %     yishu=mod(B1(i),7)+1;
% %     b=circshift(ershu',-yishu)';
% %     picture211(i)=bin2dec(b);
% % end
% % picture211=reshape(picture211,M/2,N/2);

% %循环移位
for i=1:128*128
    result= dec2bin(B1(i));
    yishu=sum(result-'0');
    ershu=dec2bin(pictures(i),8);
    e=circshift(ershu',-yishu)';
    picturess(i)=bin2dec(e);
end
end
