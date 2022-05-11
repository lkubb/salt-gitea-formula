# -*- coding: utf-8 -*-
# vim: ft=yaml
---
gitea:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    config: '/etc/gitea/app.ini'
    service:
      name: gitea
    build_user: giteabuild
    build_user_home: /home/giteabuild
    go:
      pkg: https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
      source_hash: e54bec97a1a5d230fc2f9ad0880fcbabb5888f30ed9666eca4a91c5a32e86cbc
    gpg:
      key: 7C9E68152594688862D62AF62D9AE806EC1592E2
      keyserver: keys.openpgp.org
    group: git
    mod_rst:
      chroma_bin: /opt/chroma/chroma
      chroma_build_path: /opt/chroma/src
      chroma_repo: https://github.com/alecthomas/chroma
      chroma_rev: HEAD
      path: /usr/local/bin/grst
      pip_dependencies:
        - docutils
      pkg_dependencies:
        - python3
        - python3-pip
    paths:
      bin: /opt/gitea
      conf: /etc/gitea
      custom: /var/lib/gitea/custom
      data: /var/lib/gitea/data
      internal_token_uri: file:///etc/gitea/internal_token
      log: /var/log/gitea
      repos: /var/lib/gitea/data/gitea-repositories
      work: /var/lib/gitea
    pkg:
      latest: https://dl.gitea.io/gitea/version.json
      sig: https://dl.gitea.io/gitea/{version}/gitea-{version}-linux-{arch}.asc
      source: https://dl.gitea.io/gitea/{version}/gitea-{version}-linux-{arch}
      source_hash: https://dl.gitea.io/gitea/{version}/gitea-{version}-linux-{arch}.sha256
    requirements:
      - git
      - gpg
      - python-gnupg
    shell: /bin/bash
    user: git
  config:
    database:
      db_type: sqlite3
    default:
      app_name: Gitea
      run_mode: prod
      run_user: git
    log:
      level: Info
      mode: console
      stacktrace_level: None
    oauth2:
      jwt_secret: ''
    repository.signing:
      signing_key: default
    security:
      internal_token: ''
      secret_key: ''
    server:
      domain: localhost
      http_addr: 0.0.0.0
      http_port: 3000
      lfs_jwt_secret: ''
      protocol: http
  service:
    requires_mount: []
    socket_activation: false
    wants: []
  version: latest

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://gitea/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   gitea-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      gitea-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
