---
- name: Example playbook
  hosts: windows
  tasks:
    - name: Spooler service is enabled and running
      win_service:
        name: Spooler
        start_mode: auto
        state: running

