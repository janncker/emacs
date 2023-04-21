#CFLAGS='-g3 -O2 -static' ./configure \   # static build not work

./configure \
	--without-all --without-ns --without-x --without-libgmp --without-compress-install \
	--with-modules --with-threads
make -j20
