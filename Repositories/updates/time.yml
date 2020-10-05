---
- name: Configure server for NTP
  hosts: all
  vars:
    time_key: 'HKLM:\SYSTEM\CurrentControlSet\Services\W32Time'

  tasks:
    - name: Configure time server type
      win_regedit:
        path: '{{ time_key }}\Parameters'
        name: Type
        data: NTP
        type: string
      notify: Restart windows time service

    - name: Configure AnnounceFlags
      win_regedit:
        path: '{{ time_key }}\Config'
        name: AnnounceFlags
        data: 5
        type: dword
      notify: Restart windows time service

    - name: Enable NTP time provider
      win_regedit:
        path: '{{ time_key }}\TimeProviders\NtpServer'
        name: Enabled
        data: 1
        type: dword
      notify: Restart windows time service

    - name: Configure upstream servers
      win_regedit:
        path: '{{ time_key }}\Parameters'
        name: NtpServer
        data: 0.rhel.pool.ntp.org,0x1
        type: string
      notify: Restart windows time service

    - name: Configure positive time correction
      win_regedit:
        path: '{{ time_key }}\Config'
        name: MaxPosPhaseCorrection
        data: 3600
        type: dword
      notify: Restart windows time service

    - name: Configure negative time correction
      win_regedit:
        path: '{{ time_key }}\Config'
        name: MaxNegPhaseCorrection
        data: 3600
        type: dword
      notify: Restart windows time service

  handlers:
    - name: Restart windows time service
      win_service:
        name: W32Time
        state: restarted
