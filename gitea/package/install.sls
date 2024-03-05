# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

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

Gitea directories are setup:
  file.directory:
    - names:
{%- for p in ["conf", "work", "custom", "data", "log", "repos"] %}
      - {{ gitea.lookup.paths[p] }}
{%- endfor %}
    - makedirs: true
    - user: {{ gitea.lookup.user }}
    - group: {{ gitea.lookup.group }}
    # This prevents the web-installer from functioning, would need 0770 on /etc/gitea.
    - mode: '0750'
    - require:
      - Gitea user/group is present

Requirements for managing Gitea are fulfilled:
  pkg.installed:
    - pkgs: {{ gitea.lookup.requirements | json }}

Gitea GPG key is present:
  gpg.present:
    - name: {{ gitea.lookup.gpg.key[-16:] }}
    - keyserver: {{ gitea.lookup.gpg.keyserver }}
    - source: {{ files_switch(
                    ["key.asc"],
                    config=gitea,
                    lookup="Gitea GPG key is present",
                  )
              }}
    - require:
      - Requirements for managing Gitea are fulfilled

Gitea binary is installed:
  file.managed:
    - name: {{ gitea.lookup.paths.bin | path_join("gitea") }}
    - source: {{ gitea.lookup.pkg.source.format(version=gitea.version, arch=gitea.lookup.arch) }}
    - source_hash: {{ gitea.lookup.pkg.source_hash.format(version=gitea.version, arch=gitea.lookup.arch) }}
    - signature: {{ gitea.lookup.pkg.sig.format(version=gitea.version, arch=gitea.lookup.arch) }}
    - signed_by_any: {{ gitea.lookup.gpg.key | json }}
    - makedirs: true
    - user: {{ gitea.lookup.user }}
    - group: {{ gitea.lookup.group }}
    - mode: '0755'
    - require:
      - Gitea GPG key is present
      - Gitea user/group is present

Gitea service unit is available:
  file.managed:
    - name: {{ gitea.lookup.service.unit.format(name=gitea.lookup.service.name) }}
    - source: {{ files_switch(
                    ["gitea.service", "gitea.service.j2"],
                    config=gitea,
                    lookup="Gitea service unit is available",
                  )
              }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ gitea.lookup.rootgroup }}
    - makedirs: true
    - context: {{ {"gitea": gitea} | json }}
    - require:
      - Gitea binary is installed

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
