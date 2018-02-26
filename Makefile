bindir = /bin
sysconfdir = /etc
localstatedir = /var
systemd_unit_dir = $(sysconfdir)/systemd/system

ACTIVATE_UNITS = \
		 firstboot-early.service \
		 firstboot-late.service

UNITS = $(ACTIVATE_UNITS) \
	wait-for-gateway.service

SCRIPTS = \
	  wait-for-gateway

INSTALL = install
SYSTEMCTL = systemctl

all: $(UNITS)

firstboot-early.service: firstboot-template.service
	sed \
	-e 's/STAGE/early/g' \
	-e '/^%late%/d' \
	-e '/^%early%/ s/%early% //' $< > $@ || rm -f $@

firstboot-late.service: firstboot-template.service
	sed \
	-e 's/STAGE/late/g' \
	-e '/^%early%/d' \
	-e '/^%late%/ s/%late% //' $< > $@ || rm -f $@

install: install-units install-bin

install-units: $(UNITS)
	$(INSTALL) -d -m 755 $(DESTDIR)$(systemd_unit_dir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(localstatedir)/lib/firstboot
	for unit in $(UNITS); do \
		$(INSTALL) -m 644 $$unit \
			$(DESTDIR)$(systemd_unit_dir)/$$unit; \
	done

install-bin: $(SCRIPTS)
	$(INSTALL) -d -m 755 $(DESTDIR)$(bindir)
	for script in $(SCRIPTS); do \
		$(INSTALL) -m 755 $$script \
			$(DESTDIR)$(bindir)/$$script; \
	done


activate: install
	$(SYSTEMCTL) enable $(ACTIVATE_UNITS)

clean:
	rm -f $(UNITS)
