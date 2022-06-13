# systemd 单元文件示例
- new,2022-06-13,chenxizhan1995@163.com

参考手册 [systemd.index 中文手册 [金步国]](http://www.jinbuguo.com/systemd/systemd.index.html)。
对应 systemd 241。
## systemd 版本
```
$ systemctl --version
systemd 219
+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN

$ cat /etc/centos-release
CentOS Linux release 7.6.1810 (Core)

$ uname -a
Linux cdh03 3.10.0-1062.4.3.el7.x86_64 #1 SMP Wed Nov 13 23:58:53 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```
## 测试
上传
```bash
make upload.cdh3
```
### demo1 hello world
```bash
ssh root@cdh3
cd ~chen/systemd-demo/demo1
make install

make start

make log

# 卸载
make remove
```
#### 运行结果
```bash
[root@cdh03 demo1]# make reload
systemctl daemon-reload
[root@cdh03 demo1]# make cat
systemctl cat demo.service
# /usr/.home/chen/systemd-demo/demo1/demo.service
[Unit]
Description=systemd服务单元测试
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/.home/chen/systemd-demo/demo1/demo.sh
[root@cdh03 demo1]# make start
systemctl start demo.service
[root@cdh03 demo1]# make log
journalctl --line 20 -u demo.service
-- Logs begin at 六 2021-02-27 11:18:27 CST, end at 一 2022-06-13 14:10:43 CST. --

6月 13 14:10:43 cdh03 systemd[1]: Starting systemd服务单元测试...
6月 13 14:10:43 cdh03 demo.sh[20979]: hello,world 2022-06-13T14:10:43+0800
6月 13 14:10:43 cdh03 systemd[1]: Started systemd服务单元测试.
```

### demo2
查看工作路径、当前用户、环境变量。


```bash
ssh root@cdh3
cd ~chen/systemd-demo/demo2
make install

make start

make log

# 卸载
make remove
```
Q. 如何获取单元文件所在实际目录？
Ans：没找到直接获取的方法。
这样，要执行 shell 脚本，就得放在固定的位置才行，唉。

#### 运行结果
如下结果，确实和文档说的一样哈。
```
6月 13 14:40:42 cdh03 demo.sh[29461]: declare -x PREFIX="demo"
6月 13 14:40:42 cdh03 demo.sh[29461]: declare -x FULL_NAME="demo.service"
6月 13 14:40:42 cdh03 demo.sh[29461]: declare -x SHELL="/bin/sh"
6月 13 14:40:42 cdh03 demo.sh[29461]: declare -x PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
6月 13 14:40:42 cdh03 demo.sh[29461]: /usr/local/bin/demo.sh: 第 3 行:declare: HOME: 未找到
6月 13 14:40:42 cdh03 demo.sh[29461]: 工作目录 /
6月 13 14:40:42 cdh03 demo.sh[29461]: 用户身份 uid=0(root) gid=0(root) 组=0(root)
6月 13 14:40:42 cdh03 demo.sh[29461]: FragmentPath=/usr/.home/chen/systemd-demo/demo2/demo.service
6月 13 14:40:42 cdh03 demo.sh[29461]: 脚本路径 /usr/local/bin/demo.sh, /usr/.home/chen/systemd-demo/demo2/demo.sh
```
### demo3-切换用户
Q. 指定了 User= 后，%s 占位符就没了？？
```
6月 13 14:45:23 cdh03 demo.sh[1359]: declare -x PREFIX="demo"
6月 13 14:45:23 cdh03 demo.sh[1359]: declare -x FULL_NAME="demo.service"
6月 13 14:45:23 cdh03 demo.sh[1359]: declare -x SHELL="%s"
6月 13 14:45:23 cdh03 demo.sh[1359]: declare -x PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
6月 13 14:45:23 cdh03 demo.sh[1359]: declare -x HOME="/usr/.home/chen"
6月 13 14:45:23 cdh03 demo.sh[1359]: 工作目录 /
6月 13 14:45:23 cdh03 demo.sh[1359]: 用户身份 uid=1003(chen) gid=1003(chen) 组=1003(chen),10(wheel),960(docker)
6月 13 14:45:23 cdh03 demo.sh[1359]: FragmentPath=/usr/.home/chen/systemd-demo/demo3/demo.service
```
### demo4-资源限制
[systemd.resource-control 中文手册 [金步国]](http://www.jinbuguo.com/systemd/systemd.resource-control.html#)

Q. 开启CPUAccounting= 后，如何查看统计数据呢？

Q. 失为一个办法
```bash
exec &>>$prefix/demo.log
```

Q. 好像 MemoryLimit 不起作用？
预期进程被杀死，但并没有。

#### 怎么回事，怎么有一条输出信息丢失了？
```bash
echo "---------------------------------------"
echo "工作目录 $PWD"
echo "用户身份 $(id)"

echo "脚本路径 $0, $(realpath $0)"
echo "程序执行完毕"
```

```
6月 13 15:24:53 cdh03 systemd[1]: Starting systemd服务单元测试...
6月 13 15:24:53 cdh03 demo.sh[19647]: ---------------------------------------
6月 13 15:24:53 cdh03 demo.sh[19647]: 工作目录 /
6月 13 15:24:53 cdh03 demo.sh[19647]: 用户身份 uid=1003(chen) gid=1003(chen) 组=1003(chen),10(wheel),960(docker)
6月 13 15:24:53 cdh03 demo.sh[19647]: 脚本路径 /usr/local/bin/demo.sh, /usr/.home/chen/systemd-demo/demo4/demo.sh
6月 13 15:24:53 cdh03 systemd[1]: Started systemd服务单元测试.
```
