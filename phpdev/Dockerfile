FROM php:8.2.3-fpm-alpine3.17 as nvimbuilder

LABEL mantainer="EnXt <enxt@users.noreplay.github.com>"

# Install dependencies
RUN apk add --no-cache \
  git \
  build-base \ 
  cmake \ 
  automake \ 
  autoconf \ 
  libtool \ 
  pkgconf \ 
  coreutils \ 
  curl \ 
  unzip \ 
  gettext-tiny-dev \ 
  && rm -rf /var/cache/apk/*

ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF

# Build nvim from source
RUN git clone https://github.com/neovim/neovim \
  && cd neovim \
  && git checkout stable \
  && make \ 
  && make install

#################################################
FROM php:8.2.3-fpm-alpine3.17

COPY --from=nvimbuilder /usr/local/bin /usr/local/bin
COPY --from=nvimbuilder /usr/local/share/nvim /usr/local/share/nvim

ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF

RUN apk add --update --no-cache git openssh \
    && apk add --update --no-cache --virtual .build-dependencies autoconf linux-headers git openssh $PHPIZE_DEPS \
    && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install pcntl \
    && docker-php-ext-enable pcntl \
    && pecl clear-cache \
    && curl https://getcomposer.org/installer > composer-setup.php \
    && php composer-setup.php \
    && rm composer-setup.php \
    && mv composer.phar /usr/local/bin/composer \
    && apk del .build-dependencies \
    && rm /usr/src/* \ 
    && rm -rf /var/cache/apk/*
    
    # && npm install --global yarn \
    # \
    # # Prepare directories where we will install some extra tools
    # mkdir -p /root/tools/php-cs-fixer && mkdir /root/bin \
    # \
    # # Install PHP Actor
    # git clone https://github.com/phpactor/phpactor.git /root/tools/phpactor && \
    # cd /root/tools/phpactor && \ 
    # composer install && \
    # cd /root/bin && \
    # ln -s /root/tools/phpactor/bin/phpactor phpactor \
    # \
    # # Install php-cs-fixer
    # composer require --dev --working-dir=/root/tools/php-cs-fixer friendsofphp/php-cs-fixer && \
    # cd /root/bin && \
    # ln -s /root/tools/php-cs-fixer/vendor/bin/php-cs-fixer php-cs-fixer

# COPY nvim /root/.config/nvim

# # Install Vim Plug
# RUN sh -c 'curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
#        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# RUN nvim +'CocInstall -sync coc-lists coc-explorer coc-json coc-phpactor coc-php-cs-fixer' +qall

# RUN nvim +'PlugInstall' +qall

# RUN mkdir -p /root/.config/coc/extensions/@yaegassy/coc-phpstan-data

# RUN composer global require phpstan/phpstan

# RUN echo "export PATH=$HOME/bin:$HOME/.composer/vendor/bin:$PATH" >> /root/.bashrc

# ENV PATH="${PATH}:~/.composer/vendor/bin"
# ENV TERM=xterm-256color

COPY install-tools.sh /app/install-tools.sh

WORKDIR "/app"

ENV PATH="${PATH}:/app/tools/bin"

EXPOSE 8000

CMD [ "/bin/sh"]