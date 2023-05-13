function IntHiding()
    x=imread("Lena.bmp"); %载体图像
    m=2012026; %要嵌入的信息
    imshow(x,[])
    WaterMarked=Hide(x,m);
    watermark=Extract(WaterMarked)
end

function WaterMarked = Hide(origin,watermark)
    [Mc,Nc]=size(origin);
    WaterMarked=uint8(zeros(size(origin)));
    
    for i=1:Mc
        for j=1:Nc
            if i==1 && j<=21
                tem=bitget(watermark,j);
                WaterMarked(i,j)=bitset(origin(i,j),1,tem);
            else
                WaterMarked(i,j)=origin(i,j);
            end
        end
    end
    
    imwrite(WaterMarked,'lsb_int_watermarked.bmp','bmp');
    figure;
    imshow(WaterMarked,[]);
    title("WaterMarked Image");
end

function WaterMark=Extract(WaterMarked)
    WaterMark=0;
    for j=1:21
        tem=bitget(WaterMarked(1,j),1);
        WaterMark=bitset(WaterMark,j,tem);
    end
end