# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

alias kcat-dev="kcat -v -C -b b-1.wosa-dev.okjuy8.c3.kafka.eu-west-3.amazonaws.com:9096,b-2.wosa-dev.okjuy8.c3.kafka.eu-west-3.amazonaws.com:9096,b-3.wosa-dev.okjuy8.c3.kafka.eu-west-3.amazonaws.com:9096 -X security.protocol=SASL_SSL -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username='admin' -X sasl.password='2#jH0drl+Oe:q{wn'"
if [ -f "/home/madril/.config/fabric/fabric-bootstrap.inc" ]; then . "/home/madril/.config/fabric/fabric-bootstrap.inc"; fi