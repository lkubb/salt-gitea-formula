# -*- coding: utf-8 -*-
# vim: ft=yaml
---
gitea:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    config: '/var/opt/gitea/custom/conf/app.ini'
    service:
      name: gitea
    gpg:
      key: 7C9E68152594688862D62AF62D9AE806EC1592E2
      keyserver: keys.openpgp.org
    group: git
    paths:
      bin: /opt/gitea
      conf: /etc/opt/gitea
      custom: /var/opt/gitea/custom
      data: /var/opt/gitea/data
      home: /var/opt/gitea/home
      internal_token_uri: file:///etc/opt/gitea/internal_token
      log: /var/opt/gitea/log
      repos: /var/opt/gitea/data/gitea-repositories
      work: /var/opt/gitea
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
    default:
      app_name: Gitea
      run_mode: prod
      run_user: git
    log:
      level: Info
      mode: console
      stacktrace_level: None
    repository.signing:
      signing_key: default
    server:
      domain: localhost
      http_addr: 0.0.0.0
      http_port: 3000
      protocol: http
  database:
    db_type: sqlite3
    name: gitea
    password: hunter1
    user: root
  secrets:
    internal_token: ''
    jwt_secret: ''
    lfs_jwt_secret: ''
    secret_key: ''
  service:
    requires_mount: []
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
