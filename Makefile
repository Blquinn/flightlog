compile-ldc:
	dub build --compiler=ldc2
	strip flt

compile-dmd:
	dub build --compiler=ldc2

clean:
	rm flt
