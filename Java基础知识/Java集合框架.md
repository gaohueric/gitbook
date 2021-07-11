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
**方法二** CopyOnWriteArrayList
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

Hashtable、HashMap、TreeMap 都是最常见的一些 Map 实现，是以键值对的形式存储和操作数据的容器类型。

Hashtable 是早期 Java 类库提供的一个哈希表实现，本身是同步的，不支持 null 键和值，由于同步导致的性能开销，所以已经很少被推荐使用。

HashMap 是应用更加广泛的哈希表实现，行为上大致上与 HashTable 一致，主要区别在于 HashMap 不是同步的，支持 null 键和值等。通常情况下，HashMap 进行 put 或者 get 操作，可以达到常数时间的性能，所以它是绝大部分利用键值对存取场景的首选，比如，实现一个用户 ID 和用户信息对应的运行时存储结构。

TreeMap 则是基于红黑树的一种提供顺序访问的 Map，和 HashMap 不同，它的 get、put、remove 之类操作都是 O（log(n)）的时间复杂度，具体顺序可以由指定的 Comparator 来决定，或者根据键的自然顺序来判断。

##如何保证集合是线程安全的? ConcurrentHashMap如何实现高效地线程安全？

Java提供了不同层面的线程安全支持，除了HashTable同步容器，还提供了同步包容器（Synchronized Wrapper),我们可以调用 Collections 工具类提供的包装方法，来获取一个同步的包装容器（如 Collections.synchronizedMap）,调用Collections.synchronizedList(new ArrayList<>())实现线程安全的list.但这种方法是非常粗粒度的同步方式，高并发下性能不高.

普通选择利用并发包下提供的线程安全容器类，性能更高。

- 各种并发容器， 比如 ConcurrentHashMap、CopyOnWriteArrayList。
- 各种线程安全队列（Queue/Deque），如 ArrayBlockingQueue、SynchronousQueue。

##  如何正确的将数组转换为ArrayList?

```
List list = new ArrayList<>(Arrays.asList("a", "b", "c"))
```

java8
```
Integer [] myArray = { 1, 2, 3 };
List myList = Arrays.stream(myArray).collect(Collectors.toList());
//基本类型也可以实现转换（依赖boxed的装箱操作）
int [] myArray2 = { 1, 2, 3 };
List myList = Arrays.stream(myArray2).boxed().collect(Collectors.toList());
```

使用 Apache Commons Collections

```
List<String> list = new ArrayList<String>();
CollectionUtils.addAll(list, str);
```

使用 Java9 的 List.of()方法

```
Integer[] array = {1, 2, 3};
List<Integer> list = List.of(array);
System.out.println(list); /* [1, 2, 3] */
```

Collection.toArray()方法使用的坑&如何反转数组

```
String [] s= new String[]{
    "dog", "lazy", "a", "over", "jumps", "fox", "brown", "quick", "A"
};
List<String> list = Arrays.asList(s);
Collections.reverse(list);
s=list.toArray(new String[0]);//没有指定类型的话会报错
```




















