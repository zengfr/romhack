
package com.jingdong;
//固定参数-以京东sign逆向为例
import com.github.unidbg.AndroidEmulator;
import com.github.unidbg.Emulator;
import com.github.unidbg.Module;
import com.github.unidbg.hook.hookzz.*;
import com.github.unidbg.linux.android.AndroidEmulatorBuilder;
import com.github.unidbg.linux.android.AndroidResolver;
import com.github.unidbg.linux.android.dvm.*;
import com.github.unidbg.linux.android.dvm.array.ByteArray;
import com.github.unidbg.linux.android.dvm.jni.ProxyDvmObject;
import com.github.unidbg.linux.android.dvm.wrapper.DvmInteger;
import com.github.unidbg.memory.Memory;
import com.sun.jna.Pointer;
import sun.security.pkcs.PKCS7;
import sun.security.pkcs.ParsingException;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.security.cert.X509Certificate;

public class JingDong extends AbstractJni {
    private final AndroidEmulator emulator;
    private final VM vm;
    private final Module module;

    public static String pkgName = "com.jingdong.app.mall";
    public static String apkPath = "unidbg-android/src/test/java/com/jingdong/jingdong9.2.2.apk";
    public static String soPath = "unidbg-android/src/test/java/com/jingdong/libjdbitmapkit.so";
    private static final String APK_PATH = "/data/app/com.jingdong.app.mall.apk";

    JingDong() {
        emulator = AndroidEmulatorBuilder.for32Bit().setProcessName(pkgName).build();
        final Memory memory = emulator.getMemory();
        memory.setLibraryResolver(new AndroidResolver(23));
        vm = emulator.createDalvikVM(new File(apkPath));
        DalvikModule dm = vm.loadLibrary(new File(soPath), false);
        vm.setJni(this);
        vm.setVerbose(true);
        dm.callJNI_OnLoad(emulator);
        module = dm.getModule();
    }

    @Override
    public DvmObject<?> getStaticObjectField(BaseVM vm, DvmClass dvmClass, String signature) {
        switch (signature) {
            case "com/jingdong/common/utils/BitmapkitUtils->a:Landroid/app/Application;": {
                return vm.resolveClass("android/app/Activity", vm.resolveClass("android/content/ContextWrapper", vm.resolveClass("android/content/Context"))).newObject(null);
            }
        }
        return super.getStaticObjectField(vm, dvmClass, signature);
    }

    @Override
    public DvmObject<?> getObjectField(BaseVM vm, DvmObject<?> dvmObject, String signature) {
        switch (signature) {
            case "android/content/pm/ApplicationInfo->sourceDir:Ljava/lang/String;": {
                return new StringObject(vm, APK_PATH);
            }
        }
        return super.getObjectField(vm, dvmObject, signature);
    }

    @Override
    public DvmObject<?> callStaticObjectMethod(BaseVM vm, DvmClass dvmClass, String signature, VarArg varArg) {
        switch (signature) {
            case "com/jingdong/common/utils/BitmapkitZip->unZip(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)[B": {
                StringObject apkPath = varArg.getObjectArg(0);
                StringObject directory = varArg.getObjectArg(1);
                StringObject filename = varArg.getObjectArg(2);
                if (APK_PATH.equals(apkPath.getValue()) &&
                        "META-INF/".equals(directory.getValue()) &&
                        ".RSA".equals(filename.getValue())) {
                    byte[] data = vm.unzip("META-INF/JINGDONG.RSA");
                    return new ByteArray(vm, data);
                }
            }
            case "com/jingdong/common/utils/BitmapkitZip->objectToBytes(Ljava/lang/Object;)[B": {
                DvmObject<?> obj = varArg.getObjectArg(0);
                byte[] bytes = objectToBytes(obj.getValue());
                return new ByteArray(vm, bytes);
            }
        }
        return super.callStaticObjectMethod(vm ,dvmClass, signature, varArg);
    }

    @Override
    public DvmObject<?> newObject(BaseVM vm, DvmClass dvmClass, String signature, VarArg varArg) {
        switch (signature) {
            case "sun/security/pkcs/PKCS7-><init>([B)V": {
                ByteArray array = varArg.getObjectArg(0);
                try {
                    return vm.resolveClass("sun/security/pkcs/PKCS7").newObject(new PKCS7(array.getValue()));
                } catch (ParsingException e) {
                    throw new IllegalStateException(e);
                }
            }
        }
        return super.newObject(vm, dvmClass, signature, varArg);
    }

