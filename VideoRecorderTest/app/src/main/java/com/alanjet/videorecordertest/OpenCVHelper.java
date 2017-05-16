package com.alanjet.videorecordertest;

/**
 * Created by 朱袁旭 on 2017/5/8.
 */

public class OpenCVHelper {
    static {
        System.loadLibrary("OpenCV");
    }

    public static native double[] computeXYZ(int[] buf, int offset);
    public static native int[] computeXYZtest();
    public static native int toAdd(int param1,int param2);

}
