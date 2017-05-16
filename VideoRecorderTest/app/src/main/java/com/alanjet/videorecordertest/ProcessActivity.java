package com.alanjet.videorecordertest;

import android.content.Intent;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.File;

/**
 * Created by 朱袁旭 on 2017/5/14.
 */

public class ProcessActivity extends AppCompatActivity {
    private ImageView imageView;//声明ImageView对象
    private Button mButtonProcess;
    private TextView mTextPicture;
    private String mFileName;
    private int[] pix = new int[640 * 480];
    private int h;
    private int w;
    private double [] resultXYZ=new double[480*3];
//    private int[] pix = new int[480 * 640];

    private static final String TAG = "MediaDecoder";
    private MediaMetadataRetriever retriever = null;
    private String fileLength;
    private int videoLength;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.process_picture);
        imageView=(ImageView)findViewById(R.id.imageView);//获取布局管理器中的ImageView控件
        Intent i=getIntent();
        mFileName=i.getStringExtra("id");
        getVedioFileLength();

        Bitmap bitmap1=decodeFrame(1000);
        imageView.setImageBitmap(bitmap1);//设置ImageView显示的图片

//        MediaMetadataRetriever mmr=new MediaMetadataRetriever();//实例化MediaMetadataRetriever对象
//        File file=new File(mVideoName);//实例化File对象，文件路径为/storage/sdcard/Movies/music1.mp4

//        if(file.exists()){
//            mmr.setDataSource(file.getAbsolutePath());//设置数据源为该文件对象指定的绝对路径
//            Bitmap bitmap=mmr.getFrameAtTime();//获得视频第一帧的Bitmap对象
//            if(bitmap!=null){
//                imageView.setImageBitmap(bitmap);//设置ImageView显示的图片
//                Toast.makeText(PictureActivity.this, "获取视频缩略图成功", Toast.LENGTH_SHORT).show();//获取视频缩略图成功，弹出消息提示框
//            }else{
//                Toast.makeText(PictureActivity.this, "获取视频缩略图失败", Toast.LENGTH_SHORT).show();//获取视频缩略图失败，弹出消息提示框
//            }
//        }else {
//            Toast.makeText(PictureActivity.this, "文件不存在", Toast.LENGTH_SHORT).show();//文件不存在时，弹出消息提示框

//        FileInputStream ff=openFileInput(videoFile,0);


//            FileInputStream fin=new FileInputStream(videoFile);
//        FileInputStream.class.FileInputStream(videoFile);
//            fin.read();
        mButtonProcess=(Button)findViewById(R.id.button_process);
        mTextPicture=(TextView)findViewById(R.id.text_picture);
        mButtonProcess.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v){
                processImage();
            }
        });

    }




    public void getVedioFileLength() {
        File file=new File(mFileName);//实例化File对象，文件路径为/storage/sdcard/Movies/music1.mp4
        if(file.exists()){
            retriever = new MediaMetadataRetriever();
            retriever.setDataSource(file.getAbsolutePath());
            fileLength = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            videoLength=Integer.parseInt(fileLength);
            Log.i(TAG, "fileLength : "+videoLength);
            String framerate=retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_CAPTURE_FRAMERATE);
            Log.i(TAG,"frames rate is : "+framerate);
//            Log.i(TAG,retriever.extractMetadata(MediaMetadataRetriever.))
//            videoTime=Integer.parseInt(fileLength);
//            framsRate=Integer.parseInt(framerate);
        }else {
            Log.e(TAG,"file not exist");
        }
    }
    /**
     * 获取视频某一帧
     * @param timeMs 毫秒
     */
    public Bitmap decodeFrame(long timeMs){
//        if(retriever == null) return false;
        Bitmap bitmap = retriever.getFrameAtTime(timeMs * 1000, MediaMetadataRetriever.OPTION_CLOSEST);
//        if(bitmap == null) return false;
//        listener.getBitmap(bitmap, timeMs);
        return bitmap;
    }

    public void processImage(){
        int timeInterval=33;

//        Log.i(TAG,"1/framesRate is :"+timeInterval);
        for(int i=videoLength-360*timeInterval;i<videoLength;i=i+timeInterval){
            Bitmap nowImage=decodeFrame(i);
            Log.i(TAG,"frame number is :"+i);
            w = nowImage.getWidth();
            h = nowImage.getHeight();
//            int[] pix = new int[w * h];
            nowImage.getPixels(pix, 0, w, 0, 0, w, h);
//            Log.i(TAG,"pix is : "+pix.toString()+"-------"+pix[0]+"------"+pix[5]+"------"+pix[10]+"------"+pix[100]);
//            System.out.println(pix.toString());

            resultXYZ=OpenCVHelper.computeXYZ(pix,i);
            Log.i(TAG,"position is "+"x : "+resultXYZ[300]+"y : "+resultXYZ[301]+"z : "+resultXYZ[302]);

            mTextPicture.setText("process is over".toCharArray(),0,15);


        }
    }

}