    @Override
    public DvmObject<?> callObjectMethod(BaseVM vm, DvmObject<?> dvmObject, String signature, VarArg varArg) {
        switch (signature) {
            case "sun/security/pkcs/PKCS7->getCertificates()[Ljava/security/cert/X509Certificate;": {
                PKCS7 pkcs7 = (PKCS7) dvmObject.getValue();
                X509Certificate[] certificates = pkcs7.getCertificates();
                return ProxyDvmObject.createObject(vm, certificates);
            }
        }
        return super.callObjectMethod(vm, dvmObject, signature, varArg);
    }

    @Override
    public DvmObject<?> newObjectV(BaseVM vm, DvmClass dvmClass, String signature, VaList vaList) {
        switch (signature) {
            case "java/lang/StringBuffer-><init>()V": {
                return vm.resolveClass("java/lang/StringBuffer").newObject(new StringBuffer());
            }
            case "java/lang/Integer-><init>(I)V": {
                return DvmInteger.valueOf(vm, vaList.getIntArg(0));
            }
        }
        return super.newObjectV(vm, dvmClass, signature, vaList);
    }

    @Override
    public DvmObject<?> callObjectMethodV(BaseVM vm, DvmObject<?> dvmObject, String signature, VaList vaList) {
        switch (signature) {
            case "java/lang/StringBuffer->append(Ljava/lang/String;)Ljava/lang/StringBuffer;": {
                StringBuffer buffer = (StringBuffer) dvmObject.getValue();
                StringObject str = vaList.getObjectArg(0);
                buffer.append(str.getValue());
                return dvmObject;
            }
            case "java/lang/Integer->toString()Ljava/lang/String;": {
                return new StringObject(vm, ((Integer)dvmObject.getValue()).toString());
            }
            case "java/lang/StringBuffer->toString()Ljava/lang/String;": {
                return new StringObject(vm, ((StringBuffer)dvmObject.getValue()).toString());
            }
        }
        return super.callObjectMethodV(vm, dvmObject, signature, vaList);
    }

    private static byte[] objectToBytes(Object obj) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ObjectOutputStream oos = new ObjectOutputStream(baos);
            oos.writeObject(obj);
            oos.flush();
            byte[] array = baos.toByteArray();
            oos.close();
            baos.close();
            return array;
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    public void hook_libc() {
        IHookZz hookZz = HookZz.getInstance(emulator);
        hookZz.wrap(module.findSymbolByName("lrand48"), new WrapCallback<HookZzArm32RegisterContext>() {
            @Override
            public void preCall(Emulator<?> emulator, HookZzArm32RegisterContext ctx, HookEntryInfo info) {
            }

            @Override
            public void postCall(Emulator<?> emulator, HookZzArm32RegisterContext ctx, HookEntryInfo info) {
                int old = ctx.getIntArg(0);
                System.out.println("Origin rand:" + old);
                ctx.setR0(1);
            }
        });

        hookZz.wrap(module.findSymbolByName("gettimeofday"), new WrapCallback<HookZzArm32RegisterContext>() {
            @Override
            public void preCall(Emulator<?> emulator, HookZzArm32RegisterContext ctx, HookEntryInfo info) {
                Pointer pointer = ctx.getR0Pointer();
                ctx.push(pointer);
            }

            @Override
            public void postCall(Emulator<?> emulator, HookZzArm32RegisterContext ctx, HookEntryInfo info) {
                Pointer pointer = ctx.pop();
                pointer.setLong(0, 1639388888);
                pointer.setLong(4, 0);
            }
        });
    }

    public void callSign() {
        DvmClass cBitmapkitUtils = vm.resolveClass("com/jingdong/common/utils/BitmapkitUtils");
        StringObject ret = cBitmapkitUtils.callStaticJniMethodObject(emulator, "getSignFromJni()(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;",
                vm.resolveClass("android/content/Context").newObject(null),
                "clientImage",
                "{\"moduleParams\":{\"18\":\"1565611060638\",\"19\":\"1565229712150\",\"25\":\"1567478504636\",\"27\":\"1602488415048\",\"28\":\"1631069159956\",\"30\":\"1567404005627\",\"32\":\"1567997588476\",\"34\":\"1593508185597\",\"35\":\"1568708316462\",\"37\":\"1630293538664\",\"42\":\"1623741761542\",\"44\":\"1569247647090\",\"46\":\"1588839806224\",\"47\":\"1571295610042\",\"61\":\"1582091758495\",\"70\":\"1585279774645\",\"74\":\"1586781606615\"}}",
                "d5a585639f505b18",
                "android",
                "10.2.0");
        System.out.println(ret.getValue());
    }

    public static void main(String[] args) {
        JingDong test = new JingDong();
        test.hook_libc();
        test.callSign();
    }
}