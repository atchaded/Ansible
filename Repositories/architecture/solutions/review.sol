---
- name: Install the IIS web server on managed hosts
  hosts: win1.example.com
  tasks:
    - name: IIS Web Server is installed
      win_feature:
        name: Web-Server
        state: present

    - name: IIS Web Server is started
      win_service:
        name: W3Svc
        state: started