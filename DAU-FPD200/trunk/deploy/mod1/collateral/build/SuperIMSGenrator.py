from __future__ import generators
from xml.dom.minidom import Document
from xml.dom.minidom import parse, parseString
import time, sys, os, codecs
import string
from xml.sax.saxutils import escape
#   imsmanifest.xml assembler
#   -------------------------
#   input:  deploy forlder
#   output: imsmanifest.xml
# os.chdir('../..') # Uncomment this line for editing in IDLE

# recursive function that gets all the resources file names
def getResources(top = ".", depthfirst = True):
    import os, stat, types
    names = os.listdir(top)
    if not depthfirst:
        yield top, names
    for name in names:
        try:
            st = os.lstat(os.path.join(top, name))
        except os.error:
            continue
        if stat.S_ISDIR(st.st_mode):
            for (newtop, children) in getResources (os.path.join(top, name), depthfirst):
                yield newtop, children
    if depthfirst:
        yield top, names

def files_only(path):
	return [filename for filename in os.listdir(path) 
	if os.path.isfile(os.path.join(path, filename))] 


def makeReourceList(top, depthfirst=False):
	ret = []
	nInt = 3
	for top, names in getResources(top):
		usePath = formatContentPath(top)
		for name in names:
			if string.find(name, ".") != -1:
				if name != "scoIndex.html" and name.find(".xsd") < 0:
					ret.append('\t\t\t<resource identifier="R_S100001_%02d" type="webcontent" adlcp:scormtype="sco" href="%s" />\n'%(nInt,"co"+usePath+"/"+escape(name)))
					nInt = nInt + 1
			
	return ''.join(ret)

def formatContentPath(path):
	strippedPath = string.lstrip(path, "~temp/scorm/")
	formatedPath = string.lstrip(string.replace(strippedPath, "\\", "/"), "/");
	return formatedPath
	

def makeIMSManifest(contentPath, depthfirst=False): 
	clipPath = "collateral/templates/scorm1.2/imsmanifest.xml"
	if os.path.exists(clipPath):
		print "reading template"
		
		manifesto = codecs.open(clipPath ,'r', 'UTF-8')
		manifestoText = manifesto.read()
		manifesto.close()
		
		print manifestoText
		
		newManifesto = string.replace(manifestoText, "<!-- resource list -->", makeReourceList(contentPath));
		
		if sys.argv[1:]:
			courseTitle = sys.argv[1]
		else:
			courseTitle = "untitled"
		newManifesto = string.replace(newManifesto, '[COURSE TITLE]', courseTitle);
		
		manifesto_filename = "~temp/scorm/imsmanifest.xml"
		manifesto_output_file = open(manifesto_filename, 'w')
		manifesto_output_file.write(newManifesto)
		manifesto_output_file.close()
		
		
	else:
		print "unable to read imsmanifest template"


makeIMSManifest("~temp/scorm")















