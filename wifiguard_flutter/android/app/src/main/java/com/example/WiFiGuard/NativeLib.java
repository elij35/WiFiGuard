package com.example.WiFiGuard;

public class NativeLib {
    static {
        System.loadLibrary("native-lib"); // Matches the library name in CMake
    }

    public static native String getMacAddress(String ip);
}
