# Java基础与进阶
##线程池

```java
import java.util.Date;
import java.util.concurrent.*;

public class ThreadPoolDemo {
    private static final int CORE_POOL_SIZE = 5;
    private static final int MAX_POOL_SIZE = 10;
    private static final int QUEUE_CAPACITY = 100;
    private static final Long KEEP_ALIVE_TIME = 1L;

    private static ThreadPoolDemo instance = null;
    private ExecutorService executors;

    static {
        instance = new ThreadPoolDemo();
    }


    private ThreadPoolDemo() {
                executors = new ThreadPoolExecutor(
                CORE_POOL_SIZE,
                MAX_POOL_SIZE,
                KEEP_ALIVE_TIME,
                TimeUnit.SECONDS,
                new ArrayBlockingQueue<>(QUEUE_CAPACITY),
                new ThreadPoolExecutor.CallerRunsPolicy());
    }

    public void executeTask(Runnable task) {
        executors.execute(task);
    }

    public static ThreadPoolDemo getInstance() {
        return instance;
    }

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            ThreadPoolDemo.getInstance().executeTask(() -> {
                System.out.println(Thread.currentThread().getName() + " Start. Time = " + new Date());
                try {
                    Thread.sleep(5000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread().getName() + " End. Time = " + new Date());
            });
        }

    }
}
```
