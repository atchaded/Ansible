---
- name: System summary is compiled
  hosts: all
  tasks:
    - name: Product facts are collected
      win_product_facts:

    - name: Disk facts are collected
      win_disk_facts:

    - name: Summary is written
      win_copy:
        content: |
          OS: {{ ansible_facts['os_name'] }}
          Machine ID: {{ ansible_facts['machine_id'] }}
          Last Boot: {{ ansible_facts['lastboot'] }}
          License Status: {{ ansible_facts['os_license_status'] }}
          Disk Size: {{ ansible_facts['disks'][0]['size'] }}
        dest: "{{ ansible_facts['user_dir'] }}\\Desktop\\summary-{{ ansible_facts['hostname'] }}.txt"
