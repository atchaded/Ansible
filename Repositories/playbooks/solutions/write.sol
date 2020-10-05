---
- name: Install the IIS web service
  hosts: win1.example.com

  tasks:
    - name: IIS service installed
      win_feature:
        name: Web-Server
        state: present

    - name: IIS service started
      win_service:
        name: W3Svc
        state: started

    - name: Website index.html created
      win_copy:
        content: "Hello World!"
        dest: C:\Inetpub\wwwroot\index.html