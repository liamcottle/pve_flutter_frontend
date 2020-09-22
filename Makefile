all:

.PHONY: android
android:
	flutter build appbundle

DEBUILDIR=deb-build
deb:
	rm -rf $(DEBUILDIR)
	mkdir $(DEBUILDIR)
	cp -a ../proxmox_dart_api_client ../proxmox_login_manager $(DEBUILDIR)/
	cd $(DEBUILDIR)/proxmox_dart_api_client; pub get
	cd $(DEBUILDIR)/proxmox_dart_api_client; pub run build_runner build
	cd $(DEBUILDIR)/proxmox_login_manager; flutter pub get
	cd $(DEBUILDIR)/proxmox_login_manager; flutter packages pub run build_runner build
	mkdir $(DEBUILDIR)/pve_flutter_frontend
	cp -a pubspec.yaml pve_flutter_frontend.iml debian/ assets/ linux/ lib/ $(DEBUILDIR)/pve_flutter_frontend/
	cd $(DEBUILDIR)/pve_flutter_frontend; flutter pub get
	cd  $(DEBUILDIR)/pve_flutter_frontend/; dpkg-buildpackage -b -uc -us

.PHONY: deb clean
clean:
	flutter clean
	rm -rf *.deb *.changes *.buildinfo $(DEBUILDIR)/ build/
