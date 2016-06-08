#!/usr/bin/env bash

get_nat_mapping_entry ()
{
	PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
	if [ ! $? -eq 0 ]; then
		NAT_MAPPING_ENTRY=";nat_1_1_mapping = 1.2.3.4"
	else
		NAT_MAPPING_ENTRY="nat_1_1_mapping = $PUBLIC_IP"
	fi
	echo $NAT_MAPPING_ENTRY
}

cat << EOF > $PREFIX/etc/janus/janus.cfg
; General configuration: folders where the configuration and the plugins
; can be found, how output should be logged, whether Janus should run as
; a daemon or in foreground, default interface to use, debug/logging level
; and, if needed, shared apisecret and/or token authentication mechanism
; between application(s) and Janus.
[general]
configs_folder=$PREFIX/etc/janus		; Configuration files folder
plugins_folder=$PREFIX/lib/janus/plugins		; Plugins folder
transports_folder=$PREFIX/lib/janus/transports	; Transports folder
;log_to_stdout = false			; Whether the Janus output should be written
								; or not (default=run in foreground)
;log_to_file = /tmp/janus.log	; Whether to use a log file or not
;daemonize = true				; Whether Janus should run as a daemon
								; or not (default=run in foreground)
;pid_file = /tmp/janus.pid		; PID file to create when Janus has been
								; started, and to destroy at shutdown
;interface = 1.2.3.4		; Interface to use (will be used in SDP)
debug_level = 4				; Debug/logging level, valid values are 0-7
;debug_timestamps = yes		; Whether to show a timestamp for each log line
;debug_colors = no			; Whether colors should be disabled in the log
;api_secret = janusrocks		; String that all Janus requests must contain
;							to be accepted/authorized by the Janus core.
;							Useful if you're wrapping all Janus API requests
;							in your servers (that is, not in the browser,
;							where you do the things your way) and you
;							don't want other application to mess with
;							this Janus instance.
;token_auth = yes			; Enable a token based authentication
;							mechanism to force users to always provide
;							a valid token in all requests. Useful if
;							you want to authenticate requests from web
;							users. For this to work, the Admin API MUST
;							be enabled, as tokens are added and removed
;							through messages sent there.
admin_secret = janusoverlord	; String that all Janus requests must contain
;								  to be accepted/authorized by the admin/monitor.
;								  only needed if you enabled the admin API
;								  in any of the available transports.
;server_name = MyJanusInstance	; Public name of this Janus instance
;								  as it will appear in an info request


; Certificate and key to use for DTLS.
[certificates]
cert_pem=$PREFIX/share/janus/certs/janus.pem
cert_key=$PREFIX/share/janus/certs/janus.key


; Media-related stuff: you can configure whether if you want
; to enable IPv6 support (still WIP, so handle with care), the maximum size
; of the NACK queue for retransmissions per handle the range of ports to
; use for RTP and RTCP (by default, no range is envisaged), the
; starting MTU for DTLS (1472 by default, it adapts automatically),
; if BUNDLE should be forced (defaults to false) and if RTCP muxing should
; be forced (defaults to false).
[media]
;ipv6 = true
;max_nack_queue = 300
;rtp_port_range = 20000-40000
;dtls_mtu = 1200
;force-bundle = true
;force-rtcp-mux = true


