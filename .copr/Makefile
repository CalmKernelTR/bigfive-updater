# COPR build configuration
# https://docs.pagure.org/copr.copr/user_documentation.html
#
# Note: Currently using GitHub Actions workflow (.github/workflows/copr.yml)
# for COPR builds. This Makefile is kept for potential future use with
# COPR's native "make srpm" method.

.PHONY: srpm

srpm:
	dnf install -y rpm-build rpmdevtools
	rpmdev-setuptree
	cp packaging/rpm/bigfive-updater.spec ~/rpmbuild/SPECS/
	spectool -g -C ~/rpmbuild/SOURCES packaging/rpm/bigfive-updater.spec
	rpmbuild -bs ~/rpmbuild/SPECS/bigfive-updater.spec \
		--define "_srcrpmdir $(outdir)"
