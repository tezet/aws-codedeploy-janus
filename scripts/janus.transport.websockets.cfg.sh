#!/usr/bin/env bash

PREFIX=/usr

cat << EOF > $PREFIX/etc/janus/janus.transport.websockets.cfg
; WebSockets stuff: whether they should be enabled, which ports they
; should use, and so on.
[general]
ws = yes					; Whether to enable the WebSockets API
ws_port = 8188				; WebSockets server port
;ws_interface = eth0		; Whether we should bind this server to a specific interface only
wss = no					; Whether to enable secure WebSockets
;wss_port = 8989;			; WebSockets server secure port, if enabled
;wss_interface = eth0		; Whether we should bind this server to a specific interface only
;ws_logging = 7				; libwebsockets debugging level (0 by default)
;ws_acl = 127.,192.168.0.	; Only allow requests coming from this comma separated list of addresses

; If you want to expose the Admin API via WebSockets as well, you need to
; specify a different server instance, as you cannot mix Janus API and
; Admin API messaging. Notice that by default the Admin API support via
; WebSockets is disabled.
[admin]
admin_ws = no					; Whether to enable the Admin API WebSockets API
admin_ws_port = 7188			; Admin API WebSockets server port, if enabled
;admin_ws_interface = eth0		; Whether we should bind this server to a specific interface only
admin_wss = no					; Whether to enable the Admin API secure WebSockets
;admin_wss_port = 7989			; Admin API WebSockets server secure port, if enabled
;admin_wss_interface = eth0		; Whether we should bind this server to a specific interface only
;admin_ws_acl = 127.,192.168.0.	; Only allow requests coming from this comma separated list of addresses

; Certificate and key to use for any secure WebSocket server, if needed.
[certificates]
cert_pem=$PREFIX/share/janus/certs/janus.pem
cert_key=$PREFIX/share/janus/certs/janus.key
EOF
