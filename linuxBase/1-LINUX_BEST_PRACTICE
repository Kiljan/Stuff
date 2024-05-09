1. Use LVM (59-LVM)
2. Configure Firewalld
3. Mitigate security problems; for example:
		mv /usr/bin/scp /usr/bin/scp.disabled
		cat /usr/bin/scp
			!/bin/bash
			echo "ERROR! SCP is disabled due to security reasons. Try SSH, SFTP or RSYNC instead."
			exit 1
	)
	
4. Change language
yum install glibc-langpack-en
localectl set-locale en_GB.utf8

5. Setup /etc/sysctl.d/ (60-additional-sysctl.conf). For example:
    a. Change tcp_keepalive: sysctl -w net.ipv4.tcp_keepalive_time=600 net.ipv4.tcp_keepalive_intvl=60 net.ipv4.tcp_keepalive_probes=20
    b. Set swapinnes to something like 5 %. Then the swap file will only be used when RAM usage is around 95 percent: vm.swappiness = 5
    c. Ensure address space layout randomization (ASLR) is enabled: sysctl kernel.randomize_va_space

6. Ensure XD/NX support is enabled
journalctl | grep 'protection: active'

7. Ensure journald is configured to write logfiles
mkdir -p /var/log/journal
chmod -R 751 /var/log/journal
systemctl restart systemd-journald

8. Set the auditd rules (61-Auditd)

9. Check services (must be off)
systemctl list-unit-files | grep -i chargen 
systemctl list-unit-files | grep -i daytime 
systemctl list-unit-files | grep -i discard 
systemctl list-unit-files | grep -i shell 
systemctl list-unit-files | grep -i login 
systemctl list-unit-files | grep -i exec 
systemctl list-unit-files | grep -i talk 
systemctl list-unit-files | grep -i telnet 
systemctl list-unit-files | grep -i tftp
systemctl is-enabled coredump.service 
systemctl is-enabled xinetd	

10. Set mount points in fstab (62-fstab)

11. Use chronyd insted of ntpd
https://chrony.tuxfamily.org/
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/system_administrators_guide/index#sect-differences_between_ntpd_and_chronyd

12. Remove unused modules
modprobe -n -v <mod_name>
lsmod | grep <mod_name>
rmmod <mod_name> # rm module, no need when a module is already unloaded; cramfs, freevxfs, jffs2, hfs, hfsplus, squashfs, udf, vfat, dccp, sctp

13. Ensure sticky bit is set on all world-writable directories
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null

14. Ensure GPG keys are configured 
rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n'

15. Ensure prelink is disabled 
rpm -q prelink

16. Ensure SELinux are installed 
getenforce

17. Ensure no unconfined daemons exist 
ps -eZ | grep -E "initrc" | grep -E -v -w "tr|ps|grep|bash|awk"

18. Ensure local login warning banner is configured properly 
echo "Authorized uses only. All activity may be monitored and reported!" > /etc/issue

19. Ensure remote login warning banner is configured properly 
echo "Authorized uses only. All activity may be monitored and reported!" > /etc/issue.net

20. Ensure logrotate is configured
/etc/logrotate.conf and /etc/logrotate.d/*

21. Set up sshd (63-sshd)

22. Audit SUID executables (best to perform on fresh install, for future reference/comparison of resoults)
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -4000

23. Audit SGID executables (best to perform on fresh install, for future reference/comparison of resoults)
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -2000

24. Ensure root is the only UID 0 account
awk -F: '($3 == 0) { print $1 }' /etc/passwd

========================================================================================================================
For OL8
https://docs.oracle.com/en/operating-systems/oracle-linux/8/osmanage/index.html

1. Manage the number of kernels installed for Oracle Linux (8 and 9)
$grubby --info=ALL | grep ^kernel	# check for actual kernel
$cat /etc/yum.conf |grep limit		# set limit
	installonly_limit=3
$dnf update -y 						# and then just update
$grubby --info=ALL | grep ^kernel	# verify the resoult
