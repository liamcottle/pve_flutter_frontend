# pve_flutter_frontend

Frontend for Proxmox Virtual Environment

## Web build infos

Launch App in Chrome:
$ flutter run -d chrome --web-port 42000
You'll need some sort of reverse proxy to workaround CORS in order to serve the
flutter frontend from your local dev machine, which will enable some convenient
features, like hot reload, automatic builds on changes...

nginx snippets:

location / {

	if ( $query_string ~ "console" ) {
		proxy_pass https://<clusterip>:8006;
	}
	proxy_pass http://127.0.0.1:42000;
	proxy_read_timeout 24h;
	proxy_http_version 1.1;
	proxy_set_header Connection "";
	proxy_buffering off;

}

location /xterm {
	proxy_set_header Host $host;
	proxy_set_header Cookie $http_cookie;
	proxy_pass https://<clusterip>:8006;
}

location /api2 {
	proxy_set_header Upgrade $http_upgrade;
	proxy_set_header Connection "Upgrade";
	proxy_set_header Host $host;
	proxy_set_header Cookie $http_cookie;
	proxy_pass https://<clusterip>:8006;
}

To upgrade the proxmox_api_client dependency execute:
$ flutter packages upgrade

To build the model classes use:
$ flutter packages pub run build_runner build

If you want to login without typing your password for your
Test-Cluster, add this to the main function:

var apiClient = await proxclient.authenticate("root@pam", "yourpassword");