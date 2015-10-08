## es_stats_zabbix

Use es_stats_zabbix (python module) to monitor Elasticsearch.  Extensible to
allow you to add items from the ClusterHealth, ClusterStats, ClusterState,
NodesStats, and NodesInfo APIs.  Key names can look like:

```
health[status]
clusterstats[indices.docs.count]
clusterstate[master_node]
nodeinfo[YOUR_NODE_NAME,process.max_file_descriptors]
nodestats[YOUR_NODE_NAME,process.open_file_descriptors]
```

### Caveats

 - You can't monitor any deeply nested keys with periods in the key name (like an
IP address)
 - Zabbix item key length limits you to 255 characters.  This potentially also limits
deeply nested keys.

### Installation

#### Prerequisites

**Install the `es_stats_zabbix` python module by running:**

```
(sudo) pip install es_stats_zabbix
```

This will install an _entrypoint,_ which is to say a pointer script in your
regular path.  It could be `/usr/bin/es_stats_zabbix`, or it could be at
`/usr/local/bin/es_stats_zabbix`.  You will need to determine this by running
`which es_stats_zabbix`, as the location will matter.

**Zabbix value maps**

Create the following before importing the template:

```
ES Cluster State
0 ⇒ Green
1 ⇒ Yellow
2 ⇒ Red
```

```
Exit Code
0 ⇒ SUCCESS
1 ⇒ FAIL
```

#### Configuration

**Configuration file**

Copy the provided `es_stats_zabbix.ini.sample` to the path of your choice, and drop
the `.sample` part.  Edit the file and change the `[elasticsearch]` and `[logging]`
sections now.  In the batch sections labeled `[thirty_seconds]`, `[sixty_seconds]`,
and `[five_minutes]`, be sure to change the `host` from `zabbix_host` in each to the
host you will link to the template.

**es_stats_zabbix.userparm**

Place this in the zabbix.conf.d directory of your install, or edit the zabbix_agentd.conf
file to include this one.  Edit the path to es_stats_zabbix from what is there, if needed.
Also edit the path to the configuration file as needed.

Be sure to restart your Zabbix agent afterwards.

**Import the template**

Import the template, and link it to the host (the same name you configured in the
batch configuration).  It should start collecting stats now.

**Adding batch jobs**

Follow the pattern of any of the existing batches.  Name the header inside the
square braces.  Invalid names include _elasticsearch_ and _logging._  Add items
as desired, with a unique key in front.  They are sequential in the provided
example, but the key names can be anything, except for _server,_ _port,_ and
_host,_ as these are needed for sending to Zabbix.

### Extending

You should be able to find ways to extend this by adding the keys you like.
es_stats_zabbix uses dot notation to find keys.  NodesStats and NodesInfo both
require the addition of a node name.  All keys are sub-fields of that node name
in the resulting JSON.

### Troubleshooting

The provided ini file defaults to logging to `/dev/null`.  It is much easier to
troubleshoot with a log file.  Simple change the path to somewhere your Zabbix
agent has write permissions.

#### `debug = True` vs. `loglevel = DEBUG`

There is a difference.  Setting `debug = True` will mean seeing all of the upstream
modules debug logs: `elasticsearch`, `urllib3`, etc.  This is _very_ verbose and
will probably not be necessary for you.  Setting `loglevel = DEBUG` will give the
debug logging messages of just `es_stats_zabbix` and `zbxsend`, which should make it
easy to see what's going on.
