FROM stagex/core-busybox@sha256:cac5d773db1c69b832d022c469ccf5f52daf223b91166e6866d42d6983a3b374 AS busybox
FROM stagex/core-bzip2@sha256:57e9b2b4fea6718bbe463a10e44f5cffbaad2fecada2f8f7733189c1a28be2a4 AS bzip2
FROM stagex/core-filesystem@sha256:2aaaea601e1725a8292c4c28e723db5761d892b869556f9b05c0983ba11fe30e AS filesystem
FROM stagex/core-gcc@sha256:125bd6306e7f37e57d377d5a189c0e499388aff42b22cc79acee6097357c617f AS gcc
FROM stagex/core-libffi@sha256:9acd18e59ca11fa727670725e69a976d96f85a00704dea6ad07870bff2bd4e8b AS libffi
FROM stagex/core-libunwind@sha256:4f3ead61255c1e58e7dc43a33043f297f8730ec88e068a4460e5fff09e503781 AS libunwind
FROM stagex/core-musl@sha256:d5f86324920cfc7fc34f0163502784b73161543ba0a312030a3ddff3ef8ab2f8 AS musl
FROM stagex/core-ncurses@sha256:6602a073bf9a408d1ed7c20ccc98fca974cd307fb8d1da6381fbca684a08169c AS ncurses
FROM stagex/core-openssl@sha256:8670a22fb76965f31bda1b61cd75ae39a96e1008deffe289a5d94ee4337b1cb2 AS openssl
FROM stagex/core-py-build@sha256:625b7c06114188524e8789ca5010444e13878c26e75645184b60256c0b586669 AS py-build
FROM stagex/core-py-dateutil@sha256:56a4aaeab67622b66607ec4621527039ee017e696dce3a510a12e0b5e31a5d05 AS py-dateutil
FROM stagex/core-py-flit@sha256:4f6007293e3ae1ac94ec97be03ce964321e3f0ad7311b527caa157f5fa2aa914 AS py-flit
FROM stagex/core-py-gpep517@sha256:1d4942c56e8f1651e2e7632ae2f2901a7573ed7e8184cb645348ab3b2d4a2f99 AS py-gpep517
FROM stagex/core-py-installer@sha256:935c066ff446e3f2b2b269ce1d51a63c34596caceddc1abad2771c5003703625 AS py-installer
FROM stagex/core-py-pep517@sha256:678f8fe52d5d9944ba281f878f111b474b250899293676b851557623107763a5 AS py-pep517
FROM stagex/core-py-setuptools@sha256:3558195868ec830242e047b22729b8a849336899dc105957843c9c4e75baacf0 AS py-setuptools
FROM stagex/core-py-toml@sha256:e8712e27a2e9d17f78892a4e4dd4f3823e86469143bd4eac2294d0e323f985d0 AS py-toml
FROM stagex/core-py-wheel@sha256:b5eded3ce06adbdd70ef452e7b7d07afbf0f23a2f8d6850b9511cc3f66c898c1 AS py-wheel
FROM stagex/core-python@sha256:5c5d86d66a9ebe4144154035230714b79c65227d9702fa2c2191a0451168014e AS python
FROM stagex/core-sqlite3@sha256:d8908d5a6c205639e6a408a92e7086edf3604f930775ee058a250e96b89255a2 AS sqlite3
FROM stagex/core-zlib@sha256:b35b643642153b1620093cfe2963f5fa8e4d194fb2344a5786da5717018976c2 AS zlib
FROM stagex/pallet-python@sha256:2af6ef9ca77e667753b06cf85176ba1df7704b6d42a94d97ef5e217c6423955d AS pallet-python
FROM stagex/pallet-rust@sha256:81c39a3b42b0336e439aee3c90e9e1e4da1d32425451e7222198a978eb8c2623 AS pallet-rust
FROM stagex/user-linux-pam@sha256:dfa0f1699d18674c005b2ad860d56773dc7049ab6bcd1d6b07190ad993fd9e83 AS linux-pam
FROM stagex/user-py-bcrypt@sha256:d9d3cc2a2da4cd7ef89aa1b72553a87d41e6d8495415521d929e6ed4e38b7fdc AS py-bcrypt
FROM stagex/user-py-defusedxml@sha256:66577196a2c483ed5ef87dec43580b7e5843d4c06984ef2e3637e95bb902bf1c AS py-defusedxml
FROM stagex/user-py-ldap3@sha256:005726d9c3f4177a58d0c283c6ae248fb11c3b505025ce62a66da787055286ff    AS py-ldap3
FROM stagex/user-py-pam@sha256:9e3c8bf9d53d7652374fac20805318e7627f26f756217051e99b728b3373d859      AS py-pam
FROM stagex/user-py-passlib@sha256:d210aa185483dcffe4c15c72cf2efd5286e3551fb65025418d76ac567d745205  AS py-passlib
FROM stagex/user-py-pika@sha256:873d754f559b8072774176319d9efd7c7cee13d2dfeedf9fbc9f971470c1a985     AS py-pika
FROM stagex/user-py-pyasn1@sha256:826ddae08316596c758aa92d8ba15ced7b0b3f3601a9b7570fd95e4e09dbebaf AS py-pyasn1
FROM stagex/user-py-pytz@sha256:d02fa1f128e27aa49040d35196c519c3633744e7fad7dfb13eb459a42957dc18     AS py-pytz
FROM stagex/user-py-requests@sha256:1d26793e53751887149b7ae48fb999f4e923e2d3a9c5dbec8e2bf5ee784a8a30 AS py-requests
FROM stagex/user-py-semantic-version@sha256:a03536939d365c0ed70214742631ff95a927c6a37dcc021872237b8575cd69d9 AS py-semantic-version
FROM stagex/user-py-setuptools-rust@sha256:694280bc5053b41dd11c3c0634988517dd3aa65dc86fafb16d8f1f38b4136a19 AS py-setuptools-rust
FROM stagex/user-py-setuptools-scm@sha256:9d1c56c43bc007a6f492a438c538013c367b7fe9dff388f998b560a148cf8817 AS py-setuptools-scm
FROM stagex/user-py-six@sha256:fb4cf37afcdc52a751e484dcd87b307e31d089a8b5824a0dc0df4da0a07a14a6 AS py-six
FROM stagex/user-py-vobject@sha256:c125fce2223592724816654b5a3400698d4adaba41f34065df31e9a98fcc9464  AS py-vobject
FROM stagex/user-py-waitress@sha256:271930c65e8399fcd4168470caa65ac7f44f942457d8828a6a20ff1557d9ffee AS py-waitress

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
  find /rootfs | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
