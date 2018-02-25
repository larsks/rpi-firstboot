sysconfdir = /etc
localstatedir = /var
systemd_unit_dir = $(sysconfdir)/systemd/system

UNITS = firstboot-early.service \
	firstboot-late.service

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

install: all
	$(INSTALL) -d -m 755 $(DESTDIR)$(systemd_unit_dir)
	$(INSTALL) -d -m 755 $(DESTDIR)$(localstatedir)/lib/firstboot
	for unit in $(UNITS); do \
		$(INSTALL) -m 644 $$unit \
			$(DESTDIR)$(systemd_unit_dir)/$$unit; \
	done

activate: install
	$(SYSTEMCTL) enable $(UNITS)

clean:
	rm -f $(UNITS)
