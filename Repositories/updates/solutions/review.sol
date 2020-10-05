---
- name: Install Atom using Chocolatey and update the registry
  hosts: all
  vars:
    package_name: Atom
    package_url: https://chocolatey.org/api/v2/package/Atom/1.39.1
    package_local_path: C:\Windows\Temp\atom.nupkg

  tasks:
    - name: Atom package is retrieved on managed hosts
      win_uri:
        url: "{{ package_url }}"
        dest: "{{ package_local_path }}"
        method: GET

    - name: Atom is installed from a local source
      win_chocolatey:
        name: "{{ package_name }}"
        source: "{{package_local_path }}"
        state: present

    - name: Registry file is retrieved
      win_uri:
        url: >
          https://gitlab.example.com/student/updates/raw/master/files/RedHatTraining.reg
        dest: C:\Windows\Temp\RedHatTraining.reg
        validate_certs: no
        force_basic_auth: yes
        method: GET
        headers:
          PRIVATE-TOKEN: "{{ access_token }}"

    - name: Registry is updated
      win_regmerge:
        path: C:\Windows\Temp\RedHatTraining.reg
