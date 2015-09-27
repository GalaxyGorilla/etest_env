from ubuntu:15.04

ENV PATH /usr/local/bin:/usr/bin:$PATH

#BASIC PACKAGES
run apt-get -y update \
    && apt-get install -y git build-essential libncurses5-dev openssl \
       libssl-dev curl m4 vim

#UTF-8 SETUP FOR ELIXIR
run echo \
"
export LC_ALL=en_US.UTF-8 \
export LANG=en_US.UTF-8 \
export LANGUAGE=en_US.UTF-8 \
" >> ~/.bashrc && /bin/bash -c -i 'source ~/.bashrc'

run mkdir /opt/git

#KERL
run cd /opt/git/ \
    && git clone https://github.com/yrashk/kerl.git \
    && cd kerl \
    && chmod a+x /opt/git/kerl/kerl \
    && ln -s /opt/git/kerl/kerl /usr/local/bin/kerl 

run kerl update releases \
    && kerl build 17.4 17.4 \
    && kerl build 17.5 17.5 \
    && kerl build 18.0 18.0 \
    && kerl build 18.1 18.1

run mkdir ~/.kerl/installs

run    mkdir ~/.kerl/installs/17.4 && kerl install 17.4 ~/.kerl/installs/17.4 \
    && mkdir ~/.kerl/installs/17.5 && kerl install 17.5 ~/.kerl/installs/17.5 \
    && mkdir ~/.kerl/installs/18.0 && kerl install 18.0 ~/.kerl/installs/18.0 \
    && mkdir ~/.kerl/installs/18.1 && kerl install 18.1 ~/.kerl/installs/18.1 

#DEFAULT ERLANG
run echo ". ~/.kerl/installs/17.4/activate" >> ~/.bashrc

#KIEX
run \curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s 
run echo 'test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"' >> ~/.bashrc
run ln -s ~/.kiex/bin/kiex /usr/local/bin/kiex 
    
run /bin/bash -c -i 'source ~/.bashrc \
    && kiex install 1.1.0-rc.0 \
    && kiex install 1.0.5 \ 
    && kiex install 1.0.3 \ 
    && kiex default 1.1.0-rc.0'

run cd
