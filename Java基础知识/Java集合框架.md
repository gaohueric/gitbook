# Java集合框架

##对比 Vector、ArrayList、LinkedList 有何区别？

Vector 是 Java 早期提供的线程安全的动态数组，Vector 内部是使用对象数组来保存数据，可以根据需要自动的增加容量，当数组已满时，会创建新的数组，并拷贝原有数组数据。
Vector 在扩容时会提高 1 倍，比如当前容量为10，扩容后变成20，而 ArrayList 则是增加 50%

ArrayList 是应用更加广泛的动态数组实现，它本身不是线程安全的，ArrayList 也是可以根据需要调整容量，扩容增加50%。
Vector 与ArrayList 作为动态数据，内部元素以数组形式顺序存储的，所以非常适合随机访问的场合。

LinkedList 是基于双向链表实现的 进行节点插入、删除却要高效得多，但是随机访问性能则要比动态数组慢。

**集合框架**

![](https://static001.geekbang.org/resource/image/67/c7/675536edf1563b11ab7ead0def1215c7.png)

- List，也就是我们前面介绍最多的有序集合，它提供了方便的访问、插入、删除等操作

- Set，Set 是不允许重复元素的，这是和 List 最明显的区别，也就是不存在两个对象 equals 返回 true。我们在日常开发中有很多需要保证元素唯一性的场合

- Queue/Deque，则是 Java 提供的标准队列结构的实现，除了集合的基本功能，它还支持类似先入先出（FIFO， First-in-First-Out）或者后入先出（LIFO，Last-In-First-Out）等特定行为。这里不包括 BlockingQueue，因为通常是并发编程场合，所以被放置在并发包里。

##ArrayList 不是线程安全的，如何实现线程安全的ArrayList？

**方法一** ：同步的ArrayList方法
它的实现，基本就是将每个基本方法，比如 get、set、add 之类，都通过 synchronizd 添加基本的同步支持
```java
  List<Integer> objects = Collections.synchronizedList(new ArrayList<>());

```
** 方法二** CopyOnWriteArrayList
```java
  CopyOnWriteArrayList<Integer> copyOnWriteArrayList = new CopyOnWriteArrayList<>();
```
两种方法的区别：
CopyOnWriteArrayList的写操作性能较差，而多线程的读操作性能较好。而Collections.synchronizedList的写操作性能比CopyOnWriteArrayList在多线程操作的情况下要好很多，而读操作因为是采用了synchronized关键字的方式，其读操作性能并不如CopyOnWriteArrayList。
CopyOnWriteArrayList适合读多写少的场景，Collections.synchronizedList适合读写比较均衡的场景，Collections.synchronizedList性能较均衡。

##数组默认排序方式与设计思路

**数组排序方式**

```java
//数组排序
Arrays.sort(new int[]{1,5,4});

//List 排序
List<Integer> list = new ArrayList<>();
Collections.sort(list);
```
Collections.sort() 底层是调用 Arrays.sort()

- 对于原始数据类型，目前使用的是所谓双轴快速排序（Dual-Pivot QuickSort），是一种改进的快速排序算法，早期版本是相对传统的快速排序，你可以阅读源码。

- 而对于对象数据类型，目前则是使用TimSort，思想上也是一种归并和二分插入排序（binarySort）结合的优化排序算法。TimSort 并不是 Java 的独创，简单说它的思路是查找数据集中已经排好序的分区（这里叫 run），然后合并这些分区来达到排序的目的。


## 对比 Hashtable、HashMap、TreeMap 有什么不同？












