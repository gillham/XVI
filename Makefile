PCC=prog8c

all: clean build bundle run

build:
	$(PCC) -target cx16 src/xvi.p8

bundle:
	rm -rfv ./XVI
	mkdir ./XVI 
	cp xvi.prg XVI/XVI.PRG
	cp xvi.prg XVI/AUTOBOOT.X16 
	cp BASLOAD XVI/BASLOAD
	cp VTUI1.1.BIN XVI/VTUI1.1.BIN
	
	cp readme.txt XVI/readme.txt
	zip -r XVI-1.2.0.zip XVI/ 
	mkdir ./releases 2> /dev/null || echo -n
	cp *.zip releases/

run:
	cd XVI && x16emu -scale 2 -fsroot .

trace:
	x16emu -scale 2 -prg ./XVI -run -trace -fsroot .

io-test:
	java -jar /Users/tempuser/Desktop/x16/prog8compiler-10.4-all.jar -target cx16 src/file-io-test.p8

iso-test:
	java -jar /Users/tempuser/Desktop/x16/prog8compiler-10.4-all.jar -target cx16 src/iso-test.p8

txt-viewer:
	java -jar /Users/tempuser/Desktop/x16/prog8compiler-10.4-all.jar -target cx16 src/txt-viewer.p8

debug:
	x16emu -scale 2 -prg ./XVI -run -debug -fsroot .

clean:
	rm -fv xvi xvi.prg *.asm 2> /dev/null || echo -n
	rm -rf ./XVI *.zip       2> /dev/null || echo -n
