/**
 * Copyright 2016 Pulasthi Supun Wickramasinghe
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package edu.indiana.soic.spidal;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.*;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

/**
 * Created by pulasthi on 5/31/16.
 */
public class BinaryFormatConverter {
    private static ByteOrder endianness = ByteOrder.BIG_ENDIAN;
    private static int dataTypeSize = Short.BYTES;
    private static String outputfileType;
    public static void main(String[] args) {
        // args[2] takes values big or little for endianness
        // arg[3] takes one of the primitive type names in lower case
        String file = args[0];
        String outputfile = args[1];
        endianness =  args[2].equals("big") ? ByteOrder.BIG_ENDIAN : ByteOrder.LITTLE_ENDIAN;
        outputfileType = args[4];
        String txtoutputfile = outputfile.substring(0,outputfile.lastIndexOf(".")) + ".txt";
        if(outputfileType.equals("txt")){
            BinaryToTxtConverter(file,txtoutputfile,endianness,args[3],2);
        }else{
            ConvertFormat(file,outputfile,endianness,args[3]);
        }
    }

    private static void ConvertFormat(String filename, String outputfilename, ByteOrder endianness, String dataType) {
        System.out.println("Converting Endianness");
        try(FileChannel fc = (FileChannel) Files
                .newByteChannel(Paths.get(filename), StandardOpenOption.READ)) {
            ByteBuffer byteBuffer = ByteBuffer.allocate((int)fc.size());

            if(endianness.equals(ByteOrder.BIG_ENDIAN)){
                byteBuffer.order(ByteOrder.BIG_ENDIAN);
            }else{
                byteBuffer.order(ByteOrder.LITTLE_ENDIAN);
            }
            fc.read(byteBuffer);
            byteBuffer.flip();

            Buffer buffer;
            switch (dataType){
                case "short":
                    buffer = byteBuffer.asShortBuffer();
                    short[] shortArray = new short[(int)fc.size()/2];
                    ((ShortBuffer)buffer).get(shortArray);
                    byteBuffer.clear();
                    byteBuffer = endianness.equals(ByteOrder.BIG_ENDIAN) ? byteBuffer.order(ByteOrder.LITTLE_ENDIAN) :
                            byteBuffer.order(ByteOrder.BIG_ENDIAN);
                    ShortBuffer shortOutputBuffer = byteBuffer.asShortBuffer();
                    shortOutputBuffer.put(shortArray);
                    break;
                case "int":
                    buffer = byteBuffer.asIntBuffer();
                    int[] intArray = new int[(int)fc.size()/4];
                    ((IntBuffer)buffer).get(intArray);
                    byteBuffer.clear();
                    byteBuffer = endianness.equals(ByteOrder.BIG_ENDIAN) ? byteBuffer.order(ByteOrder.LITTLE_ENDIAN) :
                            byteBuffer.order(ByteOrder.BIG_ENDIAN);
                    IntBuffer intOutputBuffer = byteBuffer.asIntBuffer();
                    intOutputBuffer.put(intArray);
                    break;
                case "double":
                    buffer = byteBuffer.asDoubleBuffer();
                    double[] doubleArray = new double[(int)fc.size()/8];
                    ((DoubleBuffer)buffer).get(doubleArray);
                    byteBuffer.clear();
                    byteBuffer = endianness.equals(ByteOrder.BIG_ENDIAN) ? byteBuffer.order(ByteOrder.LITTLE_ENDIAN) :
                            byteBuffer.order(ByteOrder.BIG_ENDIAN);
                    DoubleBuffer doubleOutputBuffer = byteBuffer.asDoubleBuffer();
                    doubleOutputBuffer.put(doubleArray);
                    break;
                case "long":
                    buffer = byteBuffer.asLongBuffer();
                    long[] longArray = new long[(int)fc.size()/8];
                    ((LongBuffer)buffer).get(longArray);
                    byteBuffer.clear();
                    byteBuffer = endianness.equals(ByteOrder.BIG_ENDIAN) ? byteBuffer.order(ByteOrder.LITTLE_ENDIAN) :
                            byteBuffer.order(ByteOrder.BIG_ENDIAN);
                    LongBuffer longOutputBuffer = byteBuffer.asLongBuffer();
                   longOutputBuffer.put(longArray);
                    break;
                case "float":
                    buffer = byteBuffer.asFloatBuffer();
                    float[] floatArray = new float[(int)fc.size()/4];
                    ((FloatBuffer)buffer).get(floatArray);
                    byteBuffer.clear();
                    byteBuffer = endianness.equals(ByteOrder.BIG_ENDIAN) ? byteBuffer.order(ByteOrder.LITTLE_ENDIAN) :
                            byteBuffer.order(ByteOrder.BIG_ENDIAN);
                    FloatBuffer floatOutputBuffer = byteBuffer.asFloatBuffer();
                    floatOutputBuffer.put(floatArray);
                    break;
                case "byte":
                    byteBuffer = endianness.equals(ByteOrder.BIG_ENDIAN) ? byteBuffer.order(ByteOrder.LITTLE_ENDIAN) :
                        byteBuffer.order(ByteOrder.BIG_ENDIAN);
                    break;
            }

            FileChannel out = new FileOutputStream(outputfilename).getChannel();
            out.write(byteBuffer);
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void BinaryToTxtConverter(String filename, String outputfilename,ByteOrder endianness, String dataType, int dimension){
        System.out.println("Converting Binary file to txt");

        try(FileChannel fc = (FileChannel) Files
                .newByteChannel(Paths.get(filename), StandardOpenOption.READ)) {
            ByteBuffer byteBuffer = ByteBuffer.allocate((int)fc.size());

            if(endianness.equals(ByteOrder.BIG_ENDIAN)){
                byteBuffer.order(ByteOrder.BIG_ENDIAN);
            }else{
                byteBuffer.order(ByteOrder.LITTLE_ENDIAN);
            }
            fc.read(byteBuffer);
            byteBuffer.flip();

            Buffer buffer;

            PrintWriter printWriter = new PrintWriter(Files.newBufferedWriter(Paths.get(outputfilename)));
            switch (dataType){
                case "short":
                    buffer = byteBuffer.asShortBuffer();
                    short[] shortArray = new short[(int)fc.size()/2];
                    ((ShortBuffer)buffer).get(shortArray);
                    for (int i = 0; i < shortArray.length; i++) {
                        String line = "";
                        i--;
                        for (int j = 0; j < dimension; j++) {
                            i++;
                            line += shortArray[i];
                            line += (j == (dimension - 1)) ? "" : "\t";
                        }
                        printWriter.println(line);
                    }
                    break;
                case "int":
                    buffer = byteBuffer.asIntBuffer();
                    int[] intArray = new int[(int)fc.size()/4];
                    ((IntBuffer)buffer).get(intArray);
                    break;
                case "double":
                    buffer = byteBuffer.asDoubleBuffer();
                    double[] doubleArray = new double[(int)fc.size()/8];
                    ((DoubleBuffer)buffer).get(doubleArray);
                    for (int i = 0; i < doubleArray.length; i++) {
                        String line = "";
                        i--;
                        for (int j = 0; j < dimension; j++) {
                            i++;
                            line += doubleArray[i];
                            line += (j == (dimension - 1)) ? "" : "\t";
                        }
                        printWriter.println(line);
                    }
                    break;
                case "long":
                    buffer = byteBuffer.asLongBuffer();
                    long[] longArray = new long[(int)fc.size()/8];
                    ((LongBuffer)buffer).get(longArray);
                    break;
                case "float":
                    buffer = byteBuffer.asFloatBuffer();
                    float[] floatArray = new float[(int)fc.size()/4];
                    ((FloatBuffer)buffer).get(floatArray);
                    break;
            }

            printWriter.flush();
            printWriter.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}