INC=. \
	/opt/taobao/install/httpd/include \
	../../opensource/boost_1_42_0/ \
	/home/admin/local/include \
	/home/admin/local/curl/include \
	/home/admin/local/uuid \
	/home/admin/local/taobao/tbutils/include/tbnet \
	/home/admin/local/taobao/tbutils/include/tbsys \
	/home/admin/local/taobao/tair_release/include \
	../common \

CC=g++
CFLAGS=-g -Wall -fPIC

all:mod_tokensvr.so

OBJS=util.o \
	 tairClient.o \
	 tokenHandler.o \
	 proxyHandler.o \
	 mod_tokensvr.o \

COM_OBJS=../common/log.o \
		 ../common/IM_URL.o \
		 ../common/url_process.o \
		 ../common/apache_request.o \
		 ../common/apache_multipart_buffer.o \

%.o:%.c
	g++ -g -Wall -c -fPIC $^ -o $@ $(addprefix -I, $(INC))

%.o:%.cpp
	g++ -g -Wall -c -fPIC $^ -o $@ $(addprefix -I, $(INC))


mod_tokensvr.so:$(OBJS)$(COM_OBJS)
	$(CC) -shared -o $@ $(OBJS)$(COM_OBJS) /home/admin/local/uuid/libuuid.a \
		-L/home/admin/local/taobao/tbutils/lib -ltbnet \
		-L/home/admin/local/taobao/tbutils/lib -ltbsys \
		-L/home/admin/local/taobao/tair/lib -ltairclientapi \
		-lpthread \
		-L/home/admin/lib/boost -lboost_thread \
		-L/home/admin/local/lib -llog4cpp \
		-L/home/admin/local/curl/lib -lcurl; \
		rm -f *.o ../common/*.o

install:
	rm -f /home/admin/apache_worker/modules/mod_tokensvr.so; cp mod_tokensvr.so /home/admin/apache_worker/modules/

clean:
	rm -f mod_tokensvr.so *.o ../common/*.o
