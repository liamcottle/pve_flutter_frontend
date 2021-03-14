# pve_flutter_frontend

Frontend for Proxmox Virtual Environment

# Setup How-To

## Get Flutter

See:
https://flutter.dev/docs/get-started/install/linux#install-flutter-manually

Make `flutter doctor` as happy as possible. Note you may need to tell it where
chromium is located, e.g., with `export CHROME_EXECUTABLE=/usr/bin/chromium`

## Get Path-Dependencies

Most dependencies can be served from pub.dev, but the frontend also depends on
to local path dependencies maintained by Proxmox.

So, in the parent folder clone both, the API client library (pure dart package)
and the login manager, serving as a base for Proxmox api2 projects.

 cd ..
 git clone git://git.proxmox.com/git/flutter/proxmox_dart_api_client.git
 cd proxmox_dart_api_client
 flutter pub get
 flutter packages pub run build_runner build --delete-conflicting-outputs


 cd ..
 git clone git://git.proxmox.com/git/flutter/proxmox_login_manager.git
 cd proxmox_login_manager
 flutter pub get
 flutter packages pub run build_runner build --delete-conflicting-outputs

Now you have made the local dependencies and their dependencies available, and
built the generated (data) model code for each.

# Run the App

## Linux native

With the dependencies setup you should cd back into this directory
(pve_flutter_frontend repository root) and also generate the model code once:

 flutter packages pub run build_runner build --delete-conflicting-outputs

Note: the `--delete-conflicting-outputs` option is normally not required, but
can come in handy during development trial/error coding.

To actually run it you can do:

 flutter run -d linux

## Build errors

If there's an error during build use the verbose `-v` flag, to make flutter
tell you what's actually going on. Quick remedies are then often rebuilding the
models, build from clean state, upgrade or downgrade flutter to the last known
working version - as we use latest master we sometimes run actually into bugs.
Or if you made code changes resulting in an error, well duh, fix those.

## Web build infos

You'll need some sort workaround for CORS in order to serve the flutter
frontend from your local dev machine, which will enable some convenient
features, like hot reload, automatic builds on changes...

This is required as CORS boundaries are any change in <scheme><addr><port>
tuples, and chrome will forbid even cross site requests to localhost on a
different port.

### Disable CORS in chrome/ium


Create a small shell script, lets name it `chrome-no-cors.sh`, with the
following content:

    #!/bin/sh
    mkdir -p /tmp/chrome || true
    /usr/bin/chromium --disable-web-security --user-data-dir="/tmp/chrome" $*

Then `chmod +x chrome-no-cors.sh` it and adapt the CHROME_EXECUTABLE env
variable:

     export CHROME_EXECUTABLE="$(realpath chrome-no-cors.sh)"

Now you can start the web based build normally:

$ flutter run -d chrome

### Use reverse proxy to allow connections to PVE and the App over the same port

Launch App in Chrome:
$ flutter run -d chrome --web-port 42000

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

# Misc.

To upgrade the proxmox_api_client dependency execute:
$ flutter packages upgrade

To build the model classes use:
$ flutter packages pub run build_runner build

If you want to login without typing your password for your
Test-Cluster, add this to the main function:

var apiClient = await proxclient.authenticate("root@pam", "yourpassword");


## Screenshots Android
adb shell settings put global sysui_demo_allowed 1
