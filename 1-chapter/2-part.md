<!-- toc -->
#### HashMap解读

##### 概念： 什么是HashMap

> 基于哈希表的Map接口实现.此实现提供所有可选的映射操作,并允许使用null值和null键.除了非同步和允许使用null外,HashMap 类与HashTable 大致相同,此类不保证映射的顺序,特别是它不保证该顺序亘久不变,此实现假定哈希函数将元素适当地分布在各桶之间,可为基本操作（get 和 put）提供稳定的性能.迭代 collection 视图所需的时间与 HashMap 实例的“容量”（桶的数量）及其大小（键-值映射关系数）成比例.所以,如果迭代性能很重要,则不要将初始容量设置得太高（或将加载因子设置得太低）.

<!--more-->

##### HashMap和HashTable的区别

> - **HashTable的方法是同步的**，在方法的前面都有synchronized来同步，**HashMap未经同步**，所以在多线程场合要手动同步
> - **HashTable不允许null值**(key和value都不可以) ,**HashMap允许null值**(key和value都可以)。
> - HashTable有一个contains(Object value)功能和containsValue(Object value)功能一样。
> - HashTable使用Enumeration进行遍历，HashMap使用Iterator进行遍历。
> - HashTable中hash数组默认大小是11，增加的方式是 old*2+1。HashMap中hash数组的默认大小是16，而且一定是2的指数。
> - 哈希值的使用不同，HashTable直接使用对象的hashCode，代码是这样的：

```java
int hash = key.hashCode();
int index = (hash & 0x7FFFFFFF) % tab.length;
```

而 HashMap 重新计算hash值，而且用与代替求模

```java
  static final int hash(Object key) {
        int h;
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }
```

##### HashMap 和HashSet 的关系

> - HashSet底层采用HashMap实现的
>
> - ```java
>   public HashSet() {
>         map = new HashMap<>();
>     }
>   ```
>
>   ```
>
>   ```
>
> - 调用HashSet的add方法时，实际上是向HashMap中增加了一行(key-value对)，该行的key就是向HashSet增加的那个对象，该行的value就是一个Object类型的常量
>
>   ```java
>   private static final Object PRESENT = new Object();
>   public boolean add(E e) {
>       return map.put(e, PRESENT)==null;
>   }
>   public boolean remove(Object o) {
>       return map.remove(o)==PRESENT;
>   }
>   ```



##### HashMap 和ConcurrentHashMap的关系

> `ConcurrentHashMap` 也是一种线程安全的集合类，他和`HashTable`也是有区别的，主要区别就是加锁的粒度以及如何加锁，`ConcurrentHashMap`的加锁粒度要比`HashTable`更细一点。将数据分成一段一段的存储，然后给每一段数据配一把锁，当一个线程占用锁访问其中一个段数据的时候，其他段的数据也能被其他线程访问, 下面篇幅介绍。



#### HashMap实现原理分析

##### 底层原理分析

> 底层实现的一种数据结构——Hash 表

Hash表，是根据关键码值(Key value)而直接进行访问的数据结构。也就是说，它通过把关键码值映射到表中一个位置来访问记录，以加快查找的速度。存放记录的数组叫做哈希表。

在HashMap中，就是将所给的“键”通过哈希函数得到“索引”，然后把内容存在数组中，这样就形成了“键”和内容的映射关系。

