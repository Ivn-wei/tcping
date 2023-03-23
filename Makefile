FILES=README tcping.c Makefile LICENSE
VERNUM=`grep VERSION tcping.c | cut -d" " -f3`
VER=tcping-$(VERNUM)

CCFLAGS=-Wall
CC=gcc

tcping.linux: tcping.c
	$(CC) -o tcping $(CCFLAGS) tcping.c

tcping.macos: tcping.linux

tcping.openbsd: tcping.linux

deb-linux: tcping.linux
	mkdir -p debian/usr/bin
	cp tcping debian/usr/bin
	mkdir debian/DEBIAN
	cat deb/control | sed -e "s/VERSION/$(VERNUM)/" > debian/DEBIAN/control
	md5sum debian/usr/bin/tcping | sed -e 's#debian/##g' > debian/DEBIAN/md5sums
	dpkg-deb --build debian/ $(VER).deb
	rm -rf debian

clean:
	rm -f tcping.solaris* tcping core *.o *.deb
	rm -rf debian/

dist:
	mkdir $(VER) ; cp $(FILES) $(VER)/ ; tar -c $(VER) | gzip -9 > $(VER).tar.gz ; rm -rf $(VER)
