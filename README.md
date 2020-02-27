#E-Arch的下载使用

##下载
在**liveCD** 模式下输入以下命令下载E-Arch脚本
```
wget https://raw.githubusercontent.com/KyleJKC/E-Arch-/master/1.sh https://raw.githubusercontent.com/KyleJKC/E-Arch-/master/2.sh
```

##如何使用？
**下载好后** ，在**liveCD** 模式下输入以下命令运行E-Arch上半部分脚本
```
bash 1.sh
```
等待其弹出**"The execution of 1.sh is complete, please partition the disks and execute 2.sh"** 提示后，
请进行分区，格式化，挂载操作。之后请输入以下命令运行E-Arch下半部分脚本。
```
bash 2.sh
```
如果不知道如何进行这些操作，你可以看看下面几种分区方案及格式化挂载教程。

##分区示例方案

###方案一：五分区完美方案
这个方案是我最推荐的，但是如果想使用这种方案，请确保你的磁盘空间足够大（建议磁盘空间:100G以上）

根  :30G      挂载点：/mnt
EFI :300M     挂载点：/mnt/boot/EFI
opt :15G      挂载点：/mnt/opt
swap:4G-8G    无需挂载
home:剩余空间 挂载点：/mnt/home

###方案二：四分区主流方案
这个方案其实是上面的方案去掉了opt分区，将opt的空间添加到home目录下（建议磁盘空间:70G-100G）

根  :30G      挂载点：/mnt
EFI :300M     挂载点：/mnt/boot/EFI
swap:4G-8G    无需挂载
home:剩余空间 挂载点：/mnt/home

###方案三：三分区紧凑方案
这个方案我并不是很推荐，但是如果你的磁盘方案实在不够前面两种方案，那这个方案是个不错的选择(建议磁盘空间:40G-70G)

根  :剩余空间 挂载点：/mnt
EFI :300M     挂载点：/mnt/boot/EFI
swap:4G-8G    无需挂载

##方案四：单分区方案
这个方案我非常不推荐，但是如果你的磁盘实在很小并且你不想要在分区上多花时间的话那你只能尝试这个方案(磁盘小的不行)
根 ：20G





