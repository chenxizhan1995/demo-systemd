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
Environment="cur=/usr/.home/chen/systemd-demo/demo1"
ExecStart=/usr/.home/chen/systemd-demo/demo1/demo.sh %h "${HOME}"
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
```
```
