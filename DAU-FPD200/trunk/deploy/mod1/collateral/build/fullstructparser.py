from xml.dom import minidom
import time, sys, os, codecs

#   full-struct.xml parser
#   -------------------------
#   input:  full-struct.xml
#   output: full-struct.html



#get the full struct into the struct var

try:
	struct = minidom.parse('full-struct.xml')
except:
	print "\n\tProblem opening full struct\n"
	raw_input("Press Enter to close")
	

print "reading full-struct.xml"



def getChapterStructure(chap) :
	chapter_id =  chap.getAttribute('id')
	chapter_title = chap.getAttribute('title')
	return "<tr><td>" + chapter_id + "</td><td></td><td></td><td>" + chapter_title + "</td><td></td></tr>"
	
def getSectionsStructure(sect) :
	section_id =  sect.getAttribute('id')
	section_title = sect.getAttribute('title')
	return "<tr><td></td><td>" + section_id + "</td><td></td><td>" + section_title + "</td><td></td></tr>"

def getClipStructure(clip) :
	clip_id =  clip.getAttribute('id')
	clip_title = clip.getAttribute('title')
	return "<tr><td></td><td></td><td>" + clip_id + "</td><td>" + clip_title + "</td><td></td></tr>"
	
def getClipData(clip) :
	segs = clip.getElementsByTagName("seg")
	num_segs = len(segs)
	s = "<p>Number of Segs: " + str(num_segs) + "</p><table>"
	for seg in segs:
		s += getSeg(seg)
	s += "</table>"
	return s;

	
	
def getSeg(seg) :
	seg_id = seg.getAttribute('id')
	args = seg.getElementsByTagName("args")
	seg_text = args[0].getAttribute('text')
	arg_table = getArgs(args[0])
	return "<tr><td>" + seg_id + "</td><td>" + seg_text + "</td><td>" +  arg_table + "</td><td></td><td></td><td></td></tr>"

def getArgs(arg_node) :
	s = "\n<table>"
	for attribute in arg_node.attributes.keys() : 
		s += "<tr><td>" + attribute + "</td><td>" +  arg_node.attributes [ attribute ].nodeValue + "</td></tr>"	
	s += "</table>"
	return s
	
def getHtmlHead(sTitle) :
	html_head = "<html>\n"
	html_head += "<head>\n"
	html_head += "<title>" + sTitle + "</title>\n"
	html_head += "<style>"
	html_head += "td{\n"
	html_head += "width:140px;\n"
	html_head += "border: 1px solid;\n"
	html_head += "vertical-align:top;\n"
	html_head += "}\n"
	html_head += "</style>\n"
	html_head += "</head>\n"
	html_head += "<body>\n"
	return html_head


	



html = getHtmlHead("Structure")
#get all our chapters
chapters_xml = struct.getElementsByTagName("CHAPTER")

structure_output = "<h2>instructions: </h2><p>Open in Internet Explorer and copy this table into the structure.doc select the same amount of lines or select more and delete the repeats. Smiley to creat empty clip docs. </p><table>"





#loop through the chapters
for chapter in chapters_xml :
	structure_output +=  getChapterStructure(chapter)
	
	chapter_id =  chapter.getAttribute('id')
	
	
	#loop through the sections
	section_xml = chapter.getElementsByTagName("SECTION")
	for section in section_xml :
		structure_output += getSectionsStructure(section)
		section_id =  section.getAttribute('id')
		
		
		#loop through clips
		clip_xml = chapter.getElementsByTagName("clip")
		for clip in clip_xml : 
			structure_output += getClipStructure(clip)
			
			clip_id =  clip.getAttribute('id')
			clip_full_id = chapter_id + "_" + section_id  + "_" +clip_id 
			clip_output = getHtmlHead(clip_full_id)
			clip_output += "<h1>" + clip_full_id  + "</h1><h2>instructions: </h2><p>Open in Internet Explorer and copy this table into the clip doc select the same amount of lines or select more and delete the repeats. Then smiley make sure you have done structure first. </p>"

			clip_output += getClipData(clip)
					
			try:
				clip_file = clip_full_id + '.html'
				print "writing "+clip_file
				
				clip_filename = os.path.join(os.curdir, clip_file)
				clip_output_file = open(clip_filename, 'w')
				clip_output_file.write(clip_output)
				clip_output_file.close()
			except:
				print "error writting "+clip_file
			
			
			

structure_output += "</table>"
html += structure_output
html += "</body></html>"

#write the html file
try:
	print "writing structure.html"
	filename = os.path.join(os.curdir, 'structure.html')
	output_file = open(filename, 'w')
	output_file.write(html)
	output_file.close()
except:
	print "error writting full-struct.html"

raw_input("Press Enter to close")