EOF

FROM filesystem AS py-radicale
LABEL org.opencontainers.image.version=3.5.4
LABEL org.opencontainers.image.licenses=GPL-3.0-or-later
LABEL org.opencontainers.image.vendor=Kozea
LABEL org.opencontainers.image.authors="DR Grove Software LLC <container-images@drgrovellc.com>"
COPY --from=build-radicale /rootfs /

FROM filesystem AS radicale
LABEL org.opencontainers.image.authors="Container Builds Team <container-images@drgrovellc.com>"
LABEL org.opencontainers.image.url=https://github.com/DRGroveSoftwareLLC/radicale-kustomize
LABEL org.opencontainers.image.vendor="DR Grove Software LLC"
LABEL org.opencontainers.image.source=https://github.com/DRGroveSoftwareLLC/radicale-kustomize/Containerfile
COPY --from=busybox . /
COPY --from=gcc . /
COPY --from=musl . /
COPY --from=python . /
COPY --from=openssl . /
COPY --from=zlib . /
COPY --from=bzip2 . /
COPY --from=ncurses . /
COPY --from=sqlite3 . /
COPY --from=libffi . /
COPY --from=libunwind . /
COPY --from=linux-pam . /
COPY --from=py-bcrypt . /
COPY --from=py-dateutil . /
COPY --from=py-defusedxml . /
COPY --from=py-ldap3 . /
COPY --from=py-pam . /
COPY --from=py-passlib . /
COPY --from=py-pika . /
COPY --from=py-pyasn1 . /
COPY --from=py-radicale . /
COPY --from=py-requests . /
COPY --from=py-six . /
COPY --from=py-toml . /
COPY --from=py-vobject . /
EXPOSE 5232
VOLUME /var/lib/radicale
ENTRYPOINT [ "/usr/bin/radicale" ]
CMD [ "--hosts", "0.0.0.0:5232,[::]:5232" ]
