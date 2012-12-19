The items here are for monitoring Elasticsearch (presumably for logstash).

The template xml file actually contains two templates:
1. Elasticsearch Node (which is for node-level monitoring)
2. Elasticsearch Cluster (currently, only cluster state: Green, Yellow & Red)

The node name is expected as a host-level macro {$NODENAME}

There are triggers assigned for the cluster state:
0 = Green (OK)
1 = Yellow (Average, depends on "red")
2 = Red (High)

You will likely want to assign a value mapping for the ElasticSearch Cluster Status item.
