#!/usr/bin/env bash

PREFIX=/usr

cat << EOF > $PREFIX/etc/janus/janus.transport.http.cfg
; Web server stuff: whether any should be enabled, which ports they
; should use, whether security should be handled directly or demanded to
; an external application (e.g., web frontend) and what should be the
; base path for the Janus API protocol. You can also specify the
; threading model to use for the HTTP webserver: by default this is
; 'unlimited' (which means a thread per connection, as specified by the
; libmicrohttpd documentation), using a number will make use of a thread
; pool instead. Since long polls are involved, make sure you choose a
; value that doesn't keep new connections waiting.
[general]
base_path = /janus			; Base path to bind to in the web server (plain HTTP only)
threads = unlimited			; unlimited=thread per connection, number=thread pool
http = no					; Whether to enable the plain HTTP interface
;port = 8088					; Web server HTTP port
https = yes					; Whether to enable HTTPS (default=no)
secure_port = 8089			; Web server HTTPS port, if enabled
;acl = 127.,192.168.0.		; Only allow requests coming from this comma separated list of addresses

; Janus can also expose an admin/monitor endpoint, to allow you to check
; which sessions are up, which handles they're managing, their current
; status and so on. This provides a useful aid when debugging potential
; issues in Janus. The configuration is pretty much the same as the one
; already presented above for the webserver stuff, as the API is very
; similar: choose the base bath for the admin/monitor endpoint (/admin
; by default), ports, threading model, etc. Besides, you can specify
; a secret that must be provided in all requests as a crude form of
; authorization mechanism, and partial or full source IPs if you want to
; limit access basing on IP addresses. For security reasons, this
; endpoint is disabled by default, enable it by setting admin_http=yes.
[admin]
admin_base_path = /admin		; Base path to bind to in the admin/monitor web server (plain HTTP only)
admin_threads = unlimited		; unlimited=thread per connection, number=thread pool
admin_http = no					; Whether to enable the plain HTTP interface
admin_port = 7088				; Admin/monitor web server HTTP port
admin_https = no				; Whether to enable HTTPS (default=no)
;admin_secure_port = 7889		; Admin/monitor web server HTTPS port, if enabled
;admin_acl = 127.,192.168.0.	; Only allow requests coming from this comma separated list of addresses


; Certificate and key to use for HTTPS.
[certificates]
cert_pem=$PREFIX/share/janus/certs/janus.pem
cert_key=$PREFIX/share/janus/certs/janus.key
EOF
