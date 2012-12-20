#!/usr/bin/env python

# Created by Aaron Mildenstein on 19 SEP 2012

from pyes import *
import sys

# Define the fail message
def zbx_fail():
    print "ZBX_NOTSUPPORTED"
    sys.exit(2)
    
# __main__

# We need to have two command-line args: 
# sys.argv[1]: The node name or "cluster"
# sys.argv[2]: The "key" (status, filter_size_in_bytes, etc)

if len(sys.argv) < 3:
    zbx_fail()

# Try to establish a connection to elasticsearch
try:
    conn = ES('localhost:9200',timeout=25,default_indices=[''])
except Exception, e:
    zbx_fail()


if sys.argv[1] == 'cluster':
    if sys.argv[2] == 'index_total':
        nodestats = conn.cluster_stats()
        index_total = 0
        for nodename in nodestats['nodes']:
            indexstats = nodestats['nodes'][nodename]['indices']['indexing']
            try:
                index_total += indexstats['index_total']
            except Exception, e:
                pass
        print index_total

    else:
        # Try to pull the managers object data
        try:
            escluster = managers.Cluster(conn)
        except Exception, e:
            zbx_fail()
        # Try to get a value to match the key provided
        try:
            returnval = escluster.health()[sys.argv[2]]
        except Exception, e:
            zbx_fail()
        # If the key is "status" then we need to map that to an integer
        if sys.argv[2] == 'status':
            if returnval == 'green':
                print 0
            elif returnval == 'yellow':
                print 1
            elif returnval == 'red':
                print 2
            else:
                zbx_fail()
        # Otherwise just return the value
        else:
            print returnval

else: # Not clusterwide, check the next arg

    nodestats = conn.cluster_stats()
    if sys.argv[2] == 'index_total':
        for nodename in nodestats['nodes']:
            if sys.argv[1] in nodestats['nodes'][nodename]['name']:
                indexstats = nodestats['nodes'][nodename]['indices']['indexing']
                try:
                    print indexstats['index_total']
                except Exception, e:
                    print "ZBX_NOTSUPPORTED"

    else:
        for nodename in nodestats['nodes']:
            if sys.argv[1] in nodestats['nodes'][nodename]['name']:
                nodecache = nodestats['nodes'][nodename]['indices']['cache']
                if sys.argv[2] == "filter_size_in_bytes":
                    print nodecache['filter_size_in_bytes']
                elif sys.argv[2] == "field_size_in_bytes":
                    print nodecache['field_size_in_bytes']
                elif sys.argv[2] == "field_evictions":
                    print nodecache['field_evictions']
                else:
                    print "ZBX_NOTSUPPORTED"

# End

