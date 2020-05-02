CC = /usr/bin/gcc
GCCFLAGS = -c -Wall
ROOTDIR = .
SRCDIR = $(ROOTDIR)/src
OBJDIR = $(ROOTDIR)/obj
VPATH  = src:obj:include
SCRIPTDIR = $(ROOTDIR)/scripts

EXPERIMENTS = AlgorithmTesting BBS CCG G-SHA1 LCG MODEXP MS QCG1 QCG2 XOR
SUBDIRS = Frequency BlockFrequency Runs LongestRun Rank FFT NonOverlappingTemplate OverlappingTemplate Universal LinearComplexity Serial ApproximateEntropy CumulativeSums RandomExcursions RandomExcursionsVariant
EXPERIMENTSD = $(shell for d in $(EXPERIMENTS) ; do echo "$(ROOTDIR)/experiments/$$d" ; done)
EXPERIMENTSDS = $(shell for d in $(EXPERIMENTS) ; do for s in $(SUBDIRS) ; do echo "$(ROOTDIR)/experiments/$$d/$$s" ; done ; done)

OBJ = $(OBJDIR)/assess.o $(OBJDIR)/frequency.o $(OBJDIR)/blockFrequency.o \
      $(OBJDIR)/cusum.o $(OBJDIR)/runs.o $(OBJDIR)/longestRunOfOnes.o \
      $(OBJDIR)/serial.o $(OBJDIR)/rank.o $(OBJDIR)/discreteFourierTransform.o \
      $(OBJDIR)/nonOverlappingTemplateMatchings.o \
      $(OBJDIR)/overlappingTemplateMatchings.o $(OBJDIR)/universal.o \
      $(OBJDIR)/approximateEntropy.o $(OBJDIR)/randomExcursions.o \
      $(OBJDIR)/randomExcursionsVariant.o $(OBJDIR)/linearComplexity.o \
      $(OBJDIR)/dfft.o $(OBJDIR)/cephes.o $(OBJDIR)/matrix.o \
      $(OBJDIR)/utilities.o $(OBJDIR)/generators.o $(OBJDIR)/genutils.o

all: compile $(EXPERIMENTSDS) scripts

compile: | $(OBJDIR) assess

scripts: $(SCRIPTDIR)/file-is-ascii.exe

$(SCRIPTDIR)/file-is-ascii.exe: $(SCRIPTDIR)/file-is-ascii.c
	$(CC) -o $@ $^

assess: $(OBJ)
	$(CC) -o $@ $(OBJ) -lm

$(EXPERIMENTSDS):
	mkdir -p $@

$(OBJDIR):
	mkdir -p $@

$(OBJDIR)/assess.o: $(SRCDIR)/assess.c defs.h decls.h utilities.h
	$(CC) -o $@ -c $(SRCDIR)/assess.c

$(OBJDIR)/frequency.o: $(SRCDIR)/frequency.c defs.h externs.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/frequency.c

$(OBJDIR)/blockFrequency.o: $(SRCDIR)/blockFrequency.c defs.h externs.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/blockFrequency.c

$(OBJDIR)/cusum.o: $(SRCDIR)/cusum.c defs.h externs.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/cusum.c

$(OBJDIR)/runs.o: $(SRCDIR)/runs.c defs.h externs.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/runs.c

$(OBJDIR)/longestRunOfOnes.o: $(SRCDIR)/longestRunOfOnes.c defs.h externs.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/longestRunOfOnes.c

$(OBJDIR)/rank.o: $(SRCDIR)/rank.c defs.h externs.h matrix.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/rank.c

$(OBJDIR)/discreteFourierTransform.o: $(SRCDIR)/discreteFourierTransform.c \
        defs.h externs.h utilities.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/discreteFourierTransform.c

$(OBJDIR)/nonOverlappingTemplateMatchings.o: \
        $(SRCDIR)/nonOverlappingTemplateMatchings.c defs.h externs.h utilities.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/nonOverlappingTemplateMatchings.c

$(OBJDIR)/overlappingTemplateMatchings.o: \
        $(SRCDIR)/overlappingTemplateMatchings.c defs.h externs.h utilities.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/overlappingTemplateMatchings.c

$(OBJDIR)/universal.o: $(SRCDIR)/universal.c defs.h externs.h utilities.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/universal.c

$(OBJDIR)/approximateEntropy.o: $(SRCDIR)/approximateEntropy.c defs.h externs.h utilities.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/approximateEntropy.c

$(OBJDIR)/randomExcursions.o: $(SRCDIR)/randomExcursions.c defs.h externs.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/randomExcursions.c

$(OBJDIR)/randomExcursionsVariant.o: $(SRCDIR)/randomExcursionsVariant.c defs.h externs.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/randomExcursionsVariant.c

$(OBJDIR)/serial.o: $(SRCDIR)/serial.c defs.h externs.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/serial.c

$(OBJDIR)/linearComplexity.o: $(SRCDIR)/linearComplexity.c defs.h externs.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/linearComplexity.c

$(OBJDIR)/dfft.o: $(SRCDIR)/dfft.c
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/dfft.c

$(OBJDIR)/matrix.o: $(SRCDIR)/matrix.c defs.h externs.h utilities.h matrix.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/matrix.c

$(OBJDIR)/genutils.o: $(SRCDIR)/genutils.c config.h genutils.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/genutils.c

$(OBJDIR)/cephes.o: $(SRCDIR)/cephes.c cephes.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/cephes.c

$(OBJDIR)/utilities.o: $(SRCDIR)/utilities.c defs.h externs.h utilities.h config.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/utilities.c

$(OBJDIR)/generators.o: $(SRCDIR)/generators.c defs.h externs.h utilities.h \
        config.h generators.h
	$(CC) -o $@ $(GCCFLAGS) $(SRCDIR)/generators.c

clean:
	rm -f assess $(OBJDIR)/*.o scripts/*.exe
	@ for d in $(EXPERIMENTSDS) ; do ([ -d $$d ] && rmdir -v $$d) || true ; done
	@ for d in $(EXPERIMENTSD) ; do ([ -d $$d ] && rmdir -v $$d) || true ; done

rebuild: clean assess
