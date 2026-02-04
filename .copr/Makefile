# COPR build configuration
# https://docs.pagure.org/copr.copr/user_documentation.html

.PHONY: srpm

srpm:
	dnf install -y rpm-build rpmdevtools
	spectool -g -R packaging/rpm/bigfive-updater.spec
	rpmbuild -bs packaging/rpm/bigfive-updater.spec \
		--define "_sourcedir $(PWD)" \
		--define "_srcrpmdir $(outdir)"
