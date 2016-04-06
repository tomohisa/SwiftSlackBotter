build:
	@echo "Building..."
	swift build -Xcc -I/usr/local/include -Xlinker -L/usr/local/lib > log.txt

clean:
	rm -rf .build Packages
