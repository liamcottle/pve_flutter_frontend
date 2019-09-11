# pve_flutter_frontend

Frontend for Proxmox Virtual Environment

## Web build infos

In most dev environments you'll want to add the ssl cert of your testing cluster
to your browsers trusted ones. If you don't do this, you'll need to visit the the
clusters current web interface first to acknowledge the not trusted cert warning.
For chrome this can be done via:
$ certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n "FILENAME" -i "PATHTOYOURCERTFILE"

While this is not served directly from the proxmox host, you'll need to start
your browser with disabled web security option. This is only needed because of the
CORS rules enforced by your browser. Another option would be to allow this server
side.

Cookie workaround, login manually or serve via proxy or directly.

For chrome this can be done via:
$ google-chrome --disable-web-security --user-data-dir='/tmp/debugflutterweb'


Update dependencies:

To upgrade the api client for example you'll need to execute:
$ flutter packages upgrade