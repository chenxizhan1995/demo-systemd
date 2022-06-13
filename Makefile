
upload.cdh3:
	rsync -av --delete --exclude=.git ./ chen@cdh3:systemd-demo

