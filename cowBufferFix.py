#!/usr/bin/python

import subprocess,re,glob,mmap

# Create list of agents and store in agentList

agents = subprocess.Popen(('snapctl', 'list'), stdout=subprocess.PIPE)
output = agents.communicate()[0]
agentList = ' '.join(output.splitlines()).split()[0::2] 

print "\nAll agents:",agentList

# Search for agents with a cowBuffer file already. Don't search for them.

myAgents = []
for file in glob.glob("/datto/config/keys/*.cowBuffer"):

        filename = file.rstrip(".cowBuffer")
        filename = filename.lstrip("/datto/config/keys/")
        myAgents.append(filename)

# Compare the lists and only search for those without a cowBuffer fix
# and print the names

newList = list(set(agentList).difference(myAgents))
print "Agents without cowBuffer fix:",newList,"\n"

# Iterate through the list, find matches greater than 200 once.
# If value is found, create the file.

# For future, add ability to search through gz files.

for agent in newList:

        print "Looking for matches for agent: " + agent
        agentFilename = "/datto/config/keys/" + agent + ".log"
        agentLog = open(agentFilename, 'r')

        # Create mmap as this is much faster than loading whole agent log
        # into memory. Perform regex search and put into capture group.

        s = mmap.mmap(agentLog.fileno(), 0, access=mmap.ACCESS_READ)
        reg = re.compile("Creating ([2-9][0-9][0-9]) megabyte cow")
        m = reg.search(s)
        agentLog.close()

        # If match is found, create file. If not, print no match

        if m:
                print "Found " + m.group(1) + " megabyte cow file!"
                fname = "/datto/config/keys/" + agent + ".cowBuffer"
                print "Creating file for agent " + agent + "..."
                f = open(fname, 'w')
                f.write("2000\n")
                f.close()
                print "Done!\n"
        else:
                print "No Match\n"
