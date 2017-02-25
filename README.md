# zammad-puppet

Puppet module for Zammad ticket system

### In your host.pp:

```
 class { 'zammad':
    zammad_domain => 'zammad.example.com',
    es_url        => 'http://127.0.0.1:9200'
 }
```
