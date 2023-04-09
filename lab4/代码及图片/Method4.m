function Method4()
    x=input('请输入载体图像：','s'); %载体图像
    m=input('请输入要隐藏的秘密信息(int型)：'); %秘密信息
    WaterMarked=Hide(x,m);
    watermark=Extract(WaterMarked);
end
 
function WaterMarked = Hide(origin,watermark)
    fidx=fopen(origin,'r');
    
    fseek(fidx,0,"bof");
    [x,xlength]=fread(fidx,inf,'uint8'); 

    fid=fopen('Method4_watermarked.bmp','w');
    fwrite(fid,x);

    %加入秘密信息
    fseek(fid,6,"bof");
    fwrite(fid,watermark,"uint32");

    fclose(fid);
    fclose(fidx);

    WaterMarked=imread('Method4_watermarked.bmp');

    figure;
    imshow(WaterMarked,[]);
    title("WaterMarked Image");
    WaterMarked="Method4_watermarked.bmp";
end

function WaterMark=Extract(WaterMarked)
    fid=fopen(WaterMarked,'r');

    %获取秘密信息
    fseek(fid,6,"bof");
    m=fread(fid,1,'uint32');
    
    fclose(fid);
    
    WaterMark=m;

    WaterMark
end