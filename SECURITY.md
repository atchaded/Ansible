# Ansible Tower Security

### Ansible Tower Administration

Only Ansible Tower System Admins can manage Ansible Tower SAML Authentication configuration.

Ansible Tower System Admins must log in with a local Ansible Tower account that maps to their NIST PRIV1 account by name.

### Identity Service Provider

Ansible Tower will use SAML authentication against NIST general realm user ID in NIST Active Directory

Ansible Tower access will be controlled SAML Team Mapping. If SAML does not return a team name configured in Ansible Tower SAML Team Mapping, the user will not be granted access.

IDAM roles control membership in dedicated AD Security Groups that map to Ansible Tower Orgs / Teams / Org Admins.

IDAM Role => AD Security Group => Ansible Tower Org / Team

### Ansible Tower IDAM Roles and AD Security Groups

Ansible Tower IDAM Roles will control membership in Ansible Tower AD Security Groups. Each IDAM role will require an owner, an approval chain, and an annual review process for membership.

Ansible Tower AD Security Groups will be maintained in a dedicated OU within the NIST Active Directory.

```
OU=Tower,OU=184 Groups,OU=184,OU=18_OISM,OU=Gaithersburg,DC=campus,DC=NIST,DC=GOV
```

### AD Security Group Names will follow this naming convention

* Tower{TeamName or ProjectName} => OISM team / project members
* AdminTower{TeamName or ProjectName} => users with special Org Admin role

### OISM Team Security Group Name Examples

| OISM Team => Tower Org / Team Group | Tower Org Admins | OISM Team |
| --- | --- | --- |
| TowerANTS | AdminTowerANTS | 181 ANTS / SIIRT team |
| TowerADST | AdminTowerADST | 188 Active Directory team |
| TowerBackups | AdminTowerBackups | 184 enterprise backup team |
| TowerDatabase | AdminTowerDatabase | 183 database admins |
| TowerDNS | AdminTowerDNS | 181 Rob Densock’s DNS guys |
| TowerFirewall | AdminTowerFirewall | 181 Robert Sorensen’s firewall team |
| TowerIaaS | AdminTowerIaaS | 184 Vik Khandelwal’s Cloud team |
| TowerLinux | AdminTowerLinux | 184 Unix Hosting team |
| TowerLIST | AdminTowerLIST | 183 Jeff Chu’s team |
| TowerNetworking | AdminTowerNetworking | 181 Network guys |
| TowerStorage | AdminTowerStorage | 184 Central File Services team |
| TowerWindows | AdminTowerWindows | 184 Windows Hosting team |

### OISM Project Security Group Name Examples

| OISM Project => Tower Org / Team Group | Tower Org Admins | OISM Project/Service |
| --- | --- | --- |
| ToweriEdison | AdminToweriEdison | iEdison Project |
| TowerServerPatching | AdminTowerServerPatching | Windows / Linux Server Patching |
| TowerServerProvisioning | AdminTowerServerProvisioning | Automated Server Provisioning |

### Mapping of AD Security Groups to Ansible Tower Orgs / Teams

* Tower{TeamName or ProjectName} => Ansible Tower Org / Team
* AdminTower{TeamName or ProjectName} => Ansible Tower Org Admin Role

### Ansible Tower Security Paradigm

Ansible Tower automatically creates new orgs / teams and places users in them.

Ansible Tower enforces a least privilege model. By default, each new org / team that is automatically created will have no resources and no permissions. An Ansible Tower System Admin or Ansible Org Admin must grant initial permissions to new Orgs / Teams.

Org Admins will grant all Org Members the following rights on all resources within their own Org only.

* Project Admin
* Inventory Admin
* Credentials Admin
* Job Admin
* Workflow Admin
* Notifications Admin

Only Org Admins can grant permissions from their own Org Resources to Teams in other Orgs. Org Members will not be able to grant permissions from their own Org Resources to Teams in other Orgs.

Sharing resources across Org boundaries facilitates automation of complex business processes that cross OISM division and team boundaries.

### SAML Attributes

SAML will return the following attributes to Ansible Tower:

* User.Firstname
* User.Lastname
* User.Email
* http://schemas.xmlsoap.org/claims/Group (SAML filtered by User MemberOf "`^Tower\*`")
* http://schemas.xmlsoap.org/claims/AdminGroup (SAML filtered by User MemberOf "`^AdminTower\*`")

**SAML Org Attribute Mapping**

SAML will search `User:memberOf(Groups) | egrep '^AdminTower' | sed -e 's/^Admin//'` to insure that list of admin group names returned to the `saml_admin_attr` match the group names names returned to the `saml_attr`.

```json
{
 "saml_attr": "http://schemas.xmlsoap.org/claims/Group",
 "remove": true,
 "saml_admin_attr": "http://schemas.xmlsoap.org/claims/AdminGroup",
 "remove_admins": true
}
```

**SAML Team Attribute Mapping**

The "`remove: true`" attribute insures that users are automatically removed from orgs and teams when they are removed from the corresponding Active Directory groups. As users changes roles in IDAM, their AD group memberships will change. SAML will automatically updates their org and team assignments the next time the users logs into Ansible Tower.

```json
{
  "saml_attr": "http://schemas.xmlsoap.org/claims/Group",
  "remove": true,
  "team_org_map": [
    { "organization": "TowerANTS", "team": "TowerANTS" },
    { "organization": "TowerADST", "team": "TowerADST" },
    { "organization": "TowerBackups", "team": "TowerBackups" },
    { "organization": "TowerDatabase", "team": "TowerDatabase" },
    { "organization": "TowerDNS", "team": "TowerDNS" },
    { "organization": "TowerFirewall", "team": "TowerFirewall" },
    { "organization": "TowerIaaS", "team": "TowerIaaS" },
    { "organization": "TowerLinux", "team": "TowerLinux" },
    { "organization": "TowerLIST", "team": "TowerLIST" },
    { "organization": "TowerNetworking", "team": "TowerNetworking" },
    { "organization": "TowerStorage", "team": "TowerStorage" },
    { "organization": "TowerWindows", "team": "TowerWindows" }
  ]
}
```
