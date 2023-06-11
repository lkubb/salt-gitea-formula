# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

{%- if gitea._generate_token %}

Gitea internal token file is generated:
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

Gitea configuration is managed:
  file.managed:
    - name: {{ gitea.lookup.paths.conf | path_join("app.ini") }}
    - source: {{ files_switch(
                    ["app.ini", "app.ini.j2"],
                    config=gitea,
                    lookup="Gitea configuration is managed"
                 )
              }}
    - template: jinja
    - mode: '0640'
    - user: root
    - group: {{ gitea.lookup.group }}
    - require:
      - sls: {{ sls_package_install }}
{%- if gitea._generate_token %}
      - Gitea internal token file is generated
{%- endif %}
    - context:
        gitea: {{ gitea | json }}
