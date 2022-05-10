# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Gitea user/group is present:
  user.present:
    - name: {{ gitea.lookup.user }}
    - home: {{ gitea.lookup.paths.work }}
    - shell: {{ gitea.lookup.shell }}
    - empty_password: true
    - fullname: Git Version Control
    - system: true
    - usergroup: {{ gitea.lookup.group == gitea.lookup.user }}
{%- if gitea.lookup.group != gitea.lookup.user %}
    - gid: {{ gitea.lookup.group }}
    - require:
      - group: {{ gitea.lookup.group }}
  group.present:
    - name: {{ gitea.lookup.group }}
    - system: true
{%- endif %}

Requirements for managing Gitea are fulfilled:
  pkg.installed:
    - pkgs: {{ gitea.lookup.requirements | json }}
  # needed to avoid exception when running gpg.get_key in unless below
  cmd.run:
    - name: gpg --list-keys
    - unless:
      - test -d "${GNUPG_HOME:-$HOME/.gnupg}"
      # the above does not work somehow
      - test -d /root/.gnupg

Gitea is available:
  file.managed:
    - names:
      - /tmp/gitea-{{ gitea.version }}:
        - source: {{ gitea.lookup.pkg.source.format(version=gitea.version, arch=gitea.lookup.arch) }}
        - source_hash: {{ gitea.lookup.pkg.source_hash.format(version=gitea.version, arch=gitea.lookup.arch) }}
      - /tmp/gitea-{{ gitea.version }}.asc:
        - source: {{ gitea.lookup.pkg.sig.format(version=gitea.version, arch=gitea.lookup.arch) }}
        - skip_verify: true
    - user: {{ gitea.lookup.user }}
    - group: {{ gitea.lookup.group }}

Gitea GPG key is present (received from keyserver):
  gpg.present:
    - name: {{ gitea.lookup.gpg.key }}
    - keyserver: {{ gitea.lookup.gpg.keyserver }}

Gitea GPG key is present (fallback):
  file.managed:
    - name: /tmp/gitea-key.asc
    - source: salt://gitea/files/default/key.asc
    - onfail:
      - Gitea GPG key is present (received from keyserver)
  module.run:
    - gpg.import_key:
      - filename: /tmp/gitea-key.asc
    - onfail:
      - Gitea GPG key is present (received from keyserver)
    - require:
      - file: /tmp/gitea-key.asc

Gitea is verified:
  module.run:
    - gpg.verify:
      - filename: /tmp/gitea-{{ gitea.version }}
      - signature: /tmp/gitea-{{ gitea.version }}.asc
    - require:
      - Gitea is available
    - require_any:
      - Gitea GPG key is present (received from keyserver)
      - Gitea GPG key is present (fallback)

Gitea binary is absent if verification failed:
  file.absent:
    - name: /tmp/gitea-{{ gitea.version }}
    - onfail:
      - Gitea is verified

Gitea directories are setup:
  file.directory:
    - names:
{%- for p in ['conf', 'work', 'custom', 'data', 'log', 'repos'] %}
      - {{ gitea.lookup.paths[p] }}
{%- endfor %}
    - makedirs: true
    - user: {{ gitea.lookup.user }}
    - group: {{ gitea.lookup.group }}
    # This prevents the web-installer from functioning, would need 0770 on /etc/gitea.
    - mode: '0750'

Gitea binary is installed:
  file.copy:
    - name: {{ gitea.lookup.paths.bin | path_join('gitea') }}
    - source: /tmp/gitea-{{ gitea.version }}
    # in case the version changed, overwrite previous binary
    - force: true
    - makedirs: true
    - user: {{ gitea.lookup.user }}
    - group: {{ gitea.lookup.group }}
    - mode: '0755'
    # only run if a new version was downloaded
    - onchanges:
      - Gitea is available
    - require:
      - Gitea is verified

Gitea service unit is available:
  file.managed:
    - name: {{ gitea.lookup.service.unit.format(name=gitea.lookup.service.name) }}
    - source: {{ files_switch(
                    ['gitea.service.j2'],
                    lookup='Gitea service unit is available',
                  ) }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ gitea.lookup.rootgroup }}
    - makedirs: true
    - context: {{ {'gitea': gitea} | json }}
    - require:
      - Gitea binary is installed
{%- if 'systemctl' | which %}
  # this executes systemctl daemon-reload
  module.run:
    - service.systemctl_reload: []
    - onchanges:
      - file: {{ gitea.lookup.service.unit.format(name=gitea.lookup.service.name) }}
{%- endif %}

Gitea setup is finished:
  test.show_notification:
    - text: >-
        Yay, Gitea setup is finished.
        The web installer will not work, so make sure you have specified
        at least the database configuration. The configuration will be installed
        after this message.
    - require:
      - Gitea user/group is present
      - Requirements for managing Gitea are fulfilled
      - Gitea directories are setup
      - Gitea binary is installed
