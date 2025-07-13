FROM stagex/core-py-build:0.7.0@sha256:a49bbdb57a72da7d28a6de6225f102adda246f7fc4e2c7da104176721f90eb18 AS py-build
FROM stagex/core-py-dateutil:2.9.0.post0@sha256:16ab425dcdca1a3c85d9d323f1f82290addebd2c475a62572cfe7560ae14019f AS py-dateutil
FROM stagex/core-py-flit:3.9.0@sha256:5dab7b99eeaacd2304dc41481ca847784e68a2c2eb22b0ba9040895259f9a679 AS py-flit
FROM stagex/core-py-gpep517:16@sha256:391dbcfecf5c5a0a882a993c75fa988e65f0c00b979a247d1f11b80c28d646b4 AS py-gpep517
FROM stagex/core-py-installer:0.7.0@sha256:c91f0dab85e781369f3e1eda70f49f8561c1914e7f9869c1a102374e8d7a8318 AS py-installer
FROM stagex/core-py-pep517:0.9.1@sha256:b88d2fd6a55588339fa09728344fbe77700194f5eafc36be862623ae077a0be9 AS py-pep517
FROM stagex/core-py-setuptools:68.2.2@sha256:1c2a449669de0691921b8c00114035a1e35d9b8cb7850a07b935cecaede4e525 AS py-setuptools
FROM stagex/core-py-toml:0.12.2@sha256:ce93e42303dd9ecd02c4f4eb0585e7e92fff2f527982ce2dee58b75846601fcd AS py-toml
FROM stagex/core-py-wheel:0.43.0@sha256:02c043de13660264e8abda94d7993848cc50471a949c5f35520db514de9df9f0 AS py-wheel
FROM stagex/pallet-python@sha256:d8d64797832576ff8fbb3472d5d9f203e38ebe8b1c3fadc37a44edc407e86315 AS pallet-python
FROM stagex/pallet-rust@sha256:3b5b5c92f6bf0a4073fb9cbfb7d4b9c6136292c2aff6537a54b09a5202116d98 AS pallet-rust
FROM stagex/user-linux-pam:1.6.1@sha256:bce86aad9688305a6684fe707bb90ac2d76b475d588ae2b109b9aedff4b7cf68 AS linux-pam
FROM stagex/user-py-requests:2.32.3@sha256:1d8185be7a08bc68b2e791be317fa9f562bd846b0928f8cfffdbc5372bdd9c3b AS py-requests
FROM stagex/user-py-semantic-version:2.10.0@sha256:4e83d804b1e7d76730ca10b7d6f781964c4b074a1db3db548c339190f2596667 AS py-semantic-version
FROM stagex/user-py-setuptools-scm:8.0.4@sha256:328c083af9954d8a3b17068aea309abfa0b5990968521968f4886097f08ef635 AS py-setuptools-scm

# py-six
FROM scratch AS build-py-six
COPY --from=pallet-python . /
COPY --from=py-setuptools . /
ADD \
  --checksum=sha256:1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926 \
  https://files.pythonhosted.org/packages/source/s/six/six-1.16.0.tar.gz \
  /
RUN tar zxvf /six-1.16.0.tar.gz
WORKDIR /six-1.16.0/
RUN --network=none <<-EOF
  set -eu
  python setup.py install --root /rootfs --optimize=1
  install -Dm644 LICENSE -t /rootfs/usr/share/licenses/py-six/
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-six
COPY --from=build-py-six /rootfs /

# py-setuptools-rust
FROM scratch AS build-py-setuptools-rust
COPY --from=pallet-python . /
COPY --from=py-flit . /
COPY --from=py-gpep517 . /
COPY --from=py-installer . /
COPY --from=py-setuptools . /
COPY --from=py-setuptools-scm . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:7891482400f8511739f727f4045dcd72b41bf689e4e5b90c97ff98daee5dbe85 \
  https://github.com/PyO3/setuptools-rust/archive/refs/tags/v1.11.1.tar.gz \
  /
