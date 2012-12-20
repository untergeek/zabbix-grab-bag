The items here are for monitoring Elasticsearch (presumably for logstash).

The template xml file actually contains two templates:
1. Elasticsearch Node & Cache (which is for node-level monitoring)
2. Elasticsearch Cluster (cluster state, shard-level monitoring, record count, storage sizes, etc.)

The node name is expected as a host-level macro {$NODENAME}

There are triggers assigned for the cluster state:
0 = Green (OK)
1 = Yellow (Average, depends on "red")
2 = Red (High)

You will likely want to assign a value mapping for the ElasticSearch Cluster Status item.

In any event, the current list of included items is:

* ES Cluster (11 Items)
	- Cluster-wide records indexed per second
	- Cluster-wide storage size
	- ElasticSearch Cluster Status
	- Number of active primary shards
	- Number of active shards
	- Number of data nodes
	- Number of initializing shards
	- Number of nodes
	- Number of relocating shards
	- Number of unassigned shards
	- Total number of records
* ES Cache (2 Items)
	- Node Field Cache Size
	- Node Filter Cache Size
* ES Node (2 Items)
	- Node Storage Size
	- Records indexed per second