; NAT-related stuff: specifically, you can configure the STUN/TURN
; servers to use to gather candidates if the gateway is behind a NAT,
; and srflx/relay candidates are needed. In case STUN is not enough and
; this is needed (it shouldn't), you can also configure Janus to use a
; TURN server; please notice that this does NOT refer to TURN usage in
; browsers, but in the gathering of relay candidates by Janus itself,
; e.g., if you want to limit the ports used by a Janus instance on a
; private machine. Furthermore, you can choose whether Janus should be
; configured to work in ICE-Lite mode (by default it doesn't). Finally,
; you can also enable ICE-TCP support (beware that it currently *only*
; works if you enable ICE Lite as well), choose which interfaces should
; be used for gathering candidates, and enable or disable the
; internal libnice debugging, if needed.
[nat]
;stun_server = stun.voip.eutelia.it
;stun_port = 3478
nice_debug = false
;ice_lite = true
;ice_tcp = true

; In case you're deploying Janus on a server which is configured with
; a 1:1 NAT (e.g., Amazon EC2), you might want to also specify the public
; address of the machine using the setting below. This will result in
; all host candidates (which normally have a private IP address) to
; be rewritten with the public address provided in the settings. As
; such, use the option with caution and only if you know what you're doing.
; Besides, it's still recommended to also enable STUN in those cases,
; and keep ICE Lite disabled as it's not strictly speaking a public server.
$(get_nat_mapping_entry)

; You can configure a TURN server in two different ways: specifying a
; statically configured TURN server, and thus provide the address of the
; TURN server, the transport (udp/tcp/tls) to use, and a set of valid
; credentials to authenticate...
;turn_server = myturnserver.com
;turn_port = 3478
;turn_type = udp
;turn_user = myuser
;turn_pwd = mypassword

; ... or you can make use of the TURN REST API to get info on one or more
; TURN services dynamically. This makes use of the proposed standard of
; such an API (https://tools.ietf.org/html/draft-uberti-behave-turn-rest-00)
; which is currently available in both rfc5766-turn-server and coturn.
; You enable this by specifying the address of your TURN REST API backend,
; the HTTP method to use (GET or POST) and, if required, the API key Janus
; must provide.
;turn_rest_api = http://yourbackend.com/path/to/api
;turn_rest_api_key = anyapikeyyoumayhaveset
;turn_rest_api_method = GET

; You can also choose which interfaces should be explicitly used by the
; gateway for the purpose of ICE candidates gathering, thus excluding
; others that may be available. To do so, use the 'ice_enforce_list'
; setting and pass it a comma-separated list of interfaces or IP addresses
; to enforce. This is especially useful if the server hosting the gateway
; has several interfaces, and you only want a subset to be used. Any of
; the following examples are valid:
;     ice_enforce_list = eth0
;     ice_enforce_list = eth0,eth1
;     ice_enforce_list = eth0,192.168.
;     ice_enforce_list = eth0,192.168.0.1
; By default, no interface is enforced, meaning Janus will try to use them all.
;ice_enforce_list = eth0

; In case you don't want to specify specific interfaces to use, but would
; rather tell Janus to use all the available interfaces except some that
; you don't want to involve, you can also choose which interfaces or IP
; addresses should be excluded and ignored by the gateway for the purpose
; of ICE candidates gathering. To do so, use the 'ice_ignore_list' setting
; and pass it a comma-separated list of interfaces or IP addresses to
; ignore. This is especially useful if the server hosting the gateway
; has several interfaces you already know will not be used or will simply
; always slow down ICE (e.g., virtual interfaces created by VMware).
; Partial strings are supported, which means that any of the following
; examples are valid:
;     ice_ignore_list = vmnet8,192.168.0.1,10.0.0.1
;     ice_ignore_list = vmnet,192.168.
; Just beware that the ICE ignore list is not used if an enforce list
; has been configured. By default, Janus ignores all interfaces whose
; name starts with 'vmnet', to skip VMware interfaces:
ice_ignore_list = vmnet

; You can choose which of the available plugins should be
; enabled or not. Use the 'disable' directive to prevent Janus from
; loading one or more plugins: use a comma separated list of plugin file
; names to identify the plugins to disable. By default all available
; plugins are enabled and loaded at startup.
[plugins]
; disable = libjanus_voicemail.so,libjanus_recordplay.so

; You can choose which of the available transports should be enabled or
; not. Use the 'disable' directive to prevent Janus from loading one
; or more transport: use a comma separated list of transport file names
; to identify the transports to disable. By default all available
; transports are enabled and loaded at startup.
[transports]
; disable = libjanus_rabbitmq.so
EOF
