This is a simple wrapper around redis-cli to get memory usage and list length stats.
I use Redis as a broker for my Logstash setup (http://logstash.net), and this allows me to
quickly see if my indexing operations are able to keep up with the flow from my clients.

This is fairly generic, though the default key for the included template's list length check is "logstash." 
It could easily be extended to send other statistics.  For a list of server-level statistics, run:
```redis-cli INFO```

The template only has a trigger for redis-server up/down.  You'll have to create your own for any statistics 
you want to alert on.
