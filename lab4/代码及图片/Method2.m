function Method2()
    x=input('请输入载体图像：','s'); %载体图像
    m=input('请输入要隐藏的秘密信息图像：','s'); %水印图像
    WaterMarked=Hide(x,m);
    watermark=Extract(WaterMarked);
end
 
function WaterMarked = Hide(origin,watermark)
    fidx=fopen(origin,'r');
    [x,xlength]=fread(fidx,inf,'uint8');

    fidm=fopen(watermark,'r');
    [m,mlength]=fread(fidm,inf,'uint8');

    %写入所有数据
    fid=fopen('Method2_watermarked.bmp','w');
    fwrite(fid,x);
    fwrite(fid,m);

    fclose(fid);
    fclose(fidx);
    fclose(fidm);

    WaterMarked=imread('Method2_watermarked.bmp');

    figure;
    imshow(WaterMarked,[]);
    title("WaterMarked Image");
    WaterMarked="Method2_watermarked.bmp";
end

function WaterMark=Extract(WaterMarked)
    fid=fopen(WaterMarked,'r');
    fseek(fid,2,"bof");

    moffset=fread(fid,1,'uint32');
    fseek(fid,moffset+2,"bof");
    mlen=fread(fid,1,"uint32");
    fseek(fid,moffset,"bof");
    fWaterMark=fread(fid,mlen,'uint8');
    fclose(fid);
    mfid=fopen("method2_watermark.bmp",'w');
    fwrite(mfid,fWaterMark,'uint8');
    fclose(mfid);


    WaterMark=imread('method2_watermark.bmp');
    figure;
    imshow(WaterMark,[]);
    title("WaterMark");
end