![](https://github.com/gaohueric/blogpicture/raw/master/map6.png)



“键”转为“索引”的过程就是哈希函数，为了尽可能保证每一个“键”通过哈希函数的转换对应不同的“索引”，就需要对哈希函数进行选择了，使其得到的“索引”分布越均匀越好。

![](https://github.com/gaohueric/blogpicture/raw/master/map7.png)

通过研究加上实践表明，当把哈希函数得到hashcode值对素数取模时，这样得到的索引是最为均匀的。但是，在HashMap源码中，并不是取模素数的，而是一种等效取模2的n次方的位运算，hash&(length-1)。hash%length==hash&(length-1)的前提是length是2的n次方；之所以使用位运算替代取模，是因为位运算的效率更高，所以也就要求数组的长度必须是2的n次方（索引的分布也是很均匀的）。

哈希函数的设计：

![](https://github.com/gaohueric/blogpicture/raw/master/map8.png)

哈希函数的一致性原则是：当两个对象的equals相等，那么他们的hashcode一定相等。

这就要求我们在重写了equals方法时，必须重写hashcode方法。如果不重写hashcode，则会使用Object的hashcode方法，该方法是以我们创建的对象的地址作为参数求hash的。所以，如果不重写hashcode，两个equals相等的对象会导致hashcode不同（因为不同的对象），这个是不允许的，因为违背了hash函数的一致性原则。

**哈希冲突：**

当两个不同的元素，通过哈希函数得到了同一个hashcode，则会产生哈希冲突。HashMap的处理方式是，JDK8之前，每一个位置对应一个链表，链式的存放哈希冲突的元素；JDK8开始，当哈希冲突达到一定程度（8个），每一个位置从链表转换成红黑树。因为红黑树的时间复杂度是O(log n)的，效率优于链表。

![](https://github.com/gaohueric/blogpicture/raw/master/map9.png)

**哈希表小结：**

哈希表，均摊复杂度是O(1)，因为第一步通过数组索引找到数组位置是O(1)，然后到链表中查找元素的均摊复杂度是O(size/length)，size为元素个数，length为数组长度。由于Hash表的容量是动态扩容的，也就是说随着size和length成正比的，即size/length是一个常数，于是也是O(1)的复杂度，即总的来说，均摊复杂度是O(1)。但是哈希表是没有顺序性的，即无法对元素进行排序。

![](https://github.com/gaohueric/blogpicture/raw/master/map10.png)

##### 底层数据结构分析

> 基于JDK1.7分析HashMap

JDk1.8之前HashMap底层是数据和链表结合在一起使用，也就是链表散列。HashMap 通过 key的hashCode经过扰动函数处理过后得到hash值，然后通过(n-1) & hash 判断当前元素存放的位置(n指数组的长度) 如果当前位置存在元素的话，就判断该元素和要插入的元素的hash值已经key是否相同，如果相同的话，直接覆盖，不相同就通过拉链法解决冲突。

**所谓扰动函数指的就是 HashMap 的 hash 方法。使用 hash 方法也就是扰动函数是为了防止一些实现比较差的 hashCode() 方法 换句话说使用扰动函数之后可以减少碰撞。**

**JDK 1.8 HashMap 的 hash 方法源码:**

JDK 1.8 的 hash方法 相比于 JDK 1.7 hash 方法更加简化，但是原理不变。

```java
    static final int hash(Object key) {
      int h;
      // key.hashCode()：返回散列值也就是hashcode
      // ^ ：按位异或
      // >>>:无符号右移，忽略符号位，空位都以0补齐
      return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
  }
```

对比一下 JDK1.7的 HashMap 的 hash 方法源码.

```java
static int hash(int h) {
    // This function ensures that hashCodes that differ only by
    // constant multiples at each bit position have a bounded
    // number of collisions (approximately 8 at default load factor).

    h ^= (h >>> 20) ^ (h >>> 12);
    return h ^ (h >>> 7) ^ (h >>> 4);
}
```

相比于 JDK1.8 的 hash 方法 ，JDK 1.7 的 hash 方法的性能会稍差一点点，因为毕竟扰动了 4 次。

所谓 **“拉链法”** 就是：将链表和数组相结合。也就是说创建一个链表数组，数组中每一格就是一个链表。若遇到哈希冲突，则将冲突的值加到链表中即可。

![](https://github.com/gaohueric/blogpicture/raw/master/map3.png)

> 基于JDK1.7分析HashMap

相比于之前的版本，jdk1.8在解决哈希冲突时有了较大的变化，当链表长度大于阈值（默认为8）时，将链表转化为红黑树，以减少搜索时间。

![](https://github.com/gaohueric/blogpicture/raw/master/map11.png)





源码解读

类属性

```java
public class HashMap<K,V> extends AbstractMap<K,V> implements Map<K,V>, Cloneable, Serializable {
    // 序列号
    private static final long serialVersionUID = 362498820763181265L;
    // 默认的初始容量是16
    static final int DEFAULT_INITIAL_CAPACITY = 1 << 4;
    // 最大容量
    static final int MAXIMUM_CAPACITY = 1 << 30;
    // 默认的填充因子
    static final float DEFAULT_LOAD_FACTOR = 0.75f;
    // 当桶(bucket)上的结点数大于这个值时会转成红黑树
    static final int TREEIFY_THRESHOLD = 8;
    // 当桶(bucket)上的结点数小于这个值时树转链表
    static final int UNTREEIFY_THRESHOLD = 6;
    // 桶中结构转化为红黑树对应的table的最小大小
    static final int MIN_TREEIFY_CAPACITY = 64;
    // 存储元素的数组，总是2的幂次倍
    transient Node<k,v>[] table;
    // 存放具体元素的集
    transient Set<map.entry<k,v>> entrySet;
    // 存放元素的个数，注意这个不等于数组的长度。
    transient int size;
    // 每次扩容和更改map结构的计数器
    transient int modCount;
    // 临界值 当实际大小(容量*填充因子)超过临界值时，会进行扩容
    int threshold;
    // 填充因子
    final float loadFactor;
}
```

- **loadFactor加载因子**

loadFactor 加载因子是控制数组存放数据的疏密程度，loadFactor越趋近于1，那么数组中存放的数据(entry) 也就越多，也就越密集，也就是会让链表的长度增加，loadFactor 越小，也就是越趋近于0

loadFactor 太大导致查找元素效率低，太小导致数组利用率低，存放的数据会很分散。loadFactor的默认值为0.75是官方给出的一个比较好的临近值。

- **threshold**

threshold  = capacity * loadFactor,当Size>threshold 的时候，那么就要考虑对数组的扩容了，也就是说，这个是衡量数组是否需要扩容的一个标准。



Node节点源码

```java
static class Node<K,V> implements Map.Entry<K,V> {
       final int hash;// 哈希值，存放元素到hashmap中时用来与其他元素hash值比较
       final K key;//键
       V value;//值
       // 指向下一个节点
       Node<K,V> next;
       Node(int hash, K key, V value, Node<K,V> next) {
            this.hash = hash;
            this.key = key;
            this.value = value;
            this.next = next;
        }
        public final K getKey()        { return key; }
        public final V getValue()      { return value; }
        public final String toString() { return key + "=" + value; }
        // 重写hashCode()方法
        public final int hashCode() {
            return Objects.hashCode(key) ^ Objects.hashCode(value);
        }

        public final V setValue(V newValue) {
            V oldValue = value;
            value = newValue;
            return oldValue;
        }
        // 重写 equals() 方法
        public final boolean equals(Object o) {
            if (o == this)
                return true;
            if (o instanceof Map.Entry) {
                Map.Entry<?,?> e = (Map.Entry<?,?>)o;
                if (Objects.equals(key, e.getKey()) &&
                    Objects.equals(value, e.getValue()))
                    return true;
            }
            return false;
        }
}
```

树节点源码

```java
static final class TreeNode<K,V> extends LinkedHashMap.Entry<K,V> {
        TreeNode<K,V> parent;  // 父
        TreeNode<K,V> left;    // 左
        TreeNode<K,V> right;   // 右
        TreeNode<K,V> prev;    // needed to unlink next upon deletion
        boolean red;           // 判断颜色
        TreeNode(int hash, K key, V val, Node<K,V> next) {
            super(hash, key, val, next);
        }
        // 返回根节点
        final TreeNode<K,V> root() {
            for (TreeNode<K,V> r = this, p;;) {
                if ((p = r.parent) == null)
                    return r;
                r = p;
       }
```



```java
//默认构造函数
public HashMap() {
        this.loadFactor = DEFAULT_LOAD_FACTOR; // all other fields defaulted
    }
//包含另外一个map
public HashMap(Map<? extends K, ? extends V> m) {
        this.loadFactor = DEFAULT_LOAD_FACTOR;
        putMapEntries(m, false);
    }
//指定容量大小
public HashMap(int initialCapacity) {
        this(initialCapacity, DEFAULT_LOAD_FACTOR);
    }
// 指定“容量大小”和“加载因子”的构造函数
public HashMap(int initialCapacity, float loadFactor) {
        if (initialCapacity < 0)
            throw new IllegalArgumentException("Illegal initial capacity: " +
                                               initialCapacity);
        if (initialCapacity > MAXIMUM_CAPACITY)
            initialCapacity = MAXIMUM_CAPACITY;
        if (loadFactor <= 0 || Float.isNaN(loadFactor))
            throw new IllegalArgumentException("Illegal load factor: " +
                                               loadFactor);
        this.loadFactor = loadFactor;
        this.threshold = tableSizeFor(initialCapacity);
    }
//putMapEntries 方法
  final void putMapEntries(Map<? extends K, ? extends V> m, boolean evict) {
        int s = m.size();
        if (s > 0) {
            if (table == null) { // pre-size
                float ft = ((float)s / loadFactor) + 1.0F;
                int t = ((ft < (float)MAXIMUM_CAPACITY) ?
                         (int)ft : MAXIMUM_CAPACITY);
                if (t > threshold)
                    threshold = tableSizeFor(t);
            }
            else if (s > threshold)
                resize();
            for (Map.Entry<? extends K, ? extends V> e : m.entrySet()) {
                K key = e.getKey();
                V value = e.getValue();
                putVal(hash(key), key, value, false, evict);
            }
        }
    }
```

##### put方法

HashMap只提供了put用于添加元素，putVal方法只是给put方法调用的一个方法，并没有提供给用户使用。

源码:

```java
public V put(K key, V value) {
    return putVal(hash(key), key, value, false, true);
}

final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
    Node<K,V>[] tab; Node<K,V> p; int n, i;
    // table未初始化或者长度为0，进行扩容
    if ((tab = table) == null || (n = tab.length) == 0)
        n = (tab = resize()).length;
    // (n - 1) & hash 确定元素存放在哪个桶中，桶为空，新生成结点放入桶中(此时，这个结点是放在数组中)
    if ((p = tab[i = (n - 1) & hash]) == null)
        tab[i] = newNode(hash, key, value, null);
    // 桶中已经存在元素
    else {
        Node<K,V> e; K k;
        // 比较桶中第一个元素(数组中的结点)的hash值相等，key相等
        if (p.hash == hash &&
            ((k = p.key) == key || (key != null && key.equals(k))))
                // 将第一个元素赋值给e，用e来记录
                e = p;
        // hash值不相等，即key不相等；为红黑树结点
        else if (p instanceof TreeNode)
            // 放入树中
            e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
        // 为链表结点
        else {
            // 在链表最末插入结点
            for (int binCount = 0; ; ++binCount) {
                // 到达链表的尾部
                if ((e = p.next) == null) {
                    // 在尾部插入新结点
                    p.next = newNode(hash, key, value, null);
                    // 结点数量达到阈值，转化为红黑树
                    if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                        treeifyBin(tab, hash);
                    // 跳出循环
                    break;
                }
                // 判断链表中结点的key值与插入的元素的key值是否相等
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k))))
                    // 相等，跳出循环
                    break;
                // 用于遍历桶中的链表，与前面的e = p.next组合，可以遍历链表
                p = e;
            }
        }
        // 表示在桶中找到key值、hash值与插入元素相等的结点
        if (e != null) {
            // 记录e的value
            V oldValue = e.value;
            // onlyIfAbsent为false或者旧值为null
            if (!onlyIfAbsent || oldValue == null)
                //用新值替换旧值
                e.value = value;
            // 访问后回调
            afterNodeAccess(e);
            // 返回旧值
            return oldValue;
        }
    }
    // 结构性修改
    ++modCount;
    // 实际大小大于阈值则扩容
    if (++size > threshold)
        resize();
    // 插入后回调
    afterNodeInsertion(evict);
    return null;
}
```

**对putVal方法添加元素的分析如下：**

HashMap 只提供了put用于添加元素，putVal 方法只是给put方法调用的一个方法，并没有提供给用户使用。

- 如果定位的数组位置没有元素，则直接插入。
- 如果定位到的数组位置有元素就要和要插入的key比较，如果key相同就直接覆盖，如果key不相同，就判断p是否是一个树节点，如果是就调用`e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value)`将元素添加,如果不是就遍历链表插入。



![](https://raw.githubusercontent.com/gaohueric/blogpicture/master/map1.png)



对比JDK1.7 put方法源码

分析源码

- 如果定位到的数组位置没有元素就直接插入
- 如果定位到的数组位置有元素，遍历以这个元素为头节点的链表，依次和插入的key比较，如果key相同就直接覆盖，不同就采用头插入法插入元素。

```java
public V put(K key, V value)
    if (table == EMPTY_TABLE) {
    inflateTable(threshold);
}
    if (key == null)
        return putForNullKey(value);
    int hash = hash(key);
    int i = indexFor(hash, table.length);
    for (Entry<K,V> e = table[i]; e != null; e = e.next) { // 先遍历
        Object k;
        if (e.hash == hash && ((k = e.key) == key || key.equals(k))) {
            V oldValue = e.value;
            e.value = value;
            e.recordAccess(this);
            return oldValue;
        }
    }

    modCount++;
    addEntry(hash, key, value, i);  // 再插入
    return null;
}
```



##### get 方法

```java
public V get(Object key) {
    Node<K,V> e;
    return (e = getNode(hash(key), key)) == null ? null : e.value;
}

final Node<K,V> getNode(int hash, Object key) {
    Node<K,V>[] tab; Node<K,V> first, e; int n; K k;
    if ((tab = table) != null && (n = tab.length) > 0 &&
        (first = tab[(n - 1) & hash]) != null) {
        // 数组元素相等
        if (first.hash == hash && // always check first node
            ((k = first.key) == key || (key != null && key.equals(k))))
            return first;
        // 桶中不止一个节点
        if ((e = first.next) != null) {
            // 在树中get
            if (first instanceof TreeNode)
                return ((TreeNode<K,V>)first).getTreeNode(hash, key);
            // 在链表中get
            do {
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k))))
                    return e;
            } while ((e = e.next) != null);
        }
    }
    return null;
}
```

##### resize方法

进行扩容，会伴随着一次重新hash分配，并且会遍历hash表中所有的元素，是非常耗时的。在编写程序中，要尽量避免resize。

```java
final Node<K,V>[] resize() {
    Node<K,V>[] oldTab = table;
    int oldCap = (oldTab == null) ? 0 : oldTab.length;
    int oldThr = threshold;
    int newCap, newThr = 0;
    if (oldCap > 0) {
        // 超过最大值就不再扩充了，就只好随你碰撞去吧
        if (oldCap >= MAXIMUM_CAPACITY) {
            threshold = Integer.MAX_VALUE;
            return oldTab;
        }
        // 没超过最大值，就扩充为原来的2倍
        else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY && oldCap >= DEFAULT_INITIAL_CAPACITY)
            newThr = oldThr << 1; // double threshold
    }
    else if (oldThr > 0) // initial capacity was placed in threshold
        newCap = oldThr;
    else {
        signifies using defaults
        newCap = DEFAULT_INITIAL_CAPACITY;
        newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
    }
    // 计算新的resize上限
    if (newThr == 0) {
        float ft = (float)newCap * loadFactor;
        newThr = (newCap < MAXIMUM_CAPACITY && ft < (float)MAXIMUM_CAPACITY ? (int)ft : Integer.MAX_VALUE);
    }
    threshold = newThr;
    @SuppressWarnings({"rawtypes","unchecked"})
        Node<K,V>[] newTab = (Node<K,V>[])new Node[newCap];
    table = newTab;
    if (oldTab != null) {
        // 把每个bucket都移动到新的buckets中
        for (int j = 0; j < oldCap; ++j) {
            Node<K,V> e;
            if ((e = oldTab[j]) != null) {
                oldTab[j] = null;
                if (e.next == null)
                    newTab[e.hash & (newCap - 1)] = e;
                else if (e instanceof TreeNode)
                    ((TreeNode<K,V>)e).split(this, newTab, j, oldCap);
                else {
                    Node<K,V> loHead = null, loTail = null;
                    Node<K,V> hiHead = null, hiTail = null;
                    Node<K,V> next;
                    do {
                        next = e.next;
                        // 原索引
                        if ((e.hash & oldCap) == 0) {
                            if (loTail == null)
                                loHead = e;
                            else
                                loTail.next = e;
                            loTail = e;
                        }
                        // 原索引+oldCap
                        else {
                            if (hiTail == null)
                                hiHead = e;
                            else
                                hiTail.next = e;
                            hiTail = e;
                        }
                    } while ((e = next) != null);
                    // 原索引放到bucket里
                    if (loTail != null) {
                        loTail.next = null;
                        newTab[j] = loHead;
                    }
                    // 原索引+oldCap放到bucket里
                    if (hiTail != null) {
                        hiTail.next = null;
                        newTab[j + oldCap] = hiHead;
                    }
                }
            }
        }
    }
    return newTab;
}
```

#### 扩展阅读

##### **Java7 ConcurrentHashMap**

