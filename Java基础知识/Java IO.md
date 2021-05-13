# Java IO

##概念

Java IO 是一套Java用来读写数据（输入和输出）的API。大部分程序都要处理一些输入，并由输入产生一些输出。Java为此提供了java.io包

##磁盘操作：File

File 表示文件目录，但不表示文件内容，以下代码递归的展示一个目录下的所有文件
```java
    public static void main(String[] args) {
        listAllFiles(new File("/Users/gaohueric/Documents/SublimeWorkStation"));
    }

    public static void listAllFiles(File dir) {
        if (dir == null || !dir.exists()) {
            return;
        }
        if (dir.isFile()) {
            System.out.println(dir.getName());
            return;
        }
        for (File file : dir.listFiles()) {
            listAllFiles(file);
        }
    }
```

##字节操作
**文件拷贝的几种方式**
实现文件复制,读取一个文件写入另外一个文件，将字符转换为字节，再写入文件。
```java
    public static void main(String[] args) throws IOException {
        FileInputStream fileInputStream = new FileInputStream("/Users/gaohueric/Documents/known_hosts");
        FileOutputStream fileOutputStream = new FileOutputStream("/Users/gaohueric/Documents/new_known_hosts");

        byte[] buffer = new byte[20*1024];
        int cnt;
        while((cnt = fileInputStream.read(buffer,0,buffer.length)) != -1){
            fileOutputStream.write(buffer,0,cnt);
        }
        fileInputStream.close();
        fileOutputStream.close();
    }
```
结果输出到文件
```java
    public static void main(String[] args) throws IOException {
        FileOutputStream fileOutputStream = new FileOutputStream("/Users/gaohueric/Documents/test.txt");
        for(int i=0;i<100;i++){
            String message = "test\r\n";
            fileOutputStream.write(message.getBytes());
        }
    }
```

通过普通的缓冲输入输出流拷贝文件
```java
    public static void main(String[] args) throws IOException {
        InputStream in = null;
        OutputStream out = null;
        try {
            in = new BufferedInputStream(new FileInputStream("/Users/gaohueric/Documents/known_hosts"));
            out = new BufferedOutputStream(new FileOutputStream("/Users/gaohueric/Documents/new_test.txt"));
            byte[] buffer = new byte[2048];
            int i;
            while ((i = in.read(buffer)) != -1) {
                out.write(buffer, 0, i);
            }

        } catch (Exception e) {
            System.out.println(1);
        } finally {
            in.close();
            out.close();
        }
    }
```

通过文件管道的方式复制文件
```java
public static void main(String[] args) throws IOException {
    FileChannel in = new FileInputStream("/Users/gaohueric/Documents/known_hosts").getChannel();
    FileChannel out = new FileOutputStream("/Users/gaohueric/Documents/new_test.txt").getChannel();
    in.transferTo(0,in.size(),out);
}
```

通过管道方式复制文件比缓冲流快了三分之一


##字符操作
**String的编码方式**：编码与解码
```java
String str1 = "测试";
byte[] bytes = str1.getBytes("UTF-8");
String str2 = new String(bytes, "UTF-8");
System.out.println(str2);
```

**Reader 与 Writer**
从文件中读取字节流，转换为字符 输出
- InputStreamReader 实现从字节流解码成字符流；
- OutputStreamWriter 实现字符流编码成为字节流。

一下代码实现逐行输出文本文件的内容

```java
    public static void main(String[] args) throws IOException {
        FileReader fileReader = new FileReader("/Users/gaohueric/Documents/known_hosts");
        BufferedReader bufferedReader = new BufferedReader(fileReader);
        String line;
        while((line = bufferedReader.readLine()) != null){
            System.out.println(line);
        }
        bufferedReader.close();
        fileReader.close();
    }
```

##IO模型
Java中IO系统可以分为BIO，NIO，AIO三种IO模型

- BIO(blocking I/O) 同步阻塞IO BIO是同步阻塞IO，JDK1.4之前只有这一个IO模型，BIO操作的对象是流，一个线程只能处理一个流的IO请求，如果想要同时处理多个流就需要使用多线程
- NIO(Non-blocking I/O) 同步非阻塞IO,服务器实现模式为一个请求一个线程，即客户端发送的连接请求都会注册到多路复用器上，多路复用器轮询到连接有I/O请求时才启动一个线程进行处理。
- AIO(NIO.2) (Asynchronous I/O) 异步非阻塞，服务器实现模式为一个有效请求一个线程，客户端的I/O请求都是由OS先完成了再通知服务器应用去启动线程进行处理.







