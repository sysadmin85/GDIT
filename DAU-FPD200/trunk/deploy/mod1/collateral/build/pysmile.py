from xml.etree.ElementTree import ElementTree, Element, SubElement
import xml.etree.ElementTree as etree
import time, sys, os, platform, codecs

class fullstruct(object):

    def __init__(self,filename):
        print 'Python version: ', platform.python_version()
        print 'Default encoding: ' + sys.getdefaultencoding()
        print 'stdout encoding: ' + str(sys.stdout.encoding)
        self.app = Element('app', attrib = {'appVer' : '1.0', 'id' : 'Enspire Learning'})
        mode = SubElement(self.app,'mode', attrib = {'bandwidth' : 'low', 'connection' : 'offline'})
        chapters = SubElement(self.app, 'chapters')

        fileObject = codecs.open(filename,'r', 'cp1252')
                
        for line in fileObject.readlines():
            if line.strip():
                node = line.split(':', 1)
                if node[0].upper() == 'CHAPTER':
                    if node[1]:
                        attribs = node[1].split('=',1)
                        chapid = attribs[0]
                        title = attribs[1].strip()
                        chapter = SubElement(chapters, 'chapter', attrib = {'id' : chapid, 'title' : title})
                    else:
                        chapter = SubElement(chapters, 'chapter')
                        
                if node[0].upper() == 'SECTION':
                    if node[1]:
                        attribs = node[1].split('=',1)
                        sectid = attribs[0]
                        title = attribs[1].strip()
                        section = SubElement(chapter, 'section', attrib = {'id' : sectid, 'title' : title})
                    else:
                        section = SubElement(chapter, 'section')
 
                if node[0].upper() == 'CLIP':
                    if node[1]:
                        attribs = node[1].split('=',1)
                        clipid = attribs[0]
                        title = attribs[1].strip()
                        clipPath = 'app-info/xml-struct/' + chapid + '_' + sectid + '_' + clipid + '.xml'
                        if os.path.exists(clipPath):
                            xmlstruct = etree.parse(clipPath)
                            root = xmlstruct.getroot()
                            section.append(root)
                        else:
                            clip = SubElement(section, 'clip', attrib = {'id' : clipid, 'title' : title})
                    else:
                        clip = SubElement(section, 'clip')
                        
        # wrap it up
        #PI = etree.ProcessingInstruction('xml',"version='1.0'")
        #self.app.append(PI)
        self.doc = ElementTree(self.app)
        self.doc.write('full-struct.xml', encoding='utf-8')

        fileInfo = os.stat("full-struct.xml")
        lastmodDate = time.localtime(fileInfo[8])
        print time.strftime("File was updated on %c", lastmodDate)
        print "Current size is: ",fileInfo[6] / 1024 , "KB"

        if sys.platform == "win32":
            raw_input("Press Enter to close")
    
if __name__ == '__main__':
    # os.chdir('../../')
    print os.getcwd()
    fullstruct('app-info/structure.txt')
