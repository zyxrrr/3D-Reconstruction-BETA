//
// Created by 朱袁旭 on 2017/5/14.
//

#include "com_alanjet_videorecordertest_OpenCVHelper.h"
#include <stdio.h>
#include <stdlib.h>
#include <opencv2/opencv.hpp>
#include <math.h>


using namespace cv;
using namespace std;
extern "C" {



JNIEXPORT jint JNICALL Java_com_alanjet_videorecordertest_OpenCVHelper_toAdd
        (JNIEnv *env, jclass type, jint param1, jint param2) {//具体实现
    return param1 + param2;
}


JNIEXPORT jdoubleArray JNICALL Java_com_alanjet_videorecordertest_OpenCVHelper_computeXYZ
        (JNIEnv *env, jclass obj, jintArray buf,jint offset);

JNIEXPORT jintArray JNICALL Java_com_alanjet_videorecordertest_OpenCVHelper_computeXYZtest
        (JNIEnv *env, jclass obj);


JNIEXPORT jdoubleArray JNICALL Java_com_alanjet_videorecordertest_OpenCVHelper_computeXYZ
        (JNIEnv *env, jclass obj, jintArray buf, jint offset){
    double rotAngle=(double)offset;
    const double pi=3.14;
    const double fc=574.860069576728280;
    int w=640;
    int h=480;
    int count=0;
    int sumInd=0;
    double offsetAngle=-(rotAngle)/360.0*pi;
    double ind=0,xDis=0,qChange=0;
    double sDis=0.2,sRotation=0.105,pixelSize=0.0000022,angle=82.0/180.0*pi,focal=fc*pixelSize,objY=0.5;
    double posX,posY,posZ;

    jint *cbuf;
    cbuf=env->GetIntArrayElements(buf,JNI_FALSE);
    if(NULL==cbuf){
        return 0;
    }
    Mat imgData(h,w,CV_8UC4, (unsigned char*)cbuf);
    vector<Mat> channels;
    split(imgData,channels);
    Mat binaryImg=channels[0];
    threshold(binaryImg,binaryImg,10,255,THRESH_OTSU);
    jdouble *ptr=new jdouble[480*3];
    for(int j=0;j<480;j++)
    {
        double surToSurAngle=atan( (-pixelSize*(j-240)) / focal);
        double focalTransform=focal/cos(surToSurAngle);
        sumInd=0;count=0;
        uchar* data=binaryImg.ptr<uchar>(j);
        for(int i=0;i<640;i++)
        {

            int temp=(int)data[i];
            if(255==temp && i>320)
            {
                sumInd+=i+1;//第i列代表加上i+1
                count++;
                //printf("position(x,y) is %d %d,the value of pixel is %d\n",j,i,temp);
            }


            //printf("the value of pixel is %d\n",temp);
        }
        if(0==count)
        {
            posX=0;
            posY=0;
            posZ=0;
        }
        else
        {
            ind=(double)sumInd/(double)count;
//            printf("the line is %d ,index is %lf\n",j,ind);
            xDis=(ind-320)*pixelSize+focalTransform/tan(angle);
            qChange=focalTransform*sDis/xDis;
//            printf("the distance is %lf\n",qChange);
            posY=qChange*cos(surToSurAngle);
            posZ=qChange*sin(surToSurAngle);
            posX=posY/tan(angle)-sRotation;
            posY=posY-objY;
            posX=posX*cos(offsetAngle)+posY*sin(offsetAngle);
            posY=posY*cos(offsetAngle)-posX*sin(offsetAngle);
//            printf("the position X Y Z is%lf %lf %lf\n",posX,posY,posZ);
        }
        ptr[j*3+0]=posX;
        ptr[j*3+1]=posY;
        ptr[j*3+2]=posZ;
    }
    jdoubleArray result = env->NewDoubleArray(3*480);
    env->SetDoubleArrayRegion(result,0,480*3,ptr);
    return result;

}

JNIEXPORT jintArray JNICALL Java_com_alanjet_videorecordertest_OpenCVHelper_computeXYZtest
        (JNIEnv *env, jclass obj){
    jintArray result = env->NewIntArray(3);
    jint *h=new jint[3];
    h[0]=(jint)0;
    h[1]=(jint)1;
    h[2]=(jint)2;
    env->SetIntArrayRegion(result,0,3,h);
    return result;
}


}