.PHONY: FORCE
all: FORCE
	$(MAKE) -C .. danecoin_qt test_danecoin_qt
clean: FORCE
	$(MAKE) -C .. danecoin_qt_clean test_danecoin_qt_clean
check: FORCE
	$(MAKE) -C .. test_danecoin_qt_check
danecoin-qt danecoin-qt.exe: FORCE
	 $(MAKE) -C .. danecoin_qt
