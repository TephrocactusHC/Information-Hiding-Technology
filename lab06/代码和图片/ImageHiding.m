function ImageHiding()
    x=imread("Lena.bmp"); %载体图像
    m=imread("lion.bmp"); %水印图像
    imshow(x,[])
    imshow(m,[]);
    WaterMarked=Hide(x,m);
    watermark=Extract(WaterMarked);
end

function WaterMarked = Hide(origin,watermark)
    [Mc,Nc]=size(origin);
    WaterMarked=uint8(zeros(size(origin)));
    
    for i=1:Mc
        for j=1:Nc
            WaterMarked(i,j)=bitset(origin(i,j),1,watermark(i,j));
        end
    end
    
    imwrite(WaterMarked,'lsb_watermarked.bmp','bmp');
    figure;
    imshow(WaterMarked,[]);
    title("WaterMarked Image");
end

function WaterMark=Extract(WaterMarked)
    [Mw,Nw]=size(WaterMarked);
    WaterMark=uint8(zeros(size(WaterMarked)));

    for i=1:Mw
        for j=1:Nw
            WaterMark(i,j)=bitget(WaterMarked(i,j),1);
        end
    end

    figure;
    imshow(WaterMark,[]);
    title("WaterMark");
end