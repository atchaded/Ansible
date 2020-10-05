---
- name: Configure database host
  hosts: win1.example.com
  vars:
    db_drive_letter: S
    powershell_gallery_endpoint: https://www.powershellgallery.com/api/v2/
    powershell_modules:
      - SqlServer

  tasks:
    - name: Disk facts are populated
      win_disk_facts:

    - name: Second disk extracted as standalone fact
      set_fact:
        second_disk: "{{ ansible_facts['disks'] | json_query('[?number==`1`]') }}"

    - name: Initialize second disk if required
      win_shell: "Initialize-Disk -Number 1"
      when: second_disk[0]['guid'] is none

    - name: Partition is created on second disk
      win_partition:
        disk_number: 1
        drive_letter: "{{ db_drive_letter }}"
        partition_size: 2 GiB
      register: partition_task

    - name: New partition is formatted
      win_format:
        drive_letter: "{{ db_drive_letter }}"
        file_system: NTFS
        new_label: db
        full: true
      when: partition_task['changed']

    - name: Defrag scheduled task is created
      win_scheduled_task:
        name: DefragDBDrive
        description: Degfragment the database drive
        actions:
        - path: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
          arguments: >
            -ExecutionPolicy Unrestricted
            -NonInteractive
            -Command {Optimize-Volume -DriveLetter {{ db_drive_letter }} -Defrag -Verbose}
        triggers:
        - type: weekly
          days_of_week: sunday
          start_boundary: '2019-09-29T03:05:00'
        username: SYSTEM
        run_level: highest
        state: present

    - name: Current PowerShell repositories are unregistered
      win_shell: Unregister-PSRepository "{{ item }}"
      ignore_errors: true
      loop:
        - PowerShell Gallery
        - PSGallery

    - name: PowerShell Gallery repository is added
      win_psrepository:
        source: "{{ powershell_gallery_endpoint }}"
        name: PowerShell Gallery
        state: present

    - name: PowerShell Gallery repository is queried
      win_shell: Get-PSRepository "PowerShell Gallery"
      register: repo_status
      failed_when: repo_status.rc != 0
      changed_when: false

    - name: PowerShell modules for database support are installed
      win_psmodule:
        name: "{{ item }}"
        state: present
      loop: "{{ powershell_modules }}"

