# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

# Since this formula does not rely on the web installer,
# the global configuration should include:
#   - database configuration
#   - secrets
# Otherwise, gitea would not run at all.
Required Gitea config is setup:
  file.managed:
    - name: {{ gitea.lookup.paths.conf | path_join('app.ini') }}
    - source: {{ files_switch(['etc/app.ini.j2'],
                              lookup='Required Gitea config is setup'
                 )
              }}
    - template: jinja
    - mode: '0640'
    - user: root
    - group: {{ gitea.lookup.group }}
    - require:
      - sls: {{ sls_package_install }}
    - context:
        gitea: {{ gitea | json }}
{%- if not gitea.secrets.internal_token and 'file://' == gitea.lookup.paths.internal_token_uri[:7] %}
  # gitea complained about permissions with mode = 640, root:git ownership
  cmd.run:
    - name: >
        {{ gitea.lookup.paths.bin | path_join('gitea') }} generate secret INTERNAL_TOKEN > '{{ gitea.lookup.paths.internal_token_uri[7:] }}' &&
        chmod 0640 '{{ gitea.lookup.paths.internal_token_uri[7:] }}' &&
        chown {{ gitea.lookup.user }}:{{ gitea.lookup.group }} '{{ gitea.lookup.paths.internal_token_uri[7:] }}'
    - creates: {{ gitea.lookup.paths.internal_token_uri[7:] }}
    - require:
      - sls: {{ sls_package_install }}
{%- endif %}

gitea-config-file-file-managed:
  file.managed:
    - name: {{ gitea.lookup.paths.custom | path_join('conf', 'app.ini') }}
    - source: {{ files_switch(['app.ini.j2'],
                              lookup='gitea-config-file-file-managed'
                 )
              }}
    - mode: '0640'
    - makedirs: true
    - dir_mode: '0750'
    - user: {{ gitea.lookup.user }}
    - group: {{ gitea.lookup.group }}
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        gitea: {{ gitea | json }}
