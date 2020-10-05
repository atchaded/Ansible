- name: Install and Configure an IIS site
  hosts: all
  tasks:

  - name: IIS and .Net 4.5 are installed
    win_feature:
      name: "{{ iis_packages_name }}"
      include_management_tools: True
      state: present

  - name: Logs directory is created
    win_file:
      path: C:\sites\logs
      state: directory

  - name: Site directory is created
    win_file:
      path: "{{ iis_site_path }}"
      state: directory

  - name: Index page for site is installed
    win_copy:
      src: 'files/index.html'
      dest: '{{ iis_site_path }}\index.html'

  - name: IIS site is created
    win_iis_website:
      name: "{{ iis_site_name }}"
      state: started
      port: "{{ iis_site_port }}"
      ip: "*"
      hostname: "{{ inventory_hostname }}"
      application_pool: DefaultAppPool
      physical_path: "{{ iis_site_path }}"
      parameters: logfile.directory:C:\sites\logs

  - name: Firewall rule is enabled
    win_firewall_rule:
      name: HTTP
      localport: "{{ iis_site_port }}"
      action: allow
      direction: in
      protocol: tcp
      state: present
      enabled: yes
