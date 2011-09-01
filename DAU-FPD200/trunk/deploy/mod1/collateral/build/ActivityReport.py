from xml.dom import minidom
import time, sys, os, codecs

#   this builds a list of all stypes used in a course as read from the full-struct.xml
#   -------------------------
#   input:  full-struct.xml
#   output: activities.html

#get the full struct into the struct var

try:
	struct = minidom.parse('full-struct.xml')
except:
	print "\n\tProblem opening full struct\n"
	raw_input("Press Enter to close")
	

print "reading full-struct.xml"

chapters_xml = struct.getElementsByTagName("chapter")

stypes = {}
slocations = {}
total_segments = 0;
total_activities = 0;

def getArgs(arg_node) :
	s = "<table>"
	for attribute in arg_node.attributes.keys() : 	
		s +=  "<tr><td>"+ attribute + " </td><td> " +  arg_node.attributes [ attribute ].nodeValue + "</td></tr>"	
	s += "</table>"
	return s



#loop through the chapters
for chapter in chapters_xml :

	section_xml = chapter.getElementsByTagName("section")
	
	#loop through the sections
	for section in section_xml :
	
		section_id =  section.getAttribute('id')
		clip_xml = section.getElementsByTagName("clip")
			
		#loop through clips
		for clip in clip_xml : 
		
			clip_id = section_id + "/" + clip.getAttribute('id')
			seg_xml = clip.getElementsByTagName("seg")
			
			#loop through segs
			for seg in seg_xml : 
				
				
				print seg.getAttribute('id')
				seg_id =  clip_id + "/" + seg.getAttribute('id')
				
				args = seg.getElementsByTagName("args")				
				type  = args[0].getAttribute("sType");
				
				if(type != "") :
					#print seg_id + "  " + type
					if(type in stypes) :
						stypes[type] = stypes[type] + 1
						slocations[type][seg_id] = getArgs(args[0])
						
					else:
						stypes[type] = 1
						slocations[type] = {}
						slocations[type][seg_id] = getArgs(args[0])
						
					total_activities += 1
				total_segments += 1

		

slist = "<h2>Activity List</h2>"
sbreakdown = "<h2>Activity Location</h2>"
sArgs = "<h2>Activity Breakdown</h2>"
						
for key, value in stypes.iteritems():
	slist += "<strong>" + key + "</strong>: " + str(value)+ "<br/>"
	
	tsegs = str(len(slocations[key]))
	
	sbreakdown += "<br/><strong>"+ key + "(" + tsegs + "):</strong><br/>"
	i = 1
	for loc in slocations[key].keys(): 
		sbreakdown += str(i) + ")  " + str(loc) + "<br/> "
		sArgs += "<strong>"  + str(loc) + "</strong> (" + key + ")<br />"
		
		
		#for arg, argvalue in slocations[key].iteritems():
		try:
			sArgs += str(slocations[key][loc])+ "<br/><br />"
		except:
			print "parse error"
		
		i += 1
	
	
	
			
clip_output = "<html><body><h1>Activity Report</h1>"
clip_output += "<p>Total Segments: " + str(total_segments) + "</p><p>Total Active Segments: " + str(total_activities) + "</p><hr />"
clip_output += slist + "<br /><hr />" + sbreakdown + "<br /><hr />" + sArgs + "</body></html>"


clip_file = 'collateral/reports/ActivityReport.html'
print "writing report"

try:			
	newdir = os.path.join(os.curdir, 'collateral/reports')
	if os.path.isdir(newdir):
		print "report directory allready exsists"
	else:
		print "making report directory"
		os.makedirs(newdir)


	clip_filename = os.path.join(os.curdir, clip_file)
	
	
	clip_output_file = open(clip_filename, 'w')
	clip_output_file.write(clip_output)
	clip_output_file.close()
				
except:
	print "error writting "+clip_file
			
raw_input("Press Enter to close")
			
			
			
			
			