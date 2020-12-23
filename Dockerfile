FROM debian:9 as nginx

ENV NGINX_VERSION nginx-1.19.3
ENV NGINX_DIR /opt/nginx
ENV NGINX_LOG_PATH /var/log/nginx
ENV LUAJIT_VERSION v2.1-20201001
ENV LUAJIT2_DIR /opt/nginx/luajit2
ENV LUAJIT_LIB_DIR /usr/local
ENV NGX_DEV_KIT_VERSION v0.3.1
ENV NGX_DEV_KIT_DIR /opt/nginx/ngx_devel_kit
ENV LUA_NGINX_MODULE_VERSION v0.10.19
ENV LUA_NGINX_MODULE_DIR /opt/nginx/lua-nginx/module
ENV LUA_RESTY_CORE_VERSION v0.1.21
ENV LUA_RESTY_CORE_DIR /opt/nginx/lua-resty-core
ENV LUA_RESTY_CACHE_VERSION v0.10
ENV LUA_RESTY_CACHE_DIR /opt/nginx/lua-resty-cache

ENV LUAJIT_LIB ${LUAJIT_LIB_DIR}/lib 
ENV LUAJIT_INC ${LUAJIT_LIB_DIR}/include/luajit-2.1

RUN apt update && apt install -y wget build-essential software-properties-common libpcre++-dev libssl-dev libgeoip-dev libxslt1-dev zlib1g-dev

RUN wget https://github.com/openresty/luajit2/archive/${LUAJIT_VERSION}.tar.gz \
    && wget https://github.com/vision5/ngx_devel_kit/archive/${NGX_DEV_KIT_VERSION}.tar.gz \
    && wget https://github.com/openresty/lua-nginx-module/archive/${LUA_NGINX_MODULE_VERSION}.tar.gz \
    && wget https://github.com/openresty/lua-resty-core/archive/${LUA_RESTY_CORE_VERSION}.tar.gz \
    && wget https://github.com/openresty/lua-resty-lrucache/archive/${LUA_RESTY_CACHE_VERSION}.tar.gz \
    && wget https://nginx.org/download/${NGINX_VERSION}.tar.gz

RUN mkdir -p ${LUAJIT2_DIR} \
    && mkdir -p ${LUAJIT_LIB_DIR} \
    && mkdir -p ${NGX_DEV_KIT_DIR} \
    && mkdir -p ${LUA_NGINX_MODULE_DIR} \
    && mkdir -p ${LUA_RESTY_CORE_DIR} \
    && mkdir -p ${LUA_RESTY_CACHE_DIR}

RUN tar -C ${NGINX_DIR} -xzf ${NGINX_VERSION}.tar.gz --strip-components 1 \
    && tar -C ${LUAJIT2_DIR} -xzf ${LUAJIT_VERSION}.tar.gz --strip-components 1 \
    && tar -C ${NGX_DEV_KIT_DIR} -xzf ${NGX_DEV_KIT_VERSION}.tar.gz --strip-components 1 \
    && tar -C ${LUA_NGINX_MODULE_DIR} -xzf ${LUA_NGINX_MODULE_VERSION}.tar.gz --strip-components 1 \
    && tar -C ${LUA_RESTY_CORE_DIR} -xzf ${LUA_RESTY_CORE_VERSION}.tar.gz --strip-components 1 \
    && tar -C ${LUA_RESTY_CACHE_DIR} -xzf ${LUA_RESTY_CACHE_VERSION}.tar.gz --strip-components 1


RUN cd ${LUAJIT2_DIR} && make -j2 PREFIX=${LUAJIT_LIB_DIR} && make install PREFIX=${LUAJIT_LIB_DIR}
RUN cd ${LUA_RESTY_CORE_DIR} && make -j2 && make install
RUN cd ${LUA_RESTY_CACHE_DIR} && make -j2 && make install
   
RUN cd ${NGINX_DIR} \
    && echo $(LUAJIT_LIB) && echo $(LUAJIT_INC) \
    && ./configure --sbin-path=/usr/bin/nginx \
                   --conf-path=/etc/nginx/nginx.conf \
                   --error-log-path=${NGINX_LOG_PATH}/error.log \
                   --http-log-path=${NGINX_LOG_PATH}/access.log \
                   --with-pcre \
                   --with-http_ssl_module \
                   --with-cc-opt=-O2 \
                   --with-ld-opt='-Wl,-rpath,/usr/local/lib' \
                   --add-module=${LUA_NGINX_MODULE_DIR} \ 
                   --add-module=${NGX_DEV_KIT_DIR} \
    && make -j2 && make install

COPY nginx.conf /etc/nginx/nginx.conf
 
CMD ["nginx","-g", "daemon off;"]

FROM debian:9

COPY --from=nginx /usr/bin/nginx /usr/bin
COPY --from=nginx /usr/local/nginx /usr/local/nginx
COPY --from=nginx /usr/lib /usr/lib
COPY --from=nginx /usr/local/lib /usr/local/lib
COPY --from=nginx /etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=nginx /etc/nginx/mime.types /etc/nginx/mime.types

RUN mkdir -p /var/log/nginx
CMD ["nginx", "-g", "daemon off;"]
