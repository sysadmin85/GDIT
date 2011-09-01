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
	
key_table = "<table>"
key_table += "\t<tr><th>Segment Id</th><th>Activity Type</th><th>Answer Key</th></tr>\n"

cnt = 0
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
				key = args[0].getAttribute("nCorrect");
				
				
				
				
				if(type != "") :
					row_alt = cnt % 2
					row_css = "row"
					if(row_alt == 0) :
						row_css = "alt_row"
					
					
					key_table += "\t<tr><td class=\"" + row_css + "\">" + seg_id + "</td><td class=\"" + row_css + "\">" + type + "</td><td class=\"" + row_css + "\">" + key + "</td></tr>\n"
					
					cnt += 1
						
						
key_table += "</table>"
clip_output = """<html>
<head>
<title>Answer Keys</title>
<style>
.row{
background-color:#CCCCCC;
}
.alt_row{
background-color:#FFFFFF;
}
td{
padding: 5px;
}
table{
border:1px solid #000000;
}
th{
background-color:#999999;
text-align:left;
}
</style>

</head>



<body>
<h1>Course Activity Key</h1>



"""



clip_output += key_table + "</body></html>"


clip_file = 'collateral/reports/ActivityKeyReport.html'
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

		
