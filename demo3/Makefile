
service=demo.service
# 安装
install:
	ln -sfv $$PWD/demo.sh /usr/local/bin/demo.sh
	$(call remove)
	$(call link)
	$(call reload)
reload:
	$(call reload)
start:
	$(call start)
cat:
	$(call cat)

log:
	journalctl --line 20 -u demo.service
# 卸载
remove:
	$(call remove)

start:=systemctl start $(service)
link:=systemctl link $$PWD/$(service)
status:=systemctl status $(service)
reload:=systemctl daemon-reload
cat:=systemctl cat $(service)
remove=-rm -fv /etc/systemd/system/demo.service

shell:=/bin/bash
