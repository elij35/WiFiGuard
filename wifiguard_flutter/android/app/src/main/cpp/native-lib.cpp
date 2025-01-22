#include <jni.h>
#include <string>
#include <fstream>

#define LOG_TAG "NativeLib"

using namespace std;

extern "C" JNIEXPORT jstring

JNICALL
Java_com_example_WiFiGuard_NativeLib_getMacAddress(JNIEnv *env, jobject, jstring ip) {
    const char *ipAddr = env->GetStringUTFChars(ip, nullptr);
    string result = "";

    ifstream in("/proc/net/arp");
    if (!in) return env->NewStringUTF(result.c_str());

    string line;
    while (getline(in, line)) {
        if (line.find(ipAddr) != string::npos) {
            size_t pos = line.find(":");
            if (pos != string::npos)
                result = line.substr(pos - 2, 17);
        }
    }

    env->ReleaseStringUTFChars(ip, ipAddr);
    return env->NewStringUTF(result.c_str());
}