RUN tar zxvf /v1.11.1.tar.gz
WORKDIR /setuptools-rust-1.11.1/
ENV SETUPTOOLS_SCM_PRETEND_VERSION=1.11.1
RUN --network=none <<-EOF
  set -eu
  gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2
	python -m installer -d /rootfs .dist/*.whl
	find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-setuptools-rust
COPY --from=build-py-setuptools-rust /rootfs /

# py-bcrypt
FROM scratch AS build-py-bcrypt
COPY --from=pallet-python . /
COPY --from=pallet-rust . /
COPY --from=py-build . /
COPY --from=py-installer . /
COPY --from=py-pep517 . /
COPY --from=py-semantic-version . /
COPY --from=py-setuptools . /
COPY --from=py-setuptools-rust . /
COPY --from=py-toml . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:5cf3964765a9e2ed592ceb721948592f6227abcf22dd7314c897363ddd49ac3e \
  https://github.com/pyca/bcrypt/archive/refs/tags/4.3.0.tar.gz \
  /
RUN tar zxvf /4.3.0.tar.gz
WORKDIR /bcrypt-4.3.0/src/_bcrypt
RUN cargo fetch
WORKDIR /bcrypt-4.3.0/
RUN --network=none <<-EOF
  set -eu
  python -m build --wheel --no-isolation
  python -m installer -d /rootfs dist/*.whl
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-bcrypt
COPY --from=build-py-bcrypt /rootfs /

# py-defusedxml
FROM scratch AS build-py-defusedxml
COPY --from=pallet-python . /
COPY --from=py-build . /
COPY --from=py-installer . /
COPY --from=py-pep517 . /
COPY --from=py-setuptools . /
COPY --from=py-toml . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:93cdbc6c5c9d3dc08991a9804253933491a5a7f3c2d8583e54337e5469c73849 \
  https://github.com/tiran/defusedxml/archive/refs/tags/v0.7.1.tar.gz \
  /
RUN tar zxvf /v0.7.1.tar.gz
WORKDIR /defusedxml-0.7.1/
RUN --network=none <<-EOF
  set -eu
  python -m build --wheel --skip-dependency-check --no-isolation
  python -m installer -d /rootfs dist/*.whl
  install -D -m0644 LICENSE /rootfs/usr/share/license/py-defusedxml/LICENSE
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-defusedxml
COPY --from=build-py-defusedxml /rootfs /

# py-passlib
FROM scratch AS build-py-passlib
COPY --from=pallet-python . /
COPY --from=py-setuptools . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04 \
  https://pypi.io/packages/source/p/passlib/passlib-1.7.4.tar.gz \
  /
RUN tar zxvf /passlib-1.7.4.tar.gz
WORKDIR /passlib-1.7.4/
RUN --network=none <<-EOF
  set -eu
  python setup.py install -O1 --root=/rootfs
  install -Dm644 LICENSE /rootfs/share/licenses/py-passlib/LICENSE
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-passlib
COPY --from=build-py-passlib /rootfs /

# py-pika
FROM scratch AS build-py-pika
COPY --from=pallet-python . /
COPY --from=py-build . /
COPY --from=py-installer . /
COPY --from=py-pep517 . /
COPY --from=py-setuptools . /
COPY --from=py-toml . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:5eb71b9a0047c77d99378e525a2041fc50aae4a177b060f9825b3e2fdcc96fc4 \
  https://github.com/pika/pika/archive/refs/tags/1.3.2.tar.gz \
  /
RUN tar zxvf /1.3.2.tar.gz
WORKDIR /pika-1.3.2/
RUN --network=none <<-EOF
  set -eu
  python -m build --wheel --no-isolation
  python -m installer --destdir=/rootfs dist/*.whl
  install -D -m644 LICENSE /rootfs/usr/share/licenses/py-pika/LICENSE
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-pika
LABEL org.opencontainers.image.revision=1.3.2
LABEL org.opencontainers.image.licenses=BSD-3-Clause
COPY --from=build-py-pika /rootfs /

# py-pytz
FROM scratch AS build-py-pytz
COPY --from=pallet-python . /
COPY --from=py-setuptools . /
ADD \
  --checksum=sha256:360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3 \
  https://pypi.io/packages/source/p/pytz/pytz-2025.2.tar.gz \
  /
RUN tar zxvf /pytz-2025.2.tar.gz
WORKDIR /pytz-2025.2/
RUN --network=none <<-EOF
  set -eu
  python setup.py build
  python setup.py install --root=/rootfs/
  install -Dm644 LICENSE.txt /rootfs/usr/share/licenses/py-pytz/LICENSE
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-pytz
LABEL org.opencontainers.image.revision=2025.2
LABEL org.opencontainers.image.licenses=MIT
COPY --from=build-py-pytz /rootfs /

# py-vobject
FROM scratch AS build-py-vobject
COPY --from=pallet-python . /
COPY --from=py-build . /
COPY --from=py-dateutil . /
COPY --from=py-installer . /
COPY --from=py-pep517 . /
COPY --from=py-pytz . /
COPY --from=py-setuptools . /
COPY --from=py-six . /
COPY --from=py-toml . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:2adfc34728d9d45b7b9ea215291aab34ae5d1e5a57a566ccd26710757ffd8e0f \
  https://github.com/py-vobject/vobject/archive/refs/tags/v0.9.9.tar.gz \
  /
RUN tar zxvf /v0.9.9.tar.gz
WORKDIR /vobject-0.9.9/
RUN --network=none <<-EOF
  set -eu
  python -m build --wheel --skip-dependency-check --no-isolation
  python -m installer --destdir=/rootfs/ dist/*.whl
  # install -vDm 644 {ACKNOWLEDGEMENTS.txt,README.md} -t /rootfs/usr/share/py-vobject/
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-vobject
LABEL org.opencontainers.image.revision=0.9.9
LABEL org.opencontainers.image.licenses=Apache-2.0
COPY --from=build-py-vobject /rootfs /

# py-asn1
FROM scratch AS build-py-pyasn1
COPY --from=pallet-python . /
COPY --from=py-build . /
COPY --from=py-installer . /
COPY --from=py-pep517 . /
COPY --from=py-setuptools . /
COPY --from=py-toml . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:40179525f1622c0786df08b6a3766b7a03fe40ac74b4e4d93f5cd5608a4c39f3 \
  https://github.com/pyasn1/pyasn1/archive/refs/tags/v0.6.1.tar.gz\
  /
RUN tar zxvf /v0.6.1.tar.gz
WORKDIR /pyasn1-0.6.1/
RUN --network=none <<-EOF
  set -eu
  python -m build -nw
  python -m installer -d /rootfs dist/*.whl
  install -Dm644 LICENSE.rst /rootfs/usr/share/licenses/py-pyasn1/LICENSE.rst
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-pyasn1
LABEL org.opencontainers.image.revision=0.6.1
LABEL org.opencontainers.image.licenses=BSD-2-Clause
COPY --from=build-py-pyasn1 /rootfs /

# py-ldap3
FROM scratch AS build-py-ldap3
COPY --from=pallet-python . /
COPY --from=py-setuptools . /
COPY --from=py-wheel . /
COPY --from=py-pyasn1 . /
ADD \
  --checksum=sha256:d7482a10dabd90e8d3ca3dc9288af3e5c8e9547f5f17f676db1e983cafdd78b9 \
  https://github.com/cannatag/ldap3/archive/v2.9.1.tar.gz \
  /
RUN tar zxvf /v2.9.1.tar.gz
WORKDIR /ldap3-2.9.1/
RUN --network=none <<-EOF
  set -eu
  python setup.py build
  python setup.py install --root=/rootfs --optimize=1
  install -Dm644 LICENSE.txt /rootfs/usr/share/licenses/py-ldap3/LICENSE
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-ldap3
LABEL org.opencontainers.image.revision=2.9.1
LABEL org.opencontainers.image.licenses=LGPL
COPY --from=build-py-ldap3 /rootfs /

# py-pam
FROM scratch AS build-py-pam
COPY --from=linux-pam . /
COPY --from=pallet-python . /
COPY --from=py-build . /
COPY --from=py-installer . /
COPY --from=py-pep517 . /
COPY --from=py-setuptools . /
COPY --from=py-six . /
COPY --from=py-toml . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:23f5fd680b43d9dc8c96061c2c855f7c4758ee29c5d9f3cc469b558a0afd558b \
  https://github.com/FirefighterBlu3/python-pam/archive/refs/tags/v2.0.2.tar.gz \
  /
RUN tar zxvf /v2.0.2.tar.gz
WORKDIR /python-pam-2.0.2/
RUN --network=none <<-EOF
  set -eu
  python -m build --wheel --no-isolation
  python -m installer --destdir=/rootfs dist/*.whl
  install -Dm644 LICENSE /rootfs/usr/share/licenses/py-pam/LICENSE
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM stagex/core-filesystem AS py-pam
LABEL org.opencontainers.image.revision=2.0.2
LABEL org.opencontainers.image.licenses=MIT
COPY --from=build-py-pam /rootfs /

# py-waitress
FROM scratch AS build-py-waitress
COPY --from=pallet-python . /
COPY --from=py-build . /
COPY --from=py-installer . /
COPY --from=py-pep517 . /
COPY --from=py-setuptools . /
COPY --from=py-toml . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:4c5583cee40bee842b48443ed899b5d445947c5d88fe170d31c3becab09710c3 \
  https://github.com/Pylons/waitress/archive/refs/tags/v3.0.2.tar.gz \
  /
RUN tar zxvf /v3.0.2.tar.gz
WORKDIR /waitress-3.0.2/
RUN --network=none <<-EOF
  set -eu
  python -m build --wheel --no-isolation
  python -m installer --destdir=/rootfs dist/*.whl
  install -Dm644 LICENSE.txt /rootfs/usr/share/licenses/py-waitress/LICENSE.txt
EOF

FROM stagex/core-filesystem AS py-waitress
LABEL org.opencontainers.image.revision=3.0.2
LABEL org.opencontainers.image.licenses=ZPL-2.1
COPY --from=build-py-pam /rootfs /

# radicale
FROM scratch AS build-radicale
COPY --from=pallet-python . /
COPY --from=py-bcrypt . /
COPY --from=py-build . /
COPY --from=py-defusedxml . /
COPY --from=py-installer . /
COPY --from=py-ldap3 . /
COPY --from=py-passlib . /
COPY --from=py-pep517 . /
COPY --from=py-pika . /
COPY --from=py-setuptools . /
COPY --from=py-toml . /
COPY --from=py-vobject . /
COPY --from=py-wheel . /
ADD \
  --checksum=sha256:dcbfb7ab0b2f89cab0f566ea179d768a5016597b0c1f177431a123de57509b3b \
  https://github.com/Kozea/Radicale/archive/refs/tags/v3.5.4.tar.gz \
  /
RUN tar zxvf /v3.5.4.tar.gz
WORKDIR /Radicale-3.5.4/
RUN --network=none <<-EOF
  set -eu
  python -m build --wheel --no-isolation
  python -m installer --destdir=/rootfs dist/*.whl
  install -vDm 644 config -t /rootfs/etc/radicale/
  install -vDm 644 rights -t /rootfs/etc/radicale/
  touch users
  install -vDm 644 users -t /rootfs/etc/radicale/
  install -vDm 644 radicale.wsgi -t /rootfs/usr/share/radicale/radicale.wsgi
  install -vDm 644 CHANGELOG.md -t /rootfs/usr/share/doc/radicale/CHANGELOG.md
  install -vDm 644 DOCUMENTATION.md -t /rootfs/usr/share/doc/radicale/DOCUMENTATION.md
  install -vDm 644 README.md -t /rootfs/usr/share/doc/radicale/README.md
  install -vDm 644 COPYING.md /rootfs/usr/share/licenses/radicale/COPYING.md
EOF

FROM stagex/core-filesystem AS py-radicale
LABEL org.opencontainers.image.revision=3.5.4
LABEL org.opencontainers.image.licenses=GPL-3.0-or-later
COPY --from=build-radicale /rootfs /

FROM stagex/pallet-python AS radicale
COPY --from=pallet-rust . /
COPY --from=linux-pam . /
COPY --from=py-bcrypt . /
COPY --from=py-dateutil . /
COPY --from=py-defusedxml . /
COPY --from=py-ldap3 . /
COPY --from=py-pam . /
COPY --from=py-passlib . /
COPY --from=py-pika . /
COPY --from=py-radicale . /
COPY --from=py-requests . /
COPY --from=py-six . /
COPY --from=py-toml . /
COPY --from=py-vobject . /
EXPOSE 5232
VOLUME /var/lib/radicale
ENTRYPOINT [ "/usr/bin/radicale" ]
CMD [ "--hosts", "0.0.0.0:5232,[::]:5232" ]
