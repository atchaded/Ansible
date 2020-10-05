<!doctype html>
<!-- {{ ansible_managed }} -->
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Info</title>
  <style type="text/css">
    dt { font-weight: bold; }
  </style>
</head>
<body>
  <h1>{{ ansible_facts.hostname }}</h1>

  <dl>
    <dt>OS</dt>
    <dd>{{ ansible_facts.os_name }}</dd>

    <dt>Memory</dt>
    <dd>{{ ansible_facts.memtotal_mb }}</dd>

    <dt>Processor vCPUs</dt>
    <dd>{{ ansible_facts.processor_vcpus }}</dd>

    <dt>Processor Cores</dt>
    <dd>{{ ansible_facts.processor_cores }}</dd>
  </dl>
</body>
</html>
