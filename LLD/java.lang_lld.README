This script depends on cmdline-jmxclient (Available here: http://crawler.archive.org/cmdline-jmxclient/cmdline-jmxclient-0.10.3.jar)
There is a line in the script where you put the full path to this jar file.

At this time, the script is also expecting authentication-free access to the JMX target.  If you would like to contribute and make this work with authentication, I am more than happy to accept pull requests.

It expects 3 arguments

* A string to be searched for (e.g. MemoryPool or GarbageCollector)
	- This could be extended, but most of what I need to discover here has been either
		- MemoryPool, or
		- GarbageCollector

* The JMX server IP address or resolvable hostname
	- Currently, templated items use the system macro, {HOST.IP}.  I suppose this could work with {HOST.CONN}, but no attempt has been made to change this yet.

* The JMX server port
	- The template expects a macro, {$JMXPORT}. Each item uses this.  It can be set as a global, template or host-level macro.


The output for LLD looks like this:

```
$ ./java.lang_lld.sh GarbageCollector 127.0.0.1 10061
{
	"data":[

		{"{#JMXBEAN}":"ConcurrentMarkSweep"},
		{"{#JMXBEAN}":"ParNew"}
	]
}

$ ./java.lang_lld.sh MemoryPool 127.0.0.1 10061
{
	"data":[

		{"{#JMXBEAN}":"Par Survivor Space"},
		{"{#JMXBEAN}":"CMS Perm Gen"},
		{"{#JMXBEAN}":"Par Eden Space"},
		{"{#JMXBEAN}":"Code Cache"},
		{"{#JMXBEAN}":"CMS Old Gen"}
	]
}
```

When coupled with a template using LLD, this prevents the aggravation inherent in having disabled items for each of the MemoryPool or GC mbeans not present.
