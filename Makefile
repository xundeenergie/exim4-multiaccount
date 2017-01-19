DIR=$(shell basename $(CURDIR))

VERSION=`gawk '$$1 == "Version:"{print $$2}' $(DIR)/DEBIAN/control`
ARCH=`gawk '$$1 == "Architecture:"{print $$2}' $(DIR)/DEBIAN/control`
COMMIT = $(shell date "+xe%Y%m%d_%H%M%S")

SUBDIRS := $(shell find $(DIR) -type d -print)
FILTER := $(abspath .git% %.deb .publish-git .builddeb %.swp Makefile)
FILTERORIG := $(abspath .git% %.deb .publish-git .builddeb %.swp Makefile) /DEBIAN%
FILES := $(filter-out $(FILTER), $(abspath $(shell find . -mindepth 1 -type f -print) ))
ORIGS := $(filter-out $(FILTERORIG), $(realpath $(subst ./$(DIR),,$(shell find . -mindepth 2 -type f -print))))
FILESGIT := $(filter-out $(abspath .git%), $(abspath $(shell find . -mindepth 1 -type f -print)))

#all: $(DIR)/DEBIAN/control 

#$(DIR)/DEBIAN/control: $(FILES)

all: .builddeb
	#@echo FILE $(FILES)

.builddeb: $(FILES)
	#@echo FILT $(FILTER)
	#@echo FILE $(FILES)
	@echo `gawk -f ../increment.awk $(DIR)/DEBIAN/control`
	sed -e "s/^Version:.*/`gawk -f ../increment.awk $(DIR)/DEBIAN/control`/" $(DIR)/DEBIAN/control > $(DIR)/DEBIAN/control.tmp
	mv $(DIR)/DEBIAN/control.tmp $(DIR)/DEBIAN/control
	fakeroot dpkg-deb --build $(DIR) "$(DIR)_$(VERSION)_$(ARCH).deb"
	aptly repo add xundeenergie "$(DIR)_$(VERSION)_$(ARCH).deb"
	touch .builddeb

update: 
	@echo "Copy originals to make-dir"
	@for i in $(ORIGS); do sudo cp -uv $$i $(DIR)$$i;done

.publish-git: $(FILESGIT)
	fakeroot git add .
	fakeroot git commit -m $(COMMIT) && git push origin master || exit 0
	touch .publish-git
	